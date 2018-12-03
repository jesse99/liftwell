//  Created by Jesse Jones on 10/6/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import AVFoundation // for kSystemSoundID_Vibrate
import Foundation
import UIKit           // for UIColor
import os.log

/// Simple scheme where number of sets is fixed.
class RepsBodySubType: ExerciseInfo {
    private typealias `Self` = RepsBodySubType
    
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
    
    init(_ sets: Sets, restSecs: Int) {
        self.sets = sets
        let (minReps, maxReps) = sets.repRange(currentReps: nil)

        self.weight = 0.0
        self.workingReps = minReps < maxReps ? minReps : nil
        self.restTime = restSecs
    }
    
    required init(from store: Store) {
        self.sets = store.getObj("sets")

        self.weight = store.getDbl("weight")
        restTime = store.getInt("restTime")
        
        self.currentWorkout = store.getStr("currentWorkout")
        self.activities = store.getObjArray("activities")
        self.numWarmups = store.getInt("numWarmups")
        self.index = store.getInt("index")
        
        let reps = store.getInt("reps")
        let (min, max, _) = getBaseRepRange()
        if min < max {
            workingReps = reps == 0 ? min : reps
        } else {
            workingReps = reps == 0 ? nil : reps
        }
    }

    func clone() -> ExerciseInfo {
        let store = Store()
        store.addObj("self", self)
        let result: Self = store.getObj("self")
        return result
    }

    func save(_ store: Store) {
        store.addObj("sets", sets)

        store.addDbl("weight", weight)
        store.addInt("reps", workingReps ?? 0)
        store.addInt("restTime", restTime)
        
        store.addStr("currentWorkout", currentWorkout)
        store.addObjArray("activities", activities) // TODO: generate
        store.addInt("numWarmups", numWarmups)
        store.addInt("index", index)
    }
    
    func sync(_ program: Program, _ savedExercise: Exercise) {
        let exeExecercise = program.findExercise(savedExercise.name)
        let (_, exeActivities) = getActivities(exeExecercise ?? savedExercise)
        
        let (_, savedActivities) = getActivities(savedExercise)
        let sameSets = exeActivities.count == savedActivities.count
        
        switch savedExercise.type {
        case .body(let saved):
            switch saved.subtype {
            case .reps(let savedSubtype):
                weight = savedSubtype.weight
                restTime = savedSubtype.restTime
                
                let (min, max, _) = getBaseRepRange()  // need to be sure and check this in case the program has changed
                if min < max {
                    workingReps = savedSubtype.workingReps
                } else {
                    workingReps = nil
                }

                if sameSets && program.findWorkout(savedSubtype.currentWorkout) != nil {
                    currentWorkout = savedSubtype.currentWorkout
                    index = savedSubtype.index
                }
            default: os_log("saved %@ subtype wasn't Reps", savedExercise.name)
            }
        case .weights(_):
            assert(false)
        }
    }

    func errors() -> [String] {
        return sets.errors()
    }
    
    func start(_ workout: Workout, _ exercise: Exercise) -> (Exercise, String)? {
        amrapReps = nil
        amrapTag = nil
        
        index = 0
        currentWorkout = workout.name
        updated(exercise)
        return nil
    }
    
    func updated(_ exercise: Exercise) {
        (numWarmups, activities) = getActivities(exercise)
    }
    
    func sublabel(_ exercise: Exercise) -> String {
        switch exercise.type {
        case .body(_): return sets.sublabel(nil, weight, workingReps, worksetBias: 0)
        case .weights(_): assert(false); return ""
        }
    }
    
