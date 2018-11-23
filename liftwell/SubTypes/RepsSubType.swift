//  Created by Jesse Jones on 10/6/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import AVFoundation // for kSystemSoundID_Vibrate
import Foundation
import UIKit           // for UIColor
import os.log

/// Simple scheme where number of sets is fixed.
class RepsSubType: ApparatusSubtype, ExerciseInfo {
    private typealias `Self` = RepsSubType
    
    class Result: BaseResult, Storable {
        init(_ tag: ResultTag, weight: Double, reps: Int) {
            self.weight = weight
            self.reps = reps
            super.init(tag)
        }
        
        required init(from store: Store) {
            self.weight = store.getDbl("weight")
            self.reps = store.getInt("reps")
            super.init(from: store)
        }
        
        override func save(_ store: Store) {
            store.addDbl("weight", weight)
            store.addInt("reps", reps)
            super.save(store)
        }
        
        var weight: Double
        var reps: Int
    }
    
    init(_ sets: Sets, restSecs: Int, trainingMaxPercent: Double? = nil) {
        self.sets = sets
        let (minReps, maxReps) = sets.repRange(minimum: nil)
        let reps = minReps < maxReps ? maxReps : nil
        super.init(reps: reps, restTime: restSecs, trainingMaxPercent: trainingMaxPercent)
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
        case .body(let saved):
            switch saved.subtype {
            case .reps(let savedSubtype): super.sync(program, savedSubtype, sameSets: same)
            default: os_log("saved %@ subtype wasn't Reps", savedExercise.name)
            }
        case .weights(let saved):
            switch saved.subtype {
            case .reps(let savedSubtype): super.sync(program, savedSubtype, sameSets: same)
            default: os_log("saved %@ subtype wasn't Reps", savedExercise.name)
            }
        }
    }
    
    func errors() -> [String] {
        return sets.errors()
    }
    
    // ---- ExerciseInfo ----------------------------------------------------------------------
    func start(_ workout: Workout, _ exercise: Exercise) -> Exercise? {
        let weight = aweight.getWorkingWeight()
        if weight == 0 {
            let newExercise = exercise.clone()
            switch newExercise.type {
            case .weights(let type):
                let newSubtype = FindWeightSubType(reps: getBaseRepRange().1, restSecs: restTime)
                type.subtype = .find(newSubtype)
                return newExercise
            default:
                break
            }
        }
        index = 0
        currentWorkout = workout.name
        updated(exercise)
        return nil
    }
    
    func clone() -> ExerciseInfo {
        let store = Store()
        store.addObj("self", self)
        let result: Self = store.getObj("self")
        return result
    }
    
    func updated(_ exercise: Exercise) {
        (numWarmups, activities) = getActivities(exercise)
    }
    
    func sublabel(_ exercise: Exercise) -> String {
        let weight = aweight.getWorkingWeight()
        switch exercise.type {
        case .body(_): return sets.sublabel(nil, weight, workingReps)
        case .weights(let type): return sets.sublabel(type.apparatus, weight, workingReps)
        }
    }
    
    func prevLabel(_ exercise: Exercise) -> (String, UIColor) {
        if let myResults = Self.results[exercise.formalName], let last = myResults.last {
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
        } else {
            return ("", UIColor.black)
        }
    }
    
    func historyLabel(_ exercise: Exercise) -> String {
        if let myResults = Self.results[exercise.formalName] {
            let history = myResults.map {($0.reps, $0.weight)}
            return historyLabel1(history)
        }
        return ""
    }
    
    func restSecs() -> RestTime {
        // note that autoStart is only used after index is incremented
        return RestTime(autoStart: sets.set(index > 0 ? index-1 : 0).rest, secs: restTime)
    }
    
    func finalize(_ exercise: Exercise, _ view: UIViewController, _ completion: @escaping () -> Void) {
        if let last = sets.worksets.last, last.amrap {
            getAMRAPResult(view, last.maxReps, {self.doFinalize(exercise, $1, $0, view, completion)})

        } else {
            let (_, max) = getBaseRepRange()
            getDifficultly(view, {self.doFinalize(exercise, $0, self.workingReps ?? max, view, completion)})
        }
    }
    
    private func doFinalize(_ exercise: Exercise, _ tag: ResultTag, _ reps: Int, _ view: UIViewController, _ completion: @escaping () -> Void) {
        let weight = aweight.getWorkingWeight()
        let result = Result(tag, weight: weight, reps: reps)
        
        var myResults = Self.results[exercise.formalName] ?? []
        myResults.append(result)
        Self.results[exercise.formalName] = myResults
        
        super.finalize(exercise, tag, view, completion )
    }
    
    override func getBaseRepRange() -> (Int, Int) {
        return sets.repRange(minimum: nil)
    }
    
    private func getActivities(_ exercise: Exercise) -> (Int, [Activity]) {
        let weight = aweight.getWorkingWeight()
        switch exercise.type {
        case .body(_): return sets.activities(weight, minimum: workingReps)
        case .weights(let type): return sets.activities(weight, type.apparatus, minimum: workingReps)
        }
    }
    
    var sets: Sets
    static var results: [String: [Result]] = [:]
}
