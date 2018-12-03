//  Created by Jesse Jones on 11/24/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import AVFoundation // for kSystemSoundID_Vibrate
import Foundation
import UIKit           // for UIColor
import os.log

/// Sets/reps/percents vary from week to week.
class BaseCyclicRepsSubtype: BaseApparatusSubtype, ExerciseInfo {
    private typealias `Self` = BaseCyclicRepsSubtype
    
    class CyclicResult: BaseResult, Storable {
        init(_ tag: ResultTag, baseWeight: Double, liftedWeight: Double, cycleIndex: Int, reps: Int) {
            self.baseWeight = baseWeight
            self.liftedWeight = liftedWeight
            self.cycleIndex = cycleIndex
            self.reps = reps
            super.init(tag)
        }
        
        required init(from store: Store) {
            self.baseWeight = store.getDbl("weight")
            self.liftedWeight = store.getDbl("liftedWeight", ifMissing: baseWeight)
            self.cycleIndex = store.getInt("cycleIndex")
            self.reps = store.getInt("reps")
            super.init(from: store)
        }
        
        override func save(_ store: Store) {
            store.addDbl("weight", baseWeight)
            store.addDbl("liftedWeight", liftedWeight)
            store.addInt("cycleIndex", cycleIndex)
            store.addInt("reps", reps)
            super.save(store)
        }
        
        var baseWeight: Double
        var liftedWeight: Double
        var cycleIndex: Int
        var reps: Int
    }
    
    /// trainingMaxPercent is a percent of 1RM
    init(_ cycles: [Sets], restSecs: Int, trainingMaxPercent: Double? = nil) {
        self.cycleIndex = 0
        self.cycles = cycles
        
        let (minReps, maxReps) = cycles[0].repRange(currentReps: nil)
        let reps: Int? = minReps < maxReps ? maxReps : nil
        super.init(reps: reps, restTime: restSecs, trainingMaxPercent: trainingMaxPercent)
    }
    
    required init(from store: Store) {
        cycleIndex = store.getInt("cycleIndex")
        
        cycles = []
        let count = store.getInt("cyclesCount")
        for i in 0..<count {
            let cycle: Sets = store.getObj("cycle\(i)")
            cycles.append(cycle)
        }
        
        super.init(from: store)
    }
    
    override func save(_ store: Store) {
        store.addInt("cycleIndex", cycleIndex)
        
        store.addInt("cyclesCount", cycles.count)
        for (i, cycle) in cycles.enumerated() {
            store.addObj("cycle\(i)", cycle)
        }
        
        super.save(store)
    }
    
    func sync(_ program: Program, _ savedExercise: Exercise) {
        switch savedExercise.type {
        case .body(_):
            os_log("saved %@ subtype wasn't weights", savedExercise.name)
        case .weights(let saved):
            switch saved.subtype {
            case .cyclic(let savedSubtype):
                cycleIndex = savedSubtype.cycleIndex
                super.sync(program, savedSubtype, sameSets: cycles.count == savedSubtype.cycles.count)
            case .t1(let savedSubtype):
                cycleIndex = savedSubtype.cycleIndex
                super.sync(program, savedSubtype, sameSets: cycles.count == savedSubtype.cycles.count)
            case .t2(let savedSubtype):
                cycleIndex = savedSubtype.cycleIndex
                super.sync(program, savedSubtype, sameSets: cycles.count == savedSubtype.cycles.count)
            default:
                os_log("saved %@ subtype wasn't cyclic", savedExercise.name)
            }
        }
    }
    
    func errors() -> [String] {
        var problems: [String] = []
        for sets in cycles {
            problems += sets.errors()
        }
        return problems
    }
    
    // ---- ExerciseInfo ----------------------------------------------------------------------
    func start(_ workout: Workout, _ exercise: Exercise) -> (Exercise, String)? {
        if aweight.getBaseWorkingWeight() == 0 {
            let newExercise = exercise.clone()
            switch newExercise.type {
            case .weights(let type):
                let newSubtype = doCreateFindWeights(exercise)
                type.subtype = .find(newSubtype)
                return (newExercise, "Not completed")
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
    
    func doCreateFindWeights(_ exercise: Exercise) -> FindWeightSubType {
        return FindWeightSubType(reps: getBaseRepRange().1, restSecs: restTime)
    }
    
    func clone() -> ExerciseInfo {
        assert(false)
        return self
    }
    
    func updated(_ exercise: Exercise) {
        let weight = aweight.getBaseWorkingWeight()
        switch exercise.type {
        case .body(_): (numWarmups, activities) = cycles[cycleIndex].activities(weight, currentReps: workingReps)
        case .weights(let type): (numWarmups, activities) = cycles[cycleIndex].activities(weight, type.apparatus, worksetBias: worksetBias(), currentReps: workingReps)
        }
    }
    
    func sublabel(_ exercise: Exercise) -> String {
        let weight = aweight.getBaseWorkingWeight()
        switch exercise.type {
        case .body(_): return cycles[cycleIndex].sublabel(nil, weight, workingReps, worksetBias: worksetBias())
        case .weights(let type): return cycles[cycleIndex].sublabel(type.apparatus, weight, workingReps, worksetBias: worksetBias())
        }
    }
    
    func prevLabel(_ exercise: Exercise) -> (String, UIColor) {
        if let myResults = doGetResults(exercise), let last = myResults.last, let workset = cycles[cycleIndex].worksets.last {
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
        return RestTime(autoStart: cycles[cycleIndex].set(index > 0 ? index-1 : 0).rest, secs: restTime)
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
    
    func doGetResults(_ exercise: Exercise) -> [CyclicResult]? {
        assert(false)
        return []
    }
    
    override func getBaseRepRange() -> (Int, Int, Int?) {
        let (min, max) = cycles[cycleIndex].repRange(currentReps: nil)
        if let last = cycles[cycleIndex].worksets.last, last.amrap {
            return (min, max, last.maxReps)
        } else {
            return (min, max, nil)
        }
    }
    
    override func isWorkset(_ index: Int) -> Bool {
        return index > cycles[cycleIndex].warmups.count && index < cycles[cycleIndex].warmups.count + cycles[cycleIndex].worksets.count
    }
    
    var cycleIndex: Int
    var cycles: [Sets]
}