    func prevLabel(_ exercise: Exercise) -> (String, UIColor) {
        if let myResults = Self.results[exercise.formalName], let last = myResults.last, let workset = sets.worksets.last {
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
        if let myResults = Self.results[exercise.formalName] {
            let history = myResults.map {($0.reps, $0.weight)}
            var labels: [String] = []
            
            for (reps, weight) in history {
                if reps == 1 {
                    if weight > 0 {
                        labels.append("1 @ \(Weight.friendlyUnitsStr(weight))")
                    } else {
                        labels.append("1")
                    }
                } else {
                    if weight > 0 {
                        labels.append("\(reps) @ \(Weight.friendlyUnitsStr(weight))")
                    } else {
                        labels.append("\(reps)")
                    }
                }
            }
            
            return makeHistoryFromLabels(labels)
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
        let result = Result(tag, weight: weight, reps: reps)
        
        var myResults = Self.results[exercise.formalName] ?? []
        myResults.append(result)
        Self.results[exercise.formalName] = myResults
        
        presentFinalize(exercise, tag, view, completion )
    }
    
    func getBaseRepRange() -> (Int, Int, Int?) {
        let (min, max) = sets.repRange(currentReps: nil)
        if let last = sets.worksets.last, last.amrap {
            return (min, max, last.maxReps)
        } else {
            return (min, max, nil)
        }
    }
    
    func isWorkset(_ index: Int) -> Bool {
        return index > sets.warmups.count && index < sets.warmups.count + sets.worksets.count
    }
    
    private func getActivities(_ exercise: Exercise) -> (Int, [Activity]) {
        switch exercise.type {
        case .body(_): return sets.activities(weight, currentReps: workingReps)
        case .weights(_): assert(false); return (0, [])
        }
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
    
    func completions(_ exercise: Exercise) -> [Completion] {
        if index+1 < activities.count {
            return [Completion(title: "", info: "", callback: self.doNext)]
        } else {
            return [Completion(title: "", info: "", callback: self.doLast)]
        }
    }
    
    private func doNext(_ view: UIViewController, _ completion: @escaping () -> Void) {
        let (_, _, amrapReps) = getBaseRepRange()
        if let reps = amrapReps, isWorkset(index) && !isWorkset(index+1) {
            getAMRAPResult(view, reps, {self.amrapReps = $0; self.amrapTag = $1; self.index += 1; completion()})
            
        } else {
            index += 1
            completion()
        }
    }
    
    private func doLast(_ view: UIViewController, _ completion: @escaping () -> Void) {
        let (_, _, amrapReps) = getBaseRepRange()
        if let reps = amrapReps, isWorkset(index) && !isWorkset(index+1) {
            getAMRAPResult(view, reps, {self.amrapReps = $0; self.amrapTag = $1; self.index = self.activities.count; completion()})
            
        } else {
            index = self.activities.count
            completion()
        }
    }
    
    private func presentFinalize(_ exercise: Exercise, _ tag: ResultTag, _ view: UIViewController, _ completion: @escaping () -> Void) {
        switch exercise.type {
        case .body(_):
            let (minReps, maxReps, _) = getBaseRepRange()
            if let currenReps = workingReps, currenReps < maxReps {
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
                let variableReps = minReps != maxReps
                
                let label4 = variableReps ? "4 reps" : advanceWeightLabel(exercise, weight, by: 4)
                let label3 = variableReps ? "3 reps" : advanceWeightLabel(exercise, weight, by: 3)
                let label2 = variableReps ? "2 reps" : advanceWeightLabel(exercise, weight, by: 2)
                let label1 = variableReps ? "1 rep" : advanceWeightLabel(exercise, weight, by: 1)
                let dlabel1 = variableReps ? "1 rep" : advanceWeightLabel(exercise, weight, by: -1)
                let dlabel2 = variableReps ? "2 reps" : advanceWeightLabel(exercise, weight, by: -2)
                let dlabel3 = variableReps ? "3 reps" : advanceWeightLabel(exercise, weight, by: -3)
                
                let advance4 = UIAlertAction(title: "Advance by \(label4)", style: .default) {_ in self.doAdvance(exercise, 4); completion()}
                let advance3 = UIAlertAction(title: "Advance by \(label3)", style: .default) {_ in self.doAdvance(exercise, 3); completion()}
                let advance2 = UIAlertAction(title: "Advance by \(label2)", style: .default) {_ in self.doAdvance(exercise, 2); completion()}
                let advance = UIAlertAction(title: "Advance by \(label1)", style: .default) {_ in self.doAdvance(exercise, 1); completion()}
                let maintain = UIAlertAction(title: "Maintain", style: .default) {_ in completion()}
                let deload = UIAlertAction(title: "Deload by \(dlabel1)", style: .default) {_ in self.doAdvance(exercise, -1); completion()}
                let deload2 = UIAlertAction(title: "Deload by \(dlabel2)", style: .default) {_ in self.doAdvance(exercise, -2); completion()}
                let deload3 = UIAlertAction(title: "Deload by \(dlabel3)", style: .default) {_ in self.doAdvance(exercise, -3); completion()}
                
                switch tag {
                case .veryEasy:
                    if currenReps+3 < maxReps {
                        alert.addAction(advance4)
                    }
                    if currenReps+2 < maxReps {
                        alert.addAction(advance3)
                    }
                    if currenReps+1 < maxReps {
                        alert.addAction(advance2)
                        alert.preferredAction = advance2
                    }
                    
                case .easy:
                    if currenReps+3 < maxReps {
                        alert.addAction(advance4)
                    }
                    if currenReps+2 < maxReps {
                        alert.addAction(advance3)
                    }
                    if currenReps+1 < maxReps {
                        alert.addAction(advance2)
                        alert.preferredAction = advance2
                    }
                    if currenReps < maxReps {
                        alert.addAction(advance)
                    }
                    alert.addAction(maintain)
                    
                case .normal:
                    if currenReps+1 < maxReps {
                        alert.addAction(advance2)
                    }
                    if currenReps < maxReps {
                        alert.addAction(advance)
                        alert.preferredAction = advance
                    }
                    alert.addAction(maintain)
                    
                case .hard:
                    if currenReps < maxReps {
                        alert.addAction(advance)
                    }
                    alert.addAction(maintain)
                    alert.addAction(deload)
                    alert.preferredAction = maintain
                    
                case .failed:
                    alert.addAction(maintain)
                    alert.addAction(deload)
                    alert.addAction(deload2)
                    alert.addAction(deload3)
                    alert.preferredAction = deload
                }
                
                view.present(alert, animated: true, completion: nil)
            } else {
                completion()
            }
        case .weights(_): assert(false); completion()
        }
    }
    
    func reset() {
        index = 0
    }
    
    private func doAdvance(_ exercise: Exercise, _ amount: Int) {
        if let reps = workingReps {
            workingReps = reps + amount
        }
    }
    
    var weight: Double      // starts out at 0.0
    var workingReps: Int?   // set when minReps < maxReps, also this can be less than minReps
    var restTime: Int
    var sets: Sets

    var activities: [Activity] = []
    var numWarmups: Int = 0
    var currentWorkout = ""
    var index: Int = 0
    
    var amrapReps: Int? = nil
    var amrapTag: ResultTag? = nil

    static var results: [String: [Result]] = [:]
}

