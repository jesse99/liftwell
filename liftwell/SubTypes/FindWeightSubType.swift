//  Created by Jesse Jones on 10/6/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import AVFoundation // for kSystemSoundID_Vibrate
import Foundation
import UIKit           // for UIColor
import os.log

/// Used when weight is zero for a subtype with an apparatus.
class FindWeightSubType: ExerciseInfo {
    private typealias `Self` = FindWeightSubType
    
    init(reps: Int, restSecs: Int) {
        self.reps = reps
        self.restTime = restSecs
        self.weight = 0
        self.set = .notStarted
    }
    
    required init(from store: Store) {
        self.reps = store.getInt("reps")
        self.restTime = store.getInt("restTime")
        self.weight = store.getDbl("weight")
        
        let index = store.getInt("index")
        if index > 0 {
            self.set = .started(index)
        } else if index == 0 {
            self.set = .notStarted
        } else {
            self.set = .finished(-index)
        }
    }
    
    func save(_ store: Store) {
        store.addInt("reps", reps)
        store.addInt("restTime", restTime)
        store.addDbl("weight", weight)
        
        switch set {
        case .notStarted: store.addInt("index", 0)
        case .started(let index): store.addInt("index", index)
        case .finished(let index): store.addInt("index", -index)
        }
    }
    
    func sync(_ program: Program, _ savedExercise: Exercise) {
    }
    
    func errors() -> [String] {
        return []
    }
    
    // ---- ExerciseInfo ----------------------------------------------------------------------
    var state: ExerciseState {
        get {
            switch set {
            case .notStarted: return .waiting
            case .started(let index): return index == 1 ? .started : .underway
            case .finished(_): return .finished
            }
        }
    }
    
    func start(_ workout: Workout, _ exercise: Exercise) -> Exercise? {
        set = .started(1)
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
    }
    
    func on(_ workout: Workout) -> Bool {
        return currentWorkout == workout.name
    }
    
    func label(_ exercise: Exercise) -> String {
        return exercise.name
    }
    
    func sublabel(_ exercise: Exercise) -> String {
        return "no weight"
    }
    
    func prevLabel(_ exercise: Exercise) -> (String, UIColor) {
        return ("Stop when you think you couldn't do more than one extra rep,", UIColor.black)
    }
    
    func historyLabel(_ exercise: Exercise) -> String {
        return "e.g. when the reps slow significantly."
    }
    
    func current(_ exercise: Exercise) -> Activity {
        let (index, finished) = getState()
        switch exercise.type {
        case .body(_):
            assert(false)
            abort()
        case .weights(let type):
            let currentWeight = Weight(weight, type.apparatus).closest()
            return Activity(
                title: "Set \(index)",
                subtitle: "",
                amount: "\(reps) @ \(currentWeight.text)",
                details: currentWeight.plates,
                buttonName: finished ? "Done" : "Next",
                showStartButton: true,
                color: nil)
        }
    }
    
    func restSecs() -> RestTime {
        return RestTime(autoStart: false, secs: restTime)
    }
    
    func restSound() -> UInt32 {
        return kSystemSoundID_Vibrate
    }
    
    func completions(_ exercise: Exercise) -> [Completion] {
        let (index, _) = getState()
        
        let label8 = advanceWeightLabel(exercise, weight, by: 8)
        let label4 = advanceWeightLabel(exercise, weight, by: 4)
        let label3 = advanceWeightLabel(exercise, weight, by: 3)
        let label2 = advanceWeightLabel(exercise, weight, by: 2)
        let label1 = advanceWeightLabel(exercise, weight, by: 1)
        return [Completion(title: "Advance by \(label8)", info: "", callback: {_,completion in self.doAdvance(exercise, index, 8); completion()}),
                Completion(title: "Advance by \(label4)", info: "", callback: {_,completion in self.doAdvance(exercise, index, 4); completion()}),
                Completion(title: "Advance by \(label3)", info: "", callback: {_,completion in self.doAdvance(exercise, index, 3); completion()}),
                Completion(title: "Advance by \(label2)", info: "", callback: {_,completion in self.doAdvance(exercise, index, 2); completion()}),
                Completion(title: "Advance by \(label1)", info: "", callback: {_,completion in self.doAdvance(exercise, index, 1); completion()}),
                Completion(title: "Done", info: "", callback: {_,completion in self.set = .finished(index); completion()})]
    }
    
    func finalize(_ exercise: Exercise, _ view: UIViewController, _ completion: @escaping () -> Void) {
        let app = UIApplication.shared.delegate as! AppDelegate
        if let original = app.program.findExercise(exercise.name) {
            switch original.type {
            case .weights(let type):    // this is the only one with an apparatus
                switch type.subtype {
                case .cyclic(let subtype): subtype.setWorkingWeight(weight)
                case .find(_): assert(false)
                case .reps(let subtype): subtype.setWorkingWeight(weight)
                case .timed(let subtype): subtype.weight = weight
                }
            default:
                assert(false)
            }
        } else {
            assert(false)
        }
        completion()
    }
    
    func reset() {
        set = .started(1)
        weight = 0
    }
    
    private func doAdvance(_ exercise: Exercise, _ index: Int, _ amount: Int) {
        switch exercise.type {
        case .body(_):
            assert(false)
            abort()
        case .weights(let type):
            for _ in 0..<amount {
                weight = Weight(weight, type.apparatus).nextWeight()
            }
            set = .started(index + 1)
        }
    }
    
    private func getState() -> (Int, Bool) {
        switch set {
        case .notStarted: return (1, false)
        case .started(let index): return (index, false)
        case .finished(let index): return (index, true)
        }
    }
    
    private enum Set {
        case notStarted
        case started(Int)
        case finished(Int)
    }
    
    var weight: Double
    var reps: Int
    var restTime: Int
    private var set: Set
    private var currentWorkout = ""
}
