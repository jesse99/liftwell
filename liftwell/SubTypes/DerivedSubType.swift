//  Created by Jesse Jones on 12/23/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import AVFoundation // for kSystemSoundID_Vibrate
import Foundation
import UIKit           // for UIColor
import os.log

/// Percents are the percents of weight from another exercise.
class DerivedSubType: ExerciseInfo {
    private typealias `Self` = DerivedSubType
    
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
    
    init(_ sets: Sets, other: String, restSecs: Int) {
        self.sets = sets
        self.otherName = other
        self.restTime = restSecs
    }
    
    required init(from store: Store) {
        self.sets = store.getObj("sets")
        self.otherName = store.getStr("otherName")
        self.restTime = store.getInt("restTime")
        
        self.activities = store.getObjArray("activities")
        self.numWarmups = store.getInt("numWarmups")
        self.currentWorkout = store.getStr("currentWorkout")
        self.index = store.getInt("index")
    }
    
    func save(_ store: Store) {
        store.addObj("sets", sets)
        store.addStr("otherName", otherName)
        store.addInt("restTime", restTime)
        
        store.addObjArray("activities", activities) // TODO: generate
        store.addInt("numWarmups", numWarmups)
        store.addStr("currentWorkout", currentWorkout)
        store.addInt("index", index)
    }
    
    func clone() -> ExerciseInfo {
        let store = Store()
        store.addObj("self", self)
        let result: Self = store.getObj("self")
        return result
    }
    
    func errors() -> [String] {
        var errors = sets.errors()
        if getOtherType() == nil {
            errors.append("\(otherName) isn't using an apparatus.")
        }
        return errors
    }
    
    func sync(_ program: Program, _ savedExercise: Exercise) {
    }
    
    func start(_ workout: Workout, _ exercise: Exercise) -> (Exercise, String)? {
        index = 0
        currentWorkout = workout.name
        updated(exercise)
        return nil
    }
    
    func updated(_ exercise: Exercise) {
        (numWarmups, activities) = getActivities(exercise)
    }
    
    var state: ExerciseState {
        get {
            if activities.isEmpty {
                return .waiting
            } else if activities.count == 0 {
                return .error("There is nothing to do")
            } else if index == 0 {
                return .started
            } else if index == activities.count {
                return .finished
            } else {
                return .underway
            }
        }
    }
    
    func on(_ workout: Workout) -> Bool {
        return currentWorkout == workout.name
    }
    
    func label(_ exercise: Exercise) -> String {
        return exercise.name
    }
    
    func current(_ exercise: Exercise) -> Activity {
        return index < activities.count ? activities[index] : activities.last!
    }
    
    func restSound() -> UInt32 {
        return kSystemSoundID_Vibrate
    }
    
    func sublabel(_ exercise: Exercise) -> String {
        if let type = getOtherType(), let weight = otherWeight(), weight > 0.0 {
            return sets.sublabel(type.apparatus, weight, nil, limit: weight)
        } else {
            return ""
        }
    }
    
    func prevLabel(_ exercise: Exercise) -> (String, UIColor) {
        return ("", UIColor.black)
    }
    
