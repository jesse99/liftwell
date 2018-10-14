//  Created by Jesse Jones on 10/9/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import AVFoundation // for kSystemSoundID_Vibrate
import Foundation
import UIKit

/// Generic description of what the user needs to do for a particular activity within a Plan.
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

/// Used to inform a PopulateState instance of the result of an activity.
struct Completion {
    /// If the activity has more than one Completion then apps will typically use title to populate a popup menu or list view.
    let title: String
    
    /// Set if the Completion is the one the user is expected to select.
    let isDefault: Bool
    
    /// Called by apps so that the Plan can move on to whatever the user should do next.
    let callback: () -> Void
}

/// Lifecycle for PopulateWorkout. Typically the transitions are from waiting -> started -> underway -> finished.
enum PopulateState {
    /// The workout has been initialized but not started yet. Note that workouts also enter this state
    /// when they are loaded from disk if it's been more than a day since they were started. TODO: need to do this
    case waiting
    
    /// Start has been called and the workout was able to start OK but the user hasn't advanced within
    /// the workout (e.g. by pressing the Next button).
    case started
    
    /// The workout was in started but the user has advanced past started, but isn't yet finished.
    case underway
    
    /// The user has advanced so far that there is nothing left to do for this iteration of the workout.
    case finished
    
    /// Start was called but the workout cannot be executed until another exercise is executed. For example,
    /// PercentOfPlan requires that its base plan be executed before it can execute.  TODO: fix name
    case blocked
    
    /// Start was called but there was some fatal error that prevents the plan from executing. For example,
    /// PercentOfPlan cannot find the base plan.  TODO: fix name
    case error(String)
}

/// Used to populate the workout view.
class Model { // TODO: will have to make this storable so that we can resume it after an exit
    init(_ exercise: Exercise) {
        self.exercise = exercise
    }
    
    /// If the exercise requires another exercise to be executed then a new PopulateWorkout will be returned
    /// and state will be set to blocked.
    func start() -> PopulateWorkout? {
        return nil
    }
    
    /// This is used in the workouts tab.
    /// "Light Squat".
    func label() -> String {
        return exercise.name
    }
    
    /// This is used in the workouts tab.
    /// "200 lbs (80% of Heavy Squat)".
    func sublabel() -> String {
        switch exercise.type {
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
        // TODO: Probably will need to get some sort of iterator object from the subtype, or maybe track an index and pass it into subtype
        // can't we just use stand-alone functions for all of these?
        return Activity(title: "", subtitle: "", amount: "", details: "", buttonName: "", showStartButton: false, color: nil)
    }
    
    /// How long for the user to rest after completing whatever current told him to do.
    func restSecs() -> RestTime {
        switch exercise.type {
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
        return []
    }
    
    /// Start over from the beginning.
    func reset() {
        
    }
    
    private let exercise: Exercise
}
