//  Created by Jesse Jones on 10/6/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import AVFoundation // for kSystemSoundID_Vibrate
import Foundation
import UIKit           // for UIColor
import os.log

/// Sets/reps/percents vary from week to week.
class CyclicRepsSubtype: ApparatusSubtype, ExerciseInfo {
    private typealias `Self` = CyclicRepsSubtype
    
    class Result: BaseResult, Storable {
        init(_ tag: ResultTag, weight: Double, cycleIndex: Int, reps: Int) {
            self.weight = weight
            self.cycleIndex = cycleIndex
            self.reps = reps
            super.init(tag)
        }
        
        required init(from store: Store) {
            self.weight = store.getDbl("weight")
            self.cycleIndex = store.getInt("cycleIndex")
            self.reps = store.getInt("reps")
            super.init(from: store)
        }
        
        override func save(_ store: Store) {
            store.addDbl("weight", weight)
            store.addInt("cycleIndex", cycleIndex)
            store.addInt("reps", reps)
            super.save(store)
        }
        
        var weight: Double
        var cycleIndex: Int
        var reps: Int
    }
    
    /// trainingMaxPercent is a percent of 1RM
    init(_ cycles: [Sets], restSecs: Int, trainingMaxPercent: Double? = nil) {
        self.cycleIndex = 0
        self.cycles = cycles
        
        let (minReps, maxReps) = cycles[0].repRange(minimum: nil)
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
    func start(_ workout: Workout, _ exercise: Exercise) -> Exercise? {
        if aweight.getWorkingWeight() == 0 {
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
        amrapReps = nil
        amrapTag = nil

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
        let weight = aweight.getWorkingWeight()
        switch exercise.type {
        case .body(_): (numWarmups, activities) = cycles[cycleIndex].activities(weight, minimum: workingReps)
        case .weights(let type): (numWarmups, activities) = cycles[cycleIndex].activities(weight, type.apparatus, minimum: workingReps)
        }
    }
    
    func sublabel(_ exercise: Exercise) -> String {
        let weight = aweight.getWorkingWeight()
        switch exercise.type {
        case .body(_): return cycles[cycleIndex].sublabel(nil, weight, workingReps)
        case .weights(let type): return cycles[cycleIndex].sublabel(type.apparatus, weight, workingReps)
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
        return RestTime(autoStart: cycles[cycleIndex].set(index > 0 ? index-1 : 0).rest, secs: restTime)
    }
    
    func finalize(_ exercise: Exercise, _ view: UIViewController, _ completion: @escaping () -> Void) {
        if let last = cycles[cycleIndex].worksets.last, last.amrap {
            getAMRAPResult(view, last.maxReps, {self.doFinalize(exercise, $1, $0, view, completion)})
            
        } else {
            let (_, max, _) = getBaseRepRange()
            getDifficultly(view, {self.doFinalize(exercise, $0, self.workingReps ?? max, view, completion)})
        }
    }
    
    private func doFinalize(_ exercise: Exercise, _ tag: ResultTag, _ reps: Int, _ view: UIViewController, _ completion: @escaping () -> Void) {
        let weight = aweight.getWorkingWeight()
        let result = Result(tag, weight: weight, cycleIndex: cycleIndex, reps: reps)
        
        var myResults = Self.results[exercise.formalName] ?? []
        myResults.append(result)
        Self.results[exercise.formalName] = myResults
        
        cycleIndex = (cycleIndex + 1) % cycles.count
        if cycleIndex == 0 {
            // Prompt user for advancement
            super.finalize(exercise, tag, view, completion)
        } else {
            completion()
        }
    }
    
    override func getBaseRepRange() -> (Int, Int, Int?) {
        let (min, max) = cycles[cycleIndex].repRange(minimum: nil)
        if let last = cycles[cycleIndex].worksets.last, last.amrap {
            return (min, max, last.maxReps)
        } else {
            return (min, max, nil)
        }
    }
    
    var cycleIndex: Int
    
    var cycles: [Sets]
    static var results: [String: [Result]] = [:]
}