    func historyLabel(_ exercise: Exercise) -> String {
        func historyLabel1(_ history: [(Int, Double)]) -> String {
            var labels: [String] = []
            
            for (reps, weight) in history {
                if reps == 1 {
                    labels.append("1 @ \(Weight.friendlyUnitsStr(weight))")
                } else {
                    labels.append("\(reps) @ \(Weight.friendlyUnitsStr(weight))")
                }
            }
            
            return makeHistoryFromLabels(labels)
        }
        
        if let myResults = doGetResults(exercise) {
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
        doFinalize(exercise, .normal, view, completion)
    }
    
    // TODO: if AMRAP then should use AMRAP result, also history should show AMRAP
    func doFinalize(_ exercise: Exercise, _ tag: ResultTag, _ view: UIViewController, _ completion: @escaping () -> Void) {
        if let type = getOtherType(), let baseWeight = otherWeight(), let last = sets.worksets.last {
            let w = Weight(last.percent*baseWeight, type.apparatus).closest()

            var myResults = doGetResults(exercise) ?? []
            let result = Result(tag, weight: w.weight, reps: last.maxReps)
            myResults.append(result)
            Self.results[exercise.formalName] = myResults
        }
        
        completion()
    }
    
    func doGetResults(_ exercise: Exercise) -> [Result]? {
        return Self.results[exercise.formalName]
    }
    
    func completions(_ exercise: Exercise) -> [Completion] {
        if index+1 < activities.count {
            return [Completion(title: "", info: "", callback: self.doNext)]
        } else {
            return [Completion(title: "", info: "", callback: self.doLast)]
        }
    }
    
    private func doNext(_ view: UIViewController, _ completion: @escaping () -> Void) {
        index += 1
        completion()
    }
    
    private func doLast(_ view: UIViewController, _ completion: @escaping () -> Void) {
        index = self.activities.count
        completion()
    }
    
    func reset() {
        index = 0
    }
    
    private func getActivities(_ exercise: Exercise) -> (Int, [Activity]) {
        if let type = getOtherType(), let baseWeight = otherWeight() {
            return sets.activities(baseWeight, type.apparatus, limit: baseWeight, currentReps: nil)
        } else {
            return (0, [])
        }
    }
    
    private func otherWeight() -> Double? {
        if let type = getOtherType() {
            switch type.subtype {
            case .amrap(let subtype):
                return subtype.getBaseWorkingWeight()
            case .cyclic(let subtype):
                return subtype.getBaseWorkingWeight()
            case .derived(let subtype):
                return subtype.otherWeight() ?? 0.0
            case .find(_):
                assert(false)
                return 0.0
            case .percent1RM(let subtype):
                return subtype.percent*(subtype.otherWeight() ?? 0.0)
            case .reps(let subtype):
                return subtype.getBaseWorkingWeight()
            case .t1(let subtype):
                return subtype.getBaseWorkingWeight()
            case .t2(let subtype):
                return subtype.getBaseWorkingWeight()
            case .t3(let subtype):
                return subtype.getBaseWorkingWeight()
            case .timed(_):
                return 0.0
            }
        }
        return nil
    }
    
    private func otherReps() -> Int? {
        if let other = currentProgram.findExercise(otherName), let type = getOtherType() {
            switch type.subtype {
            case .amrap(_):
                if let results = AMRAPSubType.results[other.formalName], let last = results.last {
                    return last.reps
                }
            case .cyclic(_):
                if let results = CyclicRepsSubtype.results[other.formalName], let last = results.last {
                    return last.reps
                }
            case .derived(_):
                if let results = DerivedSubType.results[other.formalName], let last = results.last {
                    return last.reps
                }
            case .find(_):
                assert(false)
                return 0
            case .percent1RM(_):
                if let results = Percent1RMSubType.results[other.formalName], let last = results.last {
                    return last.reps
                }
            case .reps(_):
                if let results = RepsApparatusSubType.results[other.formalName], let last = results.last {
                    return last.reps
                }
            case .t1(_):
                if let results = T1RepsSubType.results[other.formalName], let last = results.last {
                    return last.reps
                }
            case .t2(_):
                if let results = T2RepsSubType.results[other.formalName], let last = results.last {
                    return last.reps
                }
            case .t3(_):
                if let results = T3RepsSubType.results[other.formalName], let last = results.last {
                    return last.reps
                }
            case .timed(_):
                return 0
            }
        }
        return nil
    }
    
    private func getOtherType() -> WeightsType? {
        if let other = currentProgram.findExercise(otherName) {
            switch other.type {     // type needs to be something that uses an apparatus
            case .weights(let type):
                return type
            case .body(_):
                break
            }
        }
        return nil
    }
    
    var sets: Sets
    var otherName: String
    var restTime: Int
    
    var activities: [Activity] = []
    var numWarmups: Int = 0
    var currentWorkout = ""
    var index: Int = 0
    
    static var results: [String: [Result]] = [:]
}
