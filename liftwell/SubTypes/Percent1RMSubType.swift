//  Created by Jesse Jones on 12/2/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import AVFoundation // for kSystemSoundID_Vibrate
import Foundation
import UIKit           // for UIColor
import os.log

/// Uses reps and weight so that the estimated 1RM is a percentage of the 1RM last lifted for another exercise.
/// Note that this version assumes that Percent1RMSubType is using variable reps.
class Percent1RMSubType: ExerciseInfo {
    private typealias `Self` = Percent1RMSubType
    
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
    
    init(_ sets: Sets, percent: Double, other: String, restSecs: Int) {
        self.percent = percent
        self.otherName = other
        self.originalSets = sets
        self.restTime = restSecs

        self.sets = Sets([], [])    // start will set these for real
        self.weight = 0.0
        self.reps = 0
    }
    
    required init(from store: Store) {
        self.percent = store.getDbl("percent", ifMissing: 0.94)
        self.otherName = store.getStr("otherName")
        self.originalSets = store.getObj("originalSets", ifMissing: Sets([], []))
        self.sets = store.getObj("sets")
        self.weight = store.getDbl("weight")
        self.reps = store.getInt("reps")
        self.restTime = store.getInt("restTime")

        self.activities = store.getObjArray("activities")
        self.numWarmups = store.getInt("numWarmups")
        self.currentWorkout = store.getStr("currentWorkout")
        self.index = store.getInt("index")
    }
    
