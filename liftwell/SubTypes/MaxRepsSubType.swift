//  Created by Jesse Jones on 10/6/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import AVFoundation // for kSystemSoundID_Vibrate
import Foundation
import UIKit           // for UIColor
import os.log

/// As many reps as possible for each set.
class MaxRepsSubType: ExerciseInfo {
    private typealias `Self` = MaxRepsSubType
    
    class Result: BaseResult, Storable {
        init(_ tag: ResultTag, weight: Double, currentReps: Int, completed: [Int]) {
            self.weight = weight
            self.currentReps = currentReps
            self.completed = completed
            super.init(tag)
        }
        
        required init(from store: Store) {
            self.weight = store.getDbl("weight")
            self.currentReps = store.getInt("currentReps")
            self.completed = store.getIntArray("completed")
            super.init(from: store)
        }
        
        override func save(_ store: Store) {
            store.addDbl("weight", weight)
            store.addInt("currentReps", currentReps)
            store.addIntArray("completed", completed)
            super.save(store)
        }
        
        var weight: Double
        var currentReps: Int
        var completed: [Int] = []
    }
    
    init(numSets: Int, startReps: Int, goalReps: Int, restSecs: Int, restAtEnd: Bool) {
        self.weight = 0.0
        self.startReps = startReps*numSets
        self.currentReps = 0
        self.restTime = restSecs
        
        self.numSets = numSets
        self.goalReps = goalReps
        self.restAtEnd = restAtEnd
    }
    
    required init(from store: Store) {
        weight = store.getDbl("weight")
        currentReps = store.getInt("currentReps")
        restTime = store.getInt("restTime")
        
        self.numSets = store.getInt("numSets")
        startReps = store.getInt("startReps", ifMissing: 5*self.numSets)
        self.goalReps = store.getInt("goalReps")
        self.restAtEnd = store.getBool("restAtEnd")
        self.completed = store.getIntArray("completed")
        
        self.currentWorkout = store.getStr("currentWorkout")
        self.setIndex = store.getInt("setIndex")
    }
    
    func save(_ store: Store) {
        store.addDbl("weight", weight)
        store.addInt("currentReps", currentReps)
        store.addInt("startReps", startReps)
        store.addInt("restTime", restTime)
        
        store.addInt("numSets", numSets)
        store.addInt("goalReps", goalReps)
        store.addBool("restAtEnd", restAtEnd)
        store.addIntArray("completed", completed)
        
        store.addStr("currentWorkout", currentWorkout)
        store.addInt("setIndex", setIndex)
    }
    
    func sync(_ program: Program, _ savedExercise: Exercise) {
        switch savedExercise.type {
        case .body(let saved):
            switch saved.subtype {
            case .maxReps(let savedSubtype):
                weight = savedSubtype.weight
                currentReps = savedSubtype.currentReps
                restTime = savedSubtype.restTime
                if numSets == savedSubtype.numSets && program.findWorkout(savedSubtype.currentWorkout) != nil {
                    completed = savedSubtype.completed
                    currentWorkout = savedSubtype.currentWorkout
                    setIndex = savedSubtype.setIndex
                }
                
            default: os_log("saved %@ subtype wasn't maxReps", savedExercise.name)
            }
        case .weights(_):
            os_log("saved %@ subtype wasn't body", savedExercise.name)
        }
    }
    
    func errors() -> [String] {
        var problems: [String] = []
        if goalReps <= 0 {
            problems += ["subtype.goalReps should be greater than zero."]
        }
        return problems
    }
    
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
    
    func start(_ workout: Workout, _ exercise: Exercise) -> (Exercise, String)? {
        setIndex = 0
        completed = []
        currentWorkout = workout.name
        return nil
    }
    
    func clone() -> ExerciseInfo {
        let store = Store()
        store.addObj("self", self)
        let result: Self = store.getObj("self")
        return result
    }
    
