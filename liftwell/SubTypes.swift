//  Created by Jesse Jones on 10/6/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import AVFoundation // for kSystemSoundID_Vibrate
import Foundation
import UIKit           // for UIColor

/// Sets vary (typically each week).
class CyclicRepsSubtype: ExerciseInfo {
    init(cycles: [Sets], reps: Int, restSecs: Int, advance: String?, advance2: String?) {
        self.cycles = cycles
        self.advance = advance
        self.advance2 = advance2
        
        self.weight = 0.0
        self.cycleIndex = 0
        self.restTime = restSecs
        self.reps = reps
    }
    
    required init(from store: Store) {
        cycles = []
        let count = store.getInt("cyclesCount")
        for i in 0..<count {
            let cycle: Sets = store.getObj("cycle\(i)")
            cycles.append(cycle)
        }
        let a = store.getStr("advance")
        self.advance = a != "" ? a : nil
        let a2 = store.getStr("advance2")
        self.advance2 = a2 != "" ? a2 : nil
        
        self.weight = store.getDbl("weight")
        self.cycleIndex = store.getInt("cycleIndex")
        self.restTime = store.getInt("restTime")
        self.reps = store.getInt("reps")
    }
    
    func save(_ store: Store) {
        store.addInt("cyclesCount", cycles.count)
        for (i, cycle) in cycles.enumerated() {
            store.addObj("cycle\(i)", cycle)
        }
        store.addStr("advance", advance ?? "")
        store.addStr("advanc2", advance2 ?? "")
        
        store.addDbl("weight", weight)
        store.addInt("cycleIndex", cycleIndex)
        store.addInt("restTime", restTime)
        store.addInt("reps", reps)
    }
    
    public func errors() -> [String] {
        var problems: [String] = []
        for sets in cycles {
            problems += sets.errors()
        }
        return problems
    }

    // ---- ExerciseInfo ----------------------------------------------------------------------
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

    func start(_ workout: Workout, _ exercise: Exercise) -> Exercise? {
        switch exercise.type {
        case .body(_): activities = cycles[cycleIndex].activities(weight)
        case .weights(let type): activities = cycles[cycleIndex].activities(weight, type.apparatus)
        }
        index = 0
        currentWorkout = workout.name
        return nil
    }
    
    func on(_ workout: Workout) -> Bool {
        return currentWorkout == workout.name
    }
    
    func label(_ exercise: Exercise) -> String {
        return exercise.name
    }
    
    func sublabel(_ exercise: Exercise) -> String {
        switch exercise.type {
        case .body(_): return cycles[cycleIndex].sublabel(nil, weight, reps)
        case .weights(let type): return cycles[cycleIndex].sublabel(type.apparatus, weight, reps)
        }
    }
    
    func prevLabel() -> (String, UIColor) {
        return ("", UIColor.black)  // TODO: implement this
    }
    
    func historyLabel() -> String {
        return ""  // TODO: implement this
    }
    
    func current(_ exercise: Exercise) -> Activity {
        return activities[index]
    }
    
    func restSecs() -> RestTime {
        return RestTime(autoStart: true, secs: restTime)
    }
    
    func restSound() -> UInt32 {
        return kSystemSoundID_Vibrate
    }
    
    func completions(_ exercise: Exercise) -> [Completion] {
        if index+1 < activities.count {
            return [Completion(title: "", info: "", callback: {() -> Void in self.doNext()})]
        } else {
            switch exercise.type {
            case .body(_): return [Completion(title: "", info: "", callback: {() -> Void in self.doMaintain()})]
            case .weights(let type):
                var result: [Completion] = []
                
                if let advance2 = advance2 {
                    result.append(Completion(title: "Advance x2", info: advance2, callback: {() -> Void in self.doAdvance(type.apparatus, 2)}))
                }
                if let advance = advance {
                    result.append(Completion(title: "Advance", info: advance, callback: {() -> Void in self.doAdvance(type.apparatus, 1)}))
                }
                result.append(Completion(title: "Maintain", info: "", callback: {() -> Void in self.doMaintain()}))
                
                return result
            }
        }
    }
    
    func finalize(_ tag: String) {
        // TODO: append results
    }
    
    func reset() {
        index = 0
    }
    
    private func doNext() {
        index += 1
    }
    
    private func doAdvance(_ apparatus: Apparatus, _ by: Int) {
        // TODO: update history
        let (min, max) = cycles[cycleIndex].repRange()
        if reps + 1 > max {
            let w = Weight(weight, apparatus)
            reps = min
            weight = w.nextWeight()
        } else {
            reps += 1
        }
    }
    
    private func doMaintain() {
        // TODO: update history
    }

