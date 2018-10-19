//  Created by Jesse Jones on 10/1/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import AVFoundation // for kSystemSoundID_Vibrate
import Foundation
import UIKit
import os.log

/// Generic description of what the user needs to do for a particular activity within an ExerciseController.
struct Activity {
    /// "Warmup 3 of 6"
    let title: String
    
    /// "60% of 300 lbs"
    let subtitle: String
    
    /// "5 reps @ 220 lbs"
    let amount: String
    
    /// "45 + 10 lbs"
    let details: String
    
    /// Usually "Next". If empty then GUIs should auto-complete once restSecs expire.
    let buttonName: String
    
    /// Usually true
    let showStartButton: Bool
    
    /// X11 background color name. Note that case is ignored.
    let color: String?
}

struct RestTime {
    let autoStart: Bool
    
    let secs: Int
}

/// Used to inform an Exercise instance of the result of an activity.
struct Completion {
    /// If the activity has more than one Completion then apps will typically use title to populate a popup menu or list view.
    let title: String
    
    /// This will normally be why or when the user would pick this completion.
    let info: String
    
    /// Set if the Completion is the one the user is expected to select.
    //let isDefault: Bool
    
    /// Called by apps so that the Plan can move on to whatever the user should do next.
    let callback: () -> Void
}

/// Lifecycle for an exercise within an ExerciseController. Typically the transitions are from waiting -> started -> underway -> finished.
enum ExerciseState {
    /// The exercise has been initialized but not started yet. Note that exercises also enter this state
    /// when they are loaded from disk if it's been more than a day since they were started. TODO: need to do this
    case waiting
    
    /// Start has been called and the exercise was able to start OK but the user hasn't advanced within
    /// the exercise (e.g. by pressing the Next button).
    case started
    
    /// The exercise was in started but the user has advanced past started and isn't yet finished.
    case underway
    
    /// The user has advanced so far that there is nothing left to do for this iteration of the workout.
    case finished
    
    /// Start was called but the exercise cannot be executed until another exercise is executed. For example,
    /// PercentOfPlan requires that its base plan be executed before it can execute.  TODO: fix name
    case blocked
    
    /// Start was called but there was some fatal error that prevents the exercise from executing. For example,
    /// PercentOfPlan cannot find the base plan.  TODO: fix name
    case error(String)
}

class Exercise: Storable {
    init(_ name: String, _ formalName: String, _ type: Type) {
        self.name = name
        self.formalName = formalName
//        self.nextExercise = nil
//        self.prevExercise = nil
        self.type = type
        self.completed = [:]
//        self.hidden = hidden
    }
    
    required init(from store: Store) {
        self.name = store.getStr("name")
        self.formalName = store.getStr("formalName")
        self.type = store.getObj("type")
//        self.hidden = store.getBool("hidden")
        
        self.completed = [:]
        if store.hasKey("completed-names") {
            let names = store.getStrArray("completed-names")
            let dates = store.getDateArray("completed-dates")
            
            for (i, name) in names.enumerated() {
                self.completed[name] = dates[i]
            }
        }
        
//        if store.hasKey("nextExercise") {
//            self.nextExercise = store.getStr("nextExercise")
//        } else {
//            self.nextExercise = nil
//        }
//        if store.hasKey("prevExercise") {
//            self.prevExercise = store.getStr("prevExercise")
//        } else {
//            self.prevExercise = nil
//        }
    }
    
    func save(_ store: Store) {
        store.addStr("name", name)
        store.addStr("formalName", formalName)
        store.addObj("type", type)
//        store.addBool("hidden", hidden)
        
//        if let next = nextExercise {
//            store.addStr("nextExercise", next)
//        }
//        if let prev = prevExercise {
//            store.addStr("prevExercise", prev)
//        }
        
        store.addStrArray("completed-names", Array(completed.keys))
        store.addDateArray("completed-dates", Array(completed.values))
    }
    
//    func sync(_ savedExercise: Exercise) {
//        if plan.shouldSync(savedExercise.plan) {
//            plan = savedExercise.plan
//            completed = savedExercise.completed
//            setting = savedExercise.setting
//        } else {
//            os_log("ignoring saved exercise %@", type: .info, name)
//        }
//    }
    
    var name: String             // "Heavy Bench"
    var formalName: String       // "Bench Press"
    var type: Type
    
    /// Date the exercise was last completed keyed by workout name (exercises can be shared across workouts).
    var completed: [String: Date]
    
    /// These are used for exercises that support progression. For example, progressively harder planks. Users
    /// can use the Options screens to choose which version they want to perform.
//    var prevExercise: String?
//    var nextExercise: String?
    
