//  Created by Jesse Jones on 12/31/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation

func DB_PPL() -> Program {
    let warmup = "5@50% 3@75%"
    
    let sets = "5-10".x(3)
    
    let exercises = [
        // Push
        dumbbell2("Bench Press",      "Dumbbell Bench Press",     warmup, sets, restMins: 1.5, fixedSubTitle: "Alpha, Beta, Gama", main: true),
        dumbbell2("Incline Flyes",    "Dumbbell Incline Flyes",   "", sets, restMins: 1.5),
        dumbbell2("Arnold Press",     "Arnold Press",             "", sets, restMins: 1.5),
        dumbbell1("Skull Crushers",   "Skull Crushers",           "", sets, restMins: 1.5),

        // Pull
        bodyweight("Pullup",            "Pullup",                 numSets: 3, startReps: 3, goalReps: 36, restMins: 1.5),
        dumbbell2("Row",                "Bent Over Dumbbell Row", "", sets, restMins: 1.5),
        dumbbell2("Reverse Flyes",      "Reverse Flyes",          "", sets, restMins: 1.5),
        dumbbell2("Shrugs",             "Dumbbell Shrug",         "", sets, restMins: 1.5),
        dumbbell1("Curls",              "Concentration Curls",    "", sets, restMins: 1.5),
        bodyweight("Hanging Leg Raise", "Hanging Leg Raise",      sets, restMins: 1.5),

        // Legs
        dumbbell2("Goblet Squat",      "Goblet Squat",                    warmup, sets, restMins: 1.5, main: true),
        dumbbell2("Split Squat",       "Dumbbell Single Leg Split Squat", warmup, sets, restMins: 1.5, main: true),
        dumbbell2("Lunge",             "Dumbbell Lunge",                  "", sets, restMins: 1.5),
        dumbbell2("Romanian Deadlift", "Dumbbell Romanian Deadlift",      "", sets, restMins: 1.5, main: true),
        dumbbell2("Calf Raise",        "Standing Dumbbell Calf Raises",   "", sets, restMins: 1.5)]
    
    let workouts = [
        Workout("Push 1", ["Bench Press", "Incline Flyes", "Arnold Press", "Skull Crushers", "Hanging Leg Raise"], scheduled: true, optional: []),
        Workout("Pull 1", ["Pullup", "Row", "Reverse Flyes", "Shrugs", "Curls"], scheduled: true, optional: []),
        Workout("Legs 1", ["Goblet Squat", "Split Squat", "Lunge", "Romanian Deadlift", "Calf Raise", "Hanging Leg Raise"], scheduled: true, optional: ["Split Squat"]),

        Workout("Push 2", ["Bench Press", "Incline Flyes", "Arnold Press", "Skull Crushers"], scheduled: true, optional: []),
        Workout("Pull 2", ["Pullup", "Row", "Reverse Flyes", "Shrugs", "Curls", "Hanging Leg Raise"], scheduled: true, optional: []),
        Workout("Legs 2", ["Goblet Squat", "Split Squat", "Lunge", "Romanian Deadlift", "Calf Raise"], scheduled: true, optional: ["Split Squat"]),
        ]
    
    let tags: [Program.Tags] = [.beginner, .hypertrophy, .dumbbell, .unisex, .threeDays] + anyAge
    
    let description = """
This is a [program](https://old.reddit.com/r/Fitness/comments/2e79y4/dumbbell_ppl_proposed_alternative_to_dumbbell/) for people who lack access to barbells. It's a three days a week program:

**Push**
* Bench Press 3x6-12
* Incline Fly 3x6-12
* Arnold Press 3x6-12
* Skullcrusher 3x6-12
* Hanging Leg Raises 3x6-12 (every other workout)

**Pull**
* Pullup 3x6-12
* Bent-over Row 3x6-12
* Reverse Fly 3x6-12
* Shrug 3x6-12
* Curl 3x6-12

**Legs**
* Goblet Squat 3x6-12
* Lunge 3x6-12
* Single Leg Deadlift 3x6-12
* Calf Raise 3x6-12

**Notes**
* If your lightest dumbbell is too heavy you can begin with empty hands.
* For the unilateral exercises a set is done when you finish both sides.
* if you stall on a lift two times in a row lower the weight by two steps.
* If the goblet squat gets too easy you can swap in split squats using the Options button in workouts.
* Progression is easier with 2.5 pound magnets.
"""
    return Program("DB PPL", workouts, exercises, tags, description)
}