    var cycles: [Sets]
    var advance: String?    // prompt that allows the user to advance reps or weight, note that deloads are handled at the program level
    var advance2: String?   // allows the user to advance by twice as much
    
    var weight: Double         // starts out at 0.0
    var cycleIndex: Int
    var restTime: Int
    var reps: Int           // this only applies when minReps < maxReps, also this can be less than minReps
    
    private var currentWorkout = ""
    private var activities: [Activity] = []
    private var index: Int = 0
}

/// As many reps as possible for each set.
class MaxRepsSubType: ExerciseInfo {
    init(numSets: Int, goalReps: Int, restSecs: Int, restAtEnd: Bool) {
        self.numSets = numSets
        self.currentReps = 5*numSets
        self.goalReps = goalReps
        self.restAtEnd = restAtEnd
        
        self.weight = 0.0
        self.restTime = restSecs
    }
    
    required init(from store: Store) {
        self.numSets = store.getInt("numSets")
        self.currentReps = store.getInt("currentReps")
        self.goalReps = store.getInt("goalReps")
        self.restAtEnd = store.getBool("restAtEnd")

        self.weight = store.getDbl("weight")
        self.restTime = store.getInt("restTime")
    }
    
    func save(_ store: Store) {
        store.addInt("numSets", numSets)
        store.addInt("currentReps", currentReps)
        store.addInt("goalReps", goalReps)
        store.addBool("restAtEnd", restAtEnd)

        store.addDbl("weight", weight)
        store.addInt("restTime", restTime)
    }
    
    public func errors() -> [String] {
        var problems: [String] = []
        if goalReps <= 0 {
            problems += ["subtype.goalReps should be greater than zero."]
        }
        return problems
    }
    
    // TODO: should we have methods to return number of activities and the nth activity?
    // TODO: Exercise could update activity per completed (or maybe call an updateActivity method)
    // TODO: Exercise could reset completed
    
    // ---- ExerciseInfo ----------------------------------------------------------------------
    var state: ExerciseState {
        get {
            if numSets == 0 {
                return .error("There is nothing to do")
            } else if setIndex == 0 {
                return .started
            } else if setIndex == numSets {
                return .finished
            } else {
                return .underway
            }
        }
    }
    
    func start(_ workout: Workout, _ exercise: Exercise) -> Exercise? {
        setIndex = 0
        completed = []
        currentWorkout = workout.name
        return nil
    }
    
    func on(_ workout: Workout) -> Bool {
        return currentWorkout == workout.name
    }
    
    func label(_ exercise: Exercise) -> String {
        return exercise.name
    }
    
    func sublabel(_ exercise: Exercise) -> String {
        let w = weightStr(exercise)
        if w.isEmpty {
            return "\(currentReps) reps"
        } else {
            return "\(currentReps) reps @ \(w)"
        }
    }
    
    func prevLabel() -> (String, UIColor) {
        return ("", UIColor.black)  // TODO: implement this
    }
    
    func historyLabel() -> String {
        return ""  // TODO: implement this
    }
    
    func current(_ exercise: Exercise) -> Activity {
        let currentTotal = completed.reduce(0, {$0 + $1})
        let expected = completed.count < numSets ? (currentReps - currentTotal)/(numSets - completed.count) : 0
        let st = (setIndex+1 <= numSets ? "\(expected > 0 ? expected : 1)+ " : "") + "(\(currentReps)) reps"

        let tt = setIndex+1 <= numSets ? "Set \(setIndex+1) of \(numSets)" : "Set \(numSets) of \(numSets)"
        
        let wt = weightStr(exercise)
        let r = completed.map({"\($0)"})
        let dt = (!completed.isEmpty ? r.joined(separator: ", ") + "" : "") + " (\(currentTotal)) reps"
        return Activity(
            title: tt,
            subtitle: st,
            amount: wt,
            details: dt,
            buttonName: setIndex+1 > numSets ? "Done" : "Next",
            showStartButton: true,
            color: nil)
    }
    
    func restSecs() -> RestTime {
        return RestTime(autoStart: true, secs: restTime)
    }
    
    func restSound() -> UInt32 {
        return kSystemSoundID_Vibrate
    }
    
    func completions(_ exercise: Exercise) -> [Completion] {
        let currentTotal = completed.reduce(0, {$0 + $1})
        let expected = (currentReps - currentTotal)/(numSets - completed.count)
        
        var result: [Completion] = []
        for count in max(expected - 4, 0)...(expected+4) {
            if count <= expected {
                if count == 1 {
                    result.append(Completion(title: "1 rep", info: "", callback: {() -> Void in self.doCompleted(count)}))
                } else {
                    result.append(Completion(title: "\(count) reps", info: "", callback: {() -> Void in self.doCompleted(count)}))
                }
            } else {
                if currentTotal + count <= currentReps {
                    result.append(Completion(title: "\(count) reps", info: "", callback: {() -> Void in self.doCompleted(count)}))
                } else {
                    result.append(Completion(title: "\(count) reps (extra)", info: "", callback: {() -> Void in self.doCompleted(count)}))
                }
            }
        }
        
        return result
    }
    