    /// If true don't display the plan in UI.
//    var hidden: Bool
    
    func errors(_ program: Program) -> [String] {
        var problems: [String] = []
        
        switch type {
        case .body(let type): problems += type.errors()
        case .weights(let type): problems += type.errors()
        }
        
//        if let name = prevExercise, program.findExercise(name) == nil {
//            problems += ["exercise \(name) prevExercise (\(name)( is missing from the program"]
//        }
//        if let name = nextExercise, program.findExercise(name) == nil {
//            problems += ["exercise \(name) nextExercise (\(name)) is missing from the program"]
//        }
        
        return problems
    }

    // ----------------------------------------------------------------------------
    // These are used by the ExerciseController
    
    public func on(_ workout: Workout) -> Bool {
        return currentWorkout == workout.name
    }
    
    /// If the exercise requires another exercise to be executed then a new Exercise will be returned
    /// and state will be set to blocked.
    func start(_ workout: Workout) -> Exercise? {
        currentWorkout = workout.name
        switch self.type {
        case .body(let type):
            switch type.subtype {
            case .maxReps(let subtype): activities = subtype.activities()
            case .reps(let subtype): activities = subtype.activities(nil)
            case .timed(let subtype): activities = subtype.activities()
            }
        case .weights(let type):
            switch type.subtype {
            case .cyclic(let subtype): activities = subtype.activities(type.apparatus)
            case .reps(let subtype): activities = subtype.activities(type.apparatus)
            case .timed(let subtype): activities = subtype.activities()
            }
        }
        index = 0
        return nil
    }
    
    func state() -> ExerciseState {
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
    
    /// This is used in the workouts tab.
    /// "Light Squat".
    func label() -> String {
        return self.name
    }
    
    /// This is used in the workouts tab.
    /// "200 lbs (80% of Heavy Squat)".
    func sublabel() -> String {
        switch self.type {
        case .body(let type):
            switch type.subtype {
            case .maxReps(let subtype): return subtype.sublabel()
            case .reps(let subtype): return subtype.sublabel(nil)
            case .timed(let subtype): return subtype.sublabel()
            }
        case .weights(let type):
            switch type.subtype {
            case .cyclic(let subtype): return subtype.sublabel(type.apparatus)
            case .reps(let subtype): return subtype.sublabel(type.apparatus)
            case .timed(let subtype): return subtype.sublabel()
            }
        }
    }
    
    /// "Previous was 125 lbs"
    func prevLabel() -> (String, UIColor) {
        return ("", UIColor.black)  // TODO: implement
    }
    
    /// "+5 lbs, same x3, +5 lbs x4"
    func historyLabel() -> String {  // TODO: implement
        return ""
    }
    
    /// Returns a struct outlining what the user should currently be doing.
    func current() -> Activity {
        return activities[index]
    }
    
    /// How long for the user to rest after completing whatever current told him to do.
    func restSecs() -> RestTime {
        switch self.type {
        case .body(let type):
            switch type.subtype {
            case .maxReps(let subtype): return RestTime(autoStart: true, secs: subtype.restSecs)
            case .reps(let subtype): return RestTime(autoStart: true, secs: subtype.restSecs)
            case .timed(let subtype): return RestTime(autoStart: true, secs: subtype.restSecs)
            }
        case .weights(let type):
            switch type.subtype {
            case .cyclic(let subtype): return RestTime(autoStart: true, secs: subtype.restSecs)
            case .reps(let subtype): return RestTime(autoStart: true, secs: subtype.restSecs)
            case .timed(let subtype): return RestTime(autoStart: true, secs: subtype.restSecs)
            }
        }
    }
    
    /// Which sound to play when done resting. Usually kSystemSoundID_Vibrate.
    func restSound() -> UInt32 {
        return kSystemSoundID_Vibrate
    }
    
    /// If there is only one completion then just call the callback. Otherwise prompt the
    /// user and then call the callback for whichever completion the user chose.
    func completions() -> [Completion] {
        switch self.type {
        case .body(let type):
            switch type.subtype {
            case .maxReps(let subtype): return subtype.completions()
            case .reps(let subtype): return subtype.completions()
            case .timed(let subtype): return subtype.completions()
            }
        case .weights(let type):
            switch type.subtype {
            case .cyclic(let subtype): return subtype.completions()
            case .reps(let subtype): return subtype.completions()
            case .timed(let subtype): return subtype.completions()
            }
        }
    }
    
    /// Start over from the beginning.
    func reset() {
        index = 0
    }
    
    private var currentWorkout = "" // TODO: persist this stuff
    private var activities: [Activity] = []
    private var index = 0;
}

