//  Created by Jesse Jones on 12/29/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation

func PHUL() -> Program {
    let warmup = "10@0% 5@50% 3@75% 1@90%"
    
    let assistence = "8-12".x(4)
    
    let exercises = [
        // Upper Power
        barbell("Bench Press",      "Bench Press",            warmup, "3-5".x(4), restMins: 3.0, main: true),
        barbell("Incline DB Bench", "Dumbbell Incline Press", "", "6-10".x(4), restMins: 2.0),
        barbell("Barbell Row",      "Pendlay Row",            "", "3-5".x(4), restMins: 2.0),
        cable("Lat Pulldown",       "Lat Pulldown",           "", "6-10".x(4), restMins: 2.0),
        barbell("OHP",              "Overhead Press",         "", "5-8".x(3), restMins: 2.0),
        barbell("Barbell Curl",     "Barbell Curl",           "", "6-10".x(3), restMins: 2.0),
        barbell("Skullcrusher",     "Skull Crushers",         "", "6-10".x(3), restMins: 2.0),

        // Lower Power
        barbell("Squat",          "Low bar Squat",        warmup, "3-5".x(4), restMins: 3.0, main: true),
        barbell("Deadlift",       "Deadlift",             warmup, "3-5".x(4), restMins: 3.0, bumpers: defaultBumpers(), main: true),
        pairedPlates("Leg Press", "Leg Press",            "", "10-15".x(4), restMins: 2.0),
        machine("Leg Curl",       "Seated Leg Curl",      "", "6-10".x(4), restMins: 2.0),
        barbell("Calf Raises",    "Standing Calf Raises", "", "6-10".x(4), restMins: 2.0),

        // Upper Hypertrophy
        barbell("Incline Bench",   "Incline Bench Press", warmup, assistence, restMins: 2.0),
        dumbbell2("DB Flyes",      "Dumbbell Flyes",      "", assistence, restMins: 2.0),
        cable("Cable Row",         "Seated Cable Row",    "", assistence, restMins: 2.0),
        dumbbell2("Kroc Row",      "Kroc Row",            "", assistence, restMins: 2.0),
        dumbbell2("Lateral Raise", "Side Lateral Raise",  "", assistence, restMins: 2.0),
        dumbbell1("DB Curl",       "Concentration Curls", "", assistence, restMins: 2.0),
        cable("Tricep Ext",        "Triceps Pushdown (rope)", "", assistence, restMins: 2.0),

        // Lower Hypertrophy
        barbell("Front Squat",   "Front Squat",        warmup, assistence, restMins: 2.0),
        barbell("Barbell Lunge", "Barbell Lunge",      "", assistence, restMins: 2.0),
        machine("Leg Extension", "Leg Extensions",     "", assistence, restMins: 2.0),
        // "Leg Press"
        machine("Calf Raise",    "Seated Calf Raises", "", assistence, restMins: 2.0),
        machine("Calf Press",    "Calf Press",         "", assistence, restMins: 2.0),
        ]
    
    let workouts = [
        Workout("Upper Power", ["Bench Press", "Incline DB Bench", "Barbell Row", "Lat Pulldown", "OHP", "Barbell Curl", "Skullcrusher"], scheduled: true, optional: []),
        Workout("Lower Power", ["Squat", "Deadlift", "Leg Press", "Leg Curl", "Calf Raises"], scheduled: true, optional: []),
        Workout("Upper Hypertrophy", ["Incline Bench", "DB Flyes", "Cable Row", "Kroc Row", "Lateral Raise", "DB Curl", "Tricep Ext"], scheduled: true),
        Workout("Lower Hypertrophy", ["Front Squat", "Barbell Lunge", "Leg Extension", "Leg Press", "Calf Raise", "Calf Press"], scheduled: true)]
    
    let tags: [Program.Tags] = [.intermediate, .hypertrophy, .barbell, .fourDays, .male, .ageUnder40, .age40s]
    
    let description = """
This is a [Power Hypertrophy Upper Lower](https://www.muscleandstrength.com/workouts/phul-workout) workout. It's a mix between a pure strength program and a body building program:

**Upper Power**
* Bench Press 4x3-5
* Incline DB Bench 4x6-10
* Barbell Row 4x3-5
* Lat Pulldown 4x6-10
* Overhead Press 3x5-8
* Barbell Curl 3x6-10
* Skullcrusher 3x6-10

**Lower Power**
* Squat 4x3-5
* Deadlift 4x3-5
* Leg Press 4x10-15
* Leg Curl 4x6-10
* Calf Raise 4x6-10

**Upper Hypertrophy**
* Incline Bench 4x8-12
* DB Flyes 4x8-12
* Cable Row 4x8-12
* Kroc Row 4x8-12
* Lateral Raise 4x8-12
* DB Curl 4x8-12
* Tricep Ext 4x8-12

**Lower Hypertrophy**
* Front Squat 4x8-12
* Barbell Lunge 4x8-12
* Leg Extension 4x8-12
* Leg Curl 4x10-15
* Calf Raise 4x8-12
* Calf Press 4x8-12

**Notes**
* When starting it's recommended to skip reps (or an entire set) until you become accustomed to the workload.
* Don't go to failure: always leave at least one rep in the tank.
"""
    return Program("PHUL", workouts, exercises, tags, description)
}