    func finalize(_ tag: String) {
        // TODO: append results
    }
    
    func reset() {
        setIndex = 0
        completed = []
    }
    
    private func doCompleted(_ count: Int) {
        // TODO: update history (when finished)
        completed.append(count)
        setIndex += 1
    }
    
    private func weightStr(_ exercise: Exercise) -> String {
        if weight > 0.0 {
            switch exercise.type {
            case .body(_): return Weight.friendlyUnitsStr(weight)
            case .weights(let type):
                let w = Weight(weight, type.apparatus).closest()
                return w.text
            }
        } else {
            return ""
        }
    }

    var numSets: Int
    var currentReps: Int
    var goalReps: Int       // typically user would then switch to a harder version of the exercise or add weights
    var restAtEnd: Bool

    var weight: Double      // starts out at 0.0
    var restTime: Int
    
    private var currentWorkout = ""
    private var setIndex: Int = 0
    private var completed: [Int] = []
}

/// Simple scheme where number of sets if fixed.
class RepsSubType: ExerciseInfo {
    init(sets: Sets, reps: Int, restSecs: Int, advance: String?, advance2: String?) {
        self.sets = sets
        self.advance = advance
        self.advance2 = advance2
        
        self.weight = 0.0
        self.restTime = restSecs
        self.reps = reps
    }
    
    required init(from store: Store) {
        self.sets = store.getObj("sets")
        let a = store.getStr("advance")
        self.advance = a != "" ? a : nil
        let a2 = store.getStr("advance2")
        self.advance2 = a2 != "" ? a2 : nil
        
        self.weight = store.getDbl("weight")
        self.restTime = store.getInt("restTime")
        self.reps = store.getInt("reps")
    }
    
    func save(_ store: Store) {
        store.addObj("sets", sets)
        store.addStr("advance", advance ?? "")
        store.addStr("advanc2", advance2 ?? "")
        
        store.addDbl("weight", weight)
        store.addInt("restTime", restTime)
        store.addInt("reps", reps)
    }
    
    public func errors() -> [String] {
        return sets.errors()
    }
    
    // ---- ExerciseInfo ----------------------------------------------------------------------
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
    
    func start(_ workout: Workout, _ exercise: Exercise) -> Exercise? {
        switch exercise.type {
        case .body(_): activities = sets.activities(weight)
        case .weights(let type): activities = sets.activities(weight, type.apparatus)
        }
        index = 0
        currentWorkout = workout.name
        return nil
    }
    
    func on(_ workout: Workout) -> Bool {
        return currentWorkout == workout.name
    }
    
    func label(_ exercise: Exercise) -> String {
        return exercise.name
    }
    
    func sublabel(_ exercise: Exercise) -> String {
        switch exercise.type {
        case .body(_): return sets.sublabel(nil, weight, reps)
        case .weights(let type): return sets.sublabel(type.apparatus, weight, reps)
        }
    }
    
    func prevLabel() -> (String, UIColor) {
        return ("", UIColor.black)  // TODO: implement this
    }
    
    func historyLabel() -> String {
        return ""  // TODO: implement this
    }
    
    func current(_ exercise: Exercise) -> Activity {
        return activities[index]
    }
    
    func restSecs() -> RestTime {
        return RestTime(autoStart: true, secs: restTime)
    }
    
    func restSound() -> UInt32 {
        return kSystemSoundID_Vibrate
    }
    
    func completions(_ exercise: Exercise) -> [Completion] {
        if index+1 < activities.count {
            return [Completion(title: "", info: "", callback: {() -> Void in self.doNext()})]
        } else {
            switch exercise.type {
            case .body(_): return [Completion(title: "", info: "", callback: {() -> Void in self.doMaintain()})]
            case .weights(let type):
                var result: [Completion] = []
                
                if let advance2 = advance2 {
                    result.append(Completion(title: "Advance x2", info: advance2, callback: {() -> Void in self.doAdvance(type.apparatus, 2)}))
                }
                if let advance = advance {
                    result.append(Completion(title: "Advance", info: advance, callback: {() -> Void in self.doAdvance(type.apparatus, 1)}))
                }
                result.append(Completion(title: "Maintain", info: "", callback: {() -> Void in self.doMaintain()}))
                
                return result
            }
        }
    }
    
