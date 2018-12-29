//  Created by Jesse Jones on 12/29/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation

func Metallicadpa() -> Program {
    let warmup = "10@0% 10@50% 5@70% 3@90%"
    let assistence = "8-12".x(3)

    let exercises = [
        // Pull 1
        barbell("Deadlift",       "Deadlift",         warmup,  "5".x(1, amrap: true), restMins: 3.0, bumpers: defaultBumpers(), main: true),
        cable("Lat Pulldown",     "Lat Pulldown",     "", assistence, restMins: 2.0),
        cable("Cable Row",        "Seated Cable Row", "", assistence, restMins: 2.0),
        cable("Face Pull",        "Face Pull",        "", "15-20".x(5), restMins: 2.0),
        dumbbell2("Hammer Curls", "Hammer Curls",     "", "8-12".x(4), restMins: 2.0),
        dumbbell1("Concentration Curls", "Concentration Curls",     "", "8-12".x(4), restMins: 2.0),
        bodyweight("Chinups",     "Chinup",           numSets: 3, startReps: 5, goalReps: 36, restMins: 2.0),
        singlePlates("T-Bar Row", "T-Bar Row",        "", assistence, restMins: 2.0),

        // Push 1
        barbell("Bench Press",        "Bench Press",             warmup,  "5".x(5, amrap: true), restMins: 3.0, main: true),
        barbell("Volume OHP",         "Overhead Press",          "",  assistence, restMins: 2.0),
        dumbbell2("DB Incline Press", "Dumbbell Incline Press",  "", assistence, restMins: 2.0),
        cable("Triceps Pushdown",     "Triceps Pushdown (rope)", "", assistence, restMins: 2.0),
        dumbbell2("Lateral Raise 1",   "Side Lateral Raise",      "", "15-20".x(3), restMins: 2.0),
        dumbbell2("Skull Crushers",   "Skull Crushers",          "", assistence, restMins: 2.0),
        dumbbell2("Lateral Raise 2",   "Side Lateral Raise",      "", "15-20".x(3), restMins: 2.0),

        // Leg 1
        barbell("Squat",             "Low bar Squat",        warmup,  "5".x(3, amrap: true), restMins: 3.0, main: true),
        barbell("Romanian Deadlift", "Romanian Deadlift",    "", assistence, restMins: 2.0, bumpers: defaultBumpers()),
        pairedPlates("Leg Press",    "Leg Press",            "", assistence, restMins: 2.0),
        machine("Leg Curls",         "Lying Leg Curls",      "", assistence, restMins: 2.0),
        barbell("Calf Raises",       "Standing Calf Raises", "", assistence, restMins: 2.0),

        // Pull 2
        barbell("Barbell Row",  "Pendlay Row",    warmup,  "5".x(5, amrap: true), restMins: 3.0, main: true),

        // Push 2
        barbell("OHP",          "Overhead Press", warmup,  "5".x(5, amrap: true), restMins: 3.0, main: true),
        barbell("Volume Bench", "Bench Press",    "",  assistence, restMins: 2.0)]
    
    let workouts = [
        Workout("Pull 1", ["Deadlift", "Lat Pulldown", "Chinups", "Cable Row", "T-Bar Row", "Face Pull", "Hammer Curls", "Concentration Curls"], scheduled: true, optional: ["Chinups", "T-Bar Row"]),
        Workout("Push 1", ["Bench Press", "Volume OHP", "DB Incline Press", "Triceps Pushdown", "Lateral Raise 1", "Skull Crushers", "Lateral Raise 2"], scheduled: true, optional: []),
        Workout("Leg 1",  ["Squat", "Romanian Deadlift", "Leg Press", "Leg Curls", "Calf Raises"], scheduled: true),
        
        Workout("Pull 2", ["Barbell Row", "Lat Pulldown", "Chinups", "Cable Row", "T-Bar Row", "Face Pull", "Hammer Curls", "Concentration Curls"], scheduled: true, optional: ["Chinups", "T-Bar Row"]),
        Workout("Push 2", ["OHP", "Volume Bench", "DB Incline Press", "Triceps Pushdown", "Lateral Raise 1", "Skull Crushers", "Lateral Raise 2"], scheduled: true, optional: []),
        Workout("Leg 2",  ["Squat", "Romanian Deadlift", "Leg Press", "Leg Curls", "Calf Raises"], scheduled: true)]
    
    let tags: [Program.Tags] = [.beginner, .hypertrophy, .barbell, .unisex, .sixDays, .ageUnder40]
    
    let description = """
This is a Push/Pull/Legs (PPL) [beginner program](http://archive.li/gMUfM). PPL programs are similar to the classic body part splits (e.g. chest, arms, back, legs) but are more balanced and have less less overlap between days. This is a six day a week program:

**Pull 1**
* Deadlift 1x5+
* Lat Pulldown 3x8-12
* Cable Rows 3x8-12
* Face Pulls 5x15-20
* Hammer Curls 4x8-12
* Dumbbell Curls 4x8-12

**Push 1**
* Bench Press 5x5+
* OHP 3x8-12
* Incline DB Press 3x8-12
* Triceps Pushdown 3x8-12 super set with lateral raises
* Laterial Raises 3x15-20
* Overhead Triceps Ext 3x8-12 super set with lateral raises
* Lateral Raises 3x15-20

**Leg 1**
* Squat 3x5+
* Romanian Deadlift 3x8-12
* Leg Press 3x8-12
* Leg Curl 3x8-12
* Calf Raises 3x8-12

**Pull 2**
* Barbell Rows 5x5+
* Lat Pulldown 3x8-12
* Cable Rows 3x8-12
* Face Pulls 5x15-20
* Hammer Curls 4x8-12
* Dumbbell Curls 4x8-12

**Push 2**
* OHP 5x5+
* Bench Press 3x8-12
* Incline DB Press 3x8-12
* Triceps Pushdown 3x8-12 super set with lateral raises
* Laterial Raises 3x15-20
* Overhead Triceps Ext 3x8-12 super set with lateral raises
* Lateral Raises 3x15-20

**Leg 2**
* Squat 3x5+
* Romanian Deadlift 3x8-12
* Leg Press 3x8-12
* Lat Curl 3x8-12
* Calf Raises 3x8-12

**Notes**
* The + means that the last set is As Many Reps as Possible (AMRAP). But don't do these to failure: try and leave one or two reps in the tank, e.g. stop if the bar speed slows significantly.
* If you fail to do all the required reps for an exercise, and it's not a one-off due to something like lack of sleep, then deload that exercise by 10%.
"""
    return Program("Metallicadpa PPL", workouts, exercises, tags, description)
}

