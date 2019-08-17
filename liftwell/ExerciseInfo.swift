//  Created by Jesse Jones on 10/20/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation
import UIKit           // for UIColor
//import os.log

/// Generic description of what the user needs to do for a particular activity within an ExerciseController.
struct Activity: Storable {
    /// "Warmup 3 of 6"
    var title: String
    
    /// "60% of 300 lbs"
    var subtitle: String
    
    /// "5 reps @ 220 lbs"
    let amount: String
    
    /// "45 + 10 lbs"
    let details: String
    
    /// Usually "Next". If empty then GUIs should auto-complete once restSecs expire.
    var buttonName: String
    
    /// Usually true
    let showStartButton: Bool
    
    /// X11 background color name. Note that case is ignored.
    let color: String?
    
    init(title: String, subtitle: String, amount: String, details: String, buttonName: String, showStartButton: Bool, color: String?) {
        self.title = title
        self.subtitle = subtitle
        self.amount = amount
        self.details = details
        self.buttonName = buttonName
        self.showStartButton = showStartButton
        self.color = color
    }

    init(from store: Store) {
        self.title = store.getStr("title")
        self.subtitle = store.getStr("subtitle")
        self.amount = store.getStr("amount")
        self.details = store.getStr("details")
        self.buttonName = store.getStr("buttonName")
        self.showStartButton = store.getBool("showStartButton")

        let c = store.getStr("color")
        self.color = c != "" ? c : nil
    }
    
    func save(_ store: Store) {
        store.addStr("title", title)
        store.addStr("subtitle", subtitle)
        store.addStr("amount", amount)
        store.addStr("details", details)
        store.addStr("buttonName", buttonName)
        store.addBool("showStartButton", showStartButton)
        store.addStr("color", color ?? "")
    }

    func clone() -> Activity {
        let store = Store()
        store.addObj("self", self)
        let result: Activity = store.getObj("self")
        return result
    }
}

struct RestTime {
    let autoStart: Bool
    
    let secs: Int
}

/// Used to inform an Exercise instance of the result of a sequence of activities.
struct Completion {
    /// If the activity has more than one Completion then Exercise will use title to populate a popup menu or list view.
    let title: String
    
    /// This will normally be why or when the user would pick this completion.
    let info: String
    
    /// Set if the Completion is the one the user is expected to select.
    //let isDefault: Bool
    
    /// Called by Exercise to do things like maintain or advance reps/weight.
    let callback: (_ view: UIViewController, _ completion: @escaping () -> Void) -> Void
}

/// Lifecycle for an exercise within an ExerciseController. Typically the transitions are from waiting -> started -> underway -> finished.
enum ExerciseState {
    /// The exercise has been initialized but not started yet. Note that exercises also enter this state
    /// when they are loaded from disk if it's been more than a day since they were started.
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

/// Implemented by SubTypes and used to perform an Exercise.
protocol ExerciseInfo: Storable {
    var state: ExerciseState {get}
    
    func clone() -> ExerciseInfo

    /// If the exercise requires another exercise to be executed then a new Exercise will be returned
    /// and state will be set to blocked.
    func start(_ workout: Workout, _ exercise: Exercise) -> (Exercise, String)?
    
    /// Options screen updated state.
    func updated(_ exercise: Exercise)
    
    /// Returns true if the plan was started for workout.
    func on(_ workout: Workout) -> Bool
    
    /// This is used in the workouts tab.
    /// "Light Squat". Used on WorkoutController.
    func label(_ exercise: Exercise) -> String
    
    /// This is used in the workouts tab.
    /// "200 lbs (80% of Heavy Squat)". Used on WorkoutController.
    func sublabel(_ exercise: Exercise) -> String
    
    /// "Previous was 125 lbs"
    func prevLabel(_ exercise: Exercise) -> (String, UIColor)
    
    /// "+5 lbs, same x3, +5 lbs x4"
    func historyLabel(_ exercise: Exercise) -> String
    
    /// Returns a struct outlining what the user should currently be doing.
    func current(_ exercise: Exercise) -> Activity
    
    /// How long for the user to rest after completing whatever current told him to do.
    func restSecs() -> RestTime
    
    /// Which sound to play when done resting. Usually kSystemSoundID_Vibrate.
    func restSound() -> UInt32
    
    /// This is called after each activity. If there is only one completion then just call
    /// the callback. Otherwise prompt the user and then call the callback for whichever
    /// completion the user chose.
    func completions(_ exercise: Exercise) -> [Completion]
    
    /// Called once the exercise is all finished. Tag is an arbitrary string.
    func finalize(_ exercise: Exercise, _ view: UIViewController, _ completion: @escaping () -> Void)
    
    /// Start over from the beginning.
    func reset()
}