    func updated(_ exercise: Exercise) {
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
            if currentReps > 0 {
                return "\(currentReps) reps"
            } else {
                return ""
            }
        } else {
            if currentReps > 0 {
                return "\(currentReps) reps @ \(w)"
            } else {
                return "\(w)"
            }
        }
    }
    
    func prevLabel(_ exercise: Exercise) -> (String, UIColor) {
        let suffix = goalReps > 0 ? ". Goal is \(goalReps) reps." : ""
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
                return ("Previous was \(last.tag) x\(count)\(suffix)", UIColor.black)
            } else {
                return ("Previous was \(last.tag)\(suffix)", UIColor.black)
            }
        } else {
            return ("", UIColor.black)
        }
    }
    
    func historyLabel(_ exercise: Exercise) -> String {
        func makeLabel(_ result: Result) -> String {
            let reps = result.completed.map {"\($0)"}
            let sum = result.completed.reduce(0, {$0 + $1})
            var label = reps.joined(separator: ", ")
            if result.weight > 0.0 {
                label += " @ \(Weight.friendlyUnitsStr(result.weight))"
            }
            label += " (\(sum))"
            return label
        }
        
        var label = ""
        
        if let myResults = Self.results[exercise.formalName] {
            let count = myResults.count
            if count >= 1 {
                label = makeLabel(myResults[count - 1])
            }
            if count >= 2 {
                label += " and " + makeLabel(myResults[count - 2])
            }
            if count >= 3 {
                label += " and " + makeLabel(myResults[count - 3])
            }
        }
        
        return label
    }
    
    func current(_ exercise: Exercise) -> Activity {
        let reps = currentReps > 0 ? currentReps : startReps
        let currentTotal = completed.reduce(0, {$0 + $1})
        var expected = completed.count < numSets ? (reps - currentTotal)/(numSets - completed.count) : 0
        if currentTotal + (numSets - completed.count)*expected < reps {
            expected += 1
        }
        let st = (setIndex+1 <= numSets ? "\(expected > 0 ? expected : 1)+ " : "") + "(\(reps)) reps"
        
        let tt = setIndex+1 <= numSets ? "Set \(setIndex+1) of \(numSets)" : "Set \(numSets) of \(numSets)"
        
        let wt = weightStr(exercise)
        let r = completed.map({"\($0)"})
        let dt = (!completed.isEmpty ? r.joined(separator: ", ") + "" : "") + " (\(currentTotal)) reps"
        return Activity(
            title: tt,
            subtitle: st,
            amount: wt,
            details: currentTotal > 0 ? dt : "",
            buttonName: setIndex+1 > numSets ? "Done" : "Next",
            showStartButton: true,
            color: nil)
    }
    
    func restSecs() -> RestTime {
        return RestTime(autoStart: completed.count < numSets || restAtEnd, secs: restTime)
    }
    
    func restSound() -> UInt32 {
        return kSystemSoundID_Vibrate
    }
    
    func completions(_ exercise: Exercise) -> [Completion] {
        let currentTotal = completed.reduce(0, {$0 + $1})
        let reps = currentReps > 0 ? currentReps : startReps
        let expected = (reps - currentTotal)/(numSets - completed.count)
        let minReps = currentReps > 0 ? expected - 4 : 0
        let maxReps = currentReps > 0 ? expected + 4 : expected + 8

        var result: [Completion] = []
        for count in max(minReps, 0)...maxReps {
            if count <= expected {
                if count == 1 {
                    result.append(Completion(title: "1 rep", info: "", callback: {_,completion in self.doCompleted(count); completion()}))
                } else {
                    result.append(Completion(title: "\(count) reps", info: "", callback: {_,completion in self.doCompleted(count); completion()}))
                }
            } else {
                if currentTotal + count <= reps {
                    result.append(Completion(title: "\(count) reps", info: "", callback: {_,completion in self.doCompleted(count); completion()}))
                } else {
                    result.append(Completion(title: "\(count) reps (extra)", info: "", callback: {_,completion in self.doCompleted(count); completion()}))
                }
            }
        }
        
        return result
    }
    
    func finalize(_ exercise: Exercise, _ view: UIViewController, _ completion: @escaping () -> Void) {
        getDifficultly(view, {self.doFinalize(exercise, $0, view, completion)})
    }
    
    private func doFinalize(_ exercise: Exercise, _ tag: ResultTag, _ view: UIViewController, _ completion: @escaping () -> Void) {
        let result = Result(tag, weight: weight, currentReps: currentReps, completed: completed)
        
        var myResults = Self.results[exercise.formalName] ?? []
        myResults.append(result)
        Self.results[exercise.formalName] = myResults
        
        let sum = completed.reduce(0, {$0 + $1})
        if sum > currentReps {
            switch tag {
            case .veryEasy, .easy, .normal:
                currentReps = sum
                completion()
                
            case .hard:
                let advance = UIAlertAction(title: "Advance", style: .default) {_ in self.currentReps = sum; completion()}
                let maintain = UIAlertAction(title: "Maintain", style: .default) {_ in completion()}
                
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
                alert.addAction(advance)
                alert.addAction(maintain)
                alert.preferredAction = maintain
                view.present(alert, animated: true, completion: nil)
                
            case .failed:
                completion()
            }
        } else {
            completion()
        }
    }
    
    func reset() {
        setIndex = 0
        completed = []
    }
    
    private func doCompleted(_ count: Int) {
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
    var goalReps: Int       // typically user would then switch to a harder version of the exercise or add weights
    var restAtEnd: Bool
    
    static var results: [String: [Result]] = [:]
    
    var weight: Double      // starts out at 0.0
    var currentReps: Int
    var startReps: Int
    var restTime: Int
    
    var completed: [Int] = []
    private var currentWorkout = ""
    private var setIndex: Int = 0
}