    func finalize(_ tag: String) {
        // TODO: append results
    }
    
    func reset() {
        index = 0
    }
    
    private func doNext() {
        index += 1
    }
    
    private func doAdvance(_ apparatus: Apparatus, _ by: Int) {
        // TODO: update history
        let (min, max) = sets.repRange()
        if reps + 1 > max {
            let w = Weight(weight, apparatus)
            reps = min
            weight = w.nextWeight()
        } else {
            reps += 1
        }
    }
    
    private func doMaintain() {
        // TODO: update history
    }
    
    var sets: Sets
    var advance: String?    // prompt that allows the user to advance reps or weight
    var advance2: String?   // allows the user to advance by twice as much
    
    var weight: Double      // starts out at 0.0
    var restTime: Int
    var reps: Int           // this only applies when minReps < maxReps, also this can be less than minReps
    
    private var currentWorkout = ""
    private var activities: [Activity] = []
    private var index: Int = 0
}

// Exercise is performed for a specified duration.
class TimedSubType: ExerciseInfo {
    init(numSets: Int, currentTime: Int, targetTime: Int?, restSecs: Int, advance: String?, advance2: String?) {
        self.numSets = numSets
        self.currentTime = currentTime
        self.targetTime = targetTime
        self.advance = advance
        self.advance2 = advance2
        
        self.weight = 0.0
        self.restTime = restSecs
    }
    
    required init(from store: Store) {
        self.numSets = store.getInt("numSets")
        let t = store.getInt("targetTime")
        self.targetTime = t > 0 ? t : nil
        let a = store.getStr("advance")
        self.advance = a != "" ? a : nil
        let a2 = store.getStr("advance2")
        self.advance2 = a2 != "" ? a2 : nil
        
        self.weight = store.getDbl("weight")
        self.currentTime = store.getInt("currentTime")
        self.restTime = store.getInt("restTime")
    }
    
    func save(_ store: Store) {
        store.addInt("numSets", numSets)
        store.addInt("targetTime", targetTime ?? 0)
        store.addStr("advance", advance ?? "")
        store.addStr("advanc2", advance2 ?? "")
        
        store.addDbl("weight", weight)
        store.addInt("currentTime", currentTime)
        store.addInt("restTime", restTime)
    }
    
    public func errors() -> [String] {
        var problems: [String] = []
        if numSets <= 0 {
            problems += ["subtype.numSets should be greater than zero."]
        }
        return problems
    }

    // ---- ExerciseInfo ----------------------------------------------------------------------
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
    
    func start(_ workout: Workout, _ exercise: Exercise) -> Exercise? {
        var w = ""
        var p = ""
        if weight > 0 {
            switch exercise.type {
            case .body(_): w = Weight.friendlyUnitsStr(weight)
            case .weights(let type):
                let c = Weight(weight, type.apparatus).closest()
                w = c.text
                p = c.plates
            }
        }

        activities = []
        for i in 0..<numSets {
            activities.append(Activity(
                title: "Set \(i+1) of \(numSets)",
                subtitle: "",
                amount: w,
                details: p,
                buttonName: "Next",
                showStartButton: true,
                color: nil))
        }

        index = 0
        currentWorkout = workout.name
        return nil
    }
    
    func on(_ workout: Workout) -> Bool {
        return currentWorkout == workout.name
    }
    
    func label(_ exercise: Exercise) -> String {
        return exercise.name
    }
    
    func sublabel(_ exercise: Exercise) -> String {
        return secsToShortDurationName(Double(currentTime))
    }
    
    func prevLabel() -> (String, UIColor) {
        return ("", UIColor.black)  // TODO: implement this
    }
    
    func historyLabel() -> String {
        return ""  // TODO: implement this
    }
    
    func current(_ exercise: Exercise) -> Activity {
        return activities[index]
    }
    
    func restSecs() -> RestTime {
        return RestTime(autoStart: true, secs: restTime)
    }
    
    func restSound() -> UInt32 {
        return kSystemSoundID_Vibrate
    }
    
    func completions(_ exercise: Exercise) -> [Completion] {
        return [Completion(title: "", info: "", callback: {() -> Void in self.doMaintain()})]
    }
    
    func finalize(_ tag: String) {
        // TODO: append results
    }
    
    func reset() {
        index = 0
    }
    
    private func doMaintain() {
        // TODO: update history
    }
    
    var numSets: Int
    var targetTime: Int?
    var advance: String?    // prompt that allows the user to advance reps or weight
    var advance2: String?   // allows the user to advance by twice as much
    
    var weight: Double         // starts out at 0.0
    var currentTime: Int
    var restTime: Int
    
    private var currentWorkout = ""
    private var activities: [Activity] = []
    private var index: Int = 0
}