    func save(_ store: Store) {
        store.addDbl("percent", percent)
        store.addStr("otherName", otherName)
        store.addObj("originalSets", originalSets)
        store.addObj("sets", sets)
        store.addDbl("weight", weight)
        store.addInt("reps", reps)
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
    
    func errors(_ exercise: Exercise) -> [String] {
        var errors = originalSets.errors()
        let (min, max) = originalSets.repRange(currentReps: nil)
        if min == max {
            errors.append("Expected variable reps, e.g. 4-8.")
        }
        if let last = originalSets.worksets.last, last.amrap {
            errors.append("Percent subtype doesn't support amrap sets.")
        }
        if getOtherType(otherName) == nil {
            errors.append("\(otherName) isn't using an apparatus.")
        }
        return errors
    }

    func sync(_ program: Program, _ savedExercise: Exercise) {
        (sets, weight, reps) = doBuildSets()
    }
    
    func start(_ workout: Workout, _ exercise: Exercise) -> (Exercise, String)? {
        (sets, weight, reps) = doBuildSets()
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
        if let type = getOtherType(otherName) {
            return sets.sublabel(type.apparatus, weight, reps)
        } else {
            return ""
        }
    }
    
    func prevLabel(_ exercise: Exercise) -> (String, UIColor) {
        if let myResults = doGetResults(exercise), let last = myResults.last {
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
        getDifficultly(view, {self.doFinalize(exercise, $0, self.reps, view, completion)})
    }
    
    func doFinalize(_ exercise: Exercise, _ tag: ResultTag, _ reps: Int, _ view: UIViewController, _ completion: @escaping () -> Void) {
        var myResults = doGetResults(exercise) ?? []
        let result = Result(tag, weight: weight, reps: reps)
        myResults.append(result)
        Self.results[exercise.formalName] = myResults
        
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
        if let type = getOtherType(otherName) {
            return sets.activities(weight, type.apparatus, currentReps: reps)
        } else {
            return (0, [])
        }
    }
    
    private func doBuildSets() -> (Sets, Double, Int) {
        let (reps, weight) = getRepsAndWeight()
        
        let warmups = originalSets.warmups
        let backoff = originalSets.backoff
        var worksets: [Set] = []
        
        for original in originalSets.worksets {
            worksets.append(Set(reps: reps, percent: 1.0, amrap: false, rest: original.rest))
        }
        
        return (Sets(warmups, worksets, backoff), weight, reps)
    }
    
    func getRepsAndWeight() -> (Int, Double) {
        let (min, max) = originalSets.repRange(currentReps: nil)
        var currentReps = max
        if let type = getOtherType(otherName) {
            if let oR = otherReps() {
                if var baseWeight = otherWeight(), let oneRepMax = get1RM(baseWeight, oR) {
                    let targetWeight = percent*oneRepMax
                    while let currentWeight = get1RM(baseWeight, currentReps), currentWeight > 0.0 {
                        if currentWeight <= targetWeight {
                            return (currentReps, baseWeight)
                        }
                        
                        currentReps -= 1
                        if currentReps < min {
                            currentReps = max
                            baseWeight = Weight(baseWeight, type.apparatus).prevWeight()
                        }
                    }
                }
            }
        }
        return (currentReps, percent*(otherWeight() ?? 0.0))
    }
    
    func otherWeight() -> Double? {
        if let other = currentProgram.findExercise(otherName), let type = getOtherType(otherName) {
            switch type.subtype {
            case .amrap(_):
                if let results = AMRAPSubType.results[other.formalName], let last = results.last {
                    return last.liftedWeight
                }
            case .amrap1RM(_):
                if let results = AMRAP1RMSubType.results[other.formalName], let last = results.last {
                    return last.liftedWeight
                }
            case .cyclic(_):
                if let results = CyclicRepsSubType.results[other.formalName], let last = results.last {
                    return last.liftedWeight
                }
            case .derived(_):
                if let results = DerivedSubType.results[other.formalName], let last = results.last {
                    return last.weight
                }
            case .emom(_):
                if let results = EMOMSubType.results[other.formalName], let last = results.last {
                    return last.liftedWeight
                }
            case .find(_):
                assert(false)
                return 0.0
            case .percent1RM(_):
                if let results = Percent1RMSubType.results[other.formalName], let last = results.last {
                    return last.weight
                }
            case .reps(_):
                if let results = RepsApparatusSubType.results[other.formalName], let last = results.last {
                    return last.liftedWeight
                }
            case .t1(_):
                if let results = T1RepsSubType.results[other.formalName], let last = results.last {
                    return last.liftedWeight
                }
            case .t1LP(_):
                if let results = T1LPRepsSubType.results[other.formalName], let last = results.last {
                    return last.liftedWeight
                }
            case .t2(_):
                if let results = T2RepsSubType.results[other.formalName], let last = results.last {
                    return last.liftedWeight
                }
            case .t3(_):
                if let results = T3RepsSubType.results[other.formalName], let last = results.last {
                    return last.liftedWeight
                }
            case .timed(_):
                return 0.0
            }
        }
        return nil
    }

    private func otherReps() -> Int? {
        if let other = currentProgram.findExercise(otherName), let type = getOtherType(otherName) {
            switch type.subtype {
            case .amrap(_):
                if let results = AMRAPSubType.results[other.formalName], let last = results.last {
                    return last.reps
                }
            case .amrap1RM(_):
                if let results = AMRAP1RMSubType.results[other.formalName], let last = results.last {
                    return last.reps
                }
            case .cyclic(_):
                if let results = CyclicRepsSubType.results[other.formalName], let last = results.last {
                    return last.reps
                }
            case .derived(_):
                if let results = DerivedSubType.results[other.formalName], let last = results.last {
                    return last.reps
                }
            case .emom(_):
                if let results = EMOMSubType.results[other.formalName], let last = results.last {
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
            case .t1LP(_):
                if let results = T1LPRepsSubType.results[other.formalName], let last = results.last {
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

    private func getOtherType(_ name: String) -> WeightsType? {
        if let other = currentProgram.findExercise(name) {
            switch other.type {     // type needs to be something that uses an apparatus
            case .weights(let type):
                return type
            case .body(_):
                break
            }
        }
        return nil
    }

    var percent: Double
    var otherName: String

    var originalSets: Sets  // as specified in the program, will use variable reps
    var sets: Sets          // what we want the user to lift, will use constant reps selected to make the 1RM match percent*other.1RM
    var weight: Double
    var reps: Int
    var restTime: Int
    
    var activities: [Activity] = []
    var numWarmups: Int = 0
    var currentWorkout = ""
    var index: Int = 0
    
    static var results: [String: [Result]] = [:]
}
