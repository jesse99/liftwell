//  Created by Jesse Jones on 11/24/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import AVFoundation // for kSystemSoundID_Vibrate
import Foundation
import UIKit           // for UIColor
import os.log

/// Simple scheme where number of sets is fixed.
class BaseRepsApparatusSubType: BaseApparatusSubType, ExerciseInfo {
    private typealias `Self` = BaseRepsApparatusSubType
    
    class RepsResult: BaseResult, Storable {
        init(_ tag: ResultTag, baseWeight: Double, liftedWeight: Double, reps: Int) {
            self.baseWeight = baseWeight
            self.liftedWeight = liftedWeight
            self.reps = reps
            super.init(tag)
        }
        
        required init(from store: Store) {
            self.baseWeight = store.getDbl("weight")
            self.liftedWeight = store.getDbl("liftedWeight", ifMissing: baseWeight)
            self.reps = store.getInt("reps")
            super.init(from: store)
        }
        
        override func save(_ store: Store) {
            store.addDbl("weight", baseWeight)
            store.addDbl("liftedWeight", liftedWeight)
            store.addInt("reps", reps)
            super.save(store)
        }
        
        var baseWeight: Double
        var liftedWeight: Double
        var reps: Int
    }
    
    init(_ sets: Sets, restSecs: Int, trainingMaxPercent: Double? = nil) {
        self.sets = sets
        let (minReps, _) = sets.repRange(currentReps: nil)
        super.init(reps: minReps, restTime: restSecs, trainingMaxPercent: trainingMaxPercent)
    }
    
    required init(from store: Store) {
        self.sets = store.getObj("sets")
        super.init(from: store)
    }
    
    override func save(_ store: Store) {
        store.addObj("sets", sets)
        super.save(store)
    }
    
    func sync(_ program: Program, _ savedExercise: Exercise) {
        let exeExecercise = program.findExercise(savedExercise.name)
        let (_, exeActivities) = getActivities(exeExecercise ?? savedExercise)
        
        let (_, savedActivities) = getActivities(savedExercise)
        let same = exeActivities.count == savedActivities.count
        
        switch savedExercise.type {
        case .body(_):
            break               // there's nothing that we can use to sync with if the saved exercise doesn't have an apparatus
        case .weights(let saved):
            switch saved.subtype {
            case .amrap(let savedSubtype): super.sync(program, savedSubtype, sameSets: same)
            case .reps(let savedSubtype): super.sync(program, savedSubtype, sameSets: same)
            case .t3(let savedSubtype): super.sync(program, savedSubtype, sameSets: same)
            default: os_log("saved %@ subtype wasn't Reps", savedExercise.name)
            }
        }
    }
    
    func errors(_ exercise: Exercise) -> [String] {
        return sets.errors()
    }
    
    // ---- ExerciseInfo ----------------------------------------------------------------------
    func start(_ workout: Workout, _ exercise: Exercise) -> (Exercise, String)? {
        if needToFindWeight() {
            let newExercise = exercise.clone()
            let reps = sets.worksets.max(by: {$0.minReps < $1.minReps})?.minReps ?? 5
            switch newExercise.type {
            case .weights(let type):
                if let results = doGetResults(exercise), let result = results.last {
                    let newSubtype = FindWeightSubType(reps: reps, restSecs: restTime, prevWeight: result.liftedWeight)
                    type.subtype = .find(newSubtype)
                    return (newExercise, "")

                } else {
                    let newSubtype = FindWeightSubType(reps: reps, restSecs: restTime, prevWeight: nil)
                    type.subtype = .find(newSubtype)
                    return (newExercise, "Not completed")
                }
            default:
                break
            }
        }
        amrapReps = nil
        amrapTag = nil
        
        index = 0
        currentWorkout = workout.name
        updated(exercise)
        return nil
    }
    
    func needToFindWeight() -> Bool {
        let weight = getBaseWorkingWeight()
        return weight == 0
    }
    
    func clone() -> ExerciseInfo {
        assert(false)
        return self
    }
    
    func updated(_ exercise: Exercise) {
        (numWarmups, activities) = getActivities(exercise)
    }
    
    func sublabel(_ exercise: Exercise) -> String {
        if let apparatus = exercise.getApparatus() {
            let weight = getBaseWorkingWeight()
            return sets.sublabel(apparatus, weight, workingReps)
        }
        return ""
    }
        
    func prevLabel(_ exercise: Exercise) -> (String, UIColor) {
        if let myResults = doGetResults(exercise), let last = myResults.last, let workset = sets.worksets.last {
            if workset.amrap {
                // History will include the AMRAP reps and the tag is inferred from that so don't think we want anything here.
                return ("", UIColor.black)
                
            } else {
                var count = 0
                for result in myResults.reversed() {
                    if result.tag == last.tag {
                        count += 1
                    } else {
                        break
                    }
                }
                if count > 1 {
                    return ("Previous was \(last.tag) x\(count)", UIColor.black)
                } else {
                    return ("Previous was \(last.tag)", UIColor.black)
                }
            }
        } else {
            return ("", UIColor.black)
        }
    }
    
    func historyLabel(_ exercise: Exercise) -> String {
        if let myResults = doGetResults(exercise) {
            let history = myResults.map {($0.reps, $0.liftedWeight)}
            return historyLabel1(history)
        }
        return ""
    }
    
    func restSecs() -> RestTime {
        // note that autoStart is only used after index is incremented
        return RestTime(autoStart: sets.set(index > 0 ? index-1 : 0).rest, secs: restTime)
    }
    
    func finalize(_ exercise: Exercise, _ view: UIViewController, _ completion: @escaping () -> Void) {
        if let reps = amrapReps, let tag = amrapTag {
            self.doFinalize(exercise, tag, reps, view, completion)
            
        } else {
            let (_, max, _) = getBaseRepRange()
            getDifficultly(view, {self.doFinalize(exercise, $0, self.workingReps ?? max, view, completion)})
        }
    }
    
    func doFinalize(_ exercise: Exercise, _ tag: ResultTag, _ reps: Int, _ view: UIViewController, _ completion: @escaping () -> Void) {
        assert(false)
    }
    
    override func getBaseRepRange() -> (Int, Int, Int?) {
        let (min, max) = sets.repRange(currentReps: nil)
        if let last = sets.worksets.last, last.amrap {
            return (min, max, last.maxReps)
        } else {
            return (min, max, nil)
        }
    }
    
    override func isWorkset(_ index: Int) -> Bool {
        return index > sets.warmups.count && index < sets.warmups.count + sets.worksets.count
    }
    
    private func getActivities(_ exercise: Exercise) -> (Int, [Activity]) {
        if let apparatus = exercise.getApparatus() {
            let weight = getBaseWorkingWeight()
            return sets.activities(weight, apparatus, currentReps: workingReps)
        }
        return (0, [])
    }
    
    func doGetResults(_ exercise: Exercise) -> [RepsResult]? {
        assert(false)
        return []
    }

    var sets: Sets
}
