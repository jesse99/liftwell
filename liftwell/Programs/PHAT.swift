//  Created by Jesse Jones on 12/30/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation

func PHAT() -> Program {
    let powerSquatWarmup = "10@0% 5@50% 3@75% 1@90%"
    let speedSquatWarmup = "10@0% 5@50%"

    let powerWarmup = "5@50% 3@75%"
    let speedWarmup = "5@50%"

    let exercises = [
        // Upper Power
        barbell("Power Row",         "Pendlay Row",    powerWarmup, "3-5".x(3), restMins: 4.0, main: true),
        bodyweight("Pullups",        "Pullup",         numSets: 2, startReps: 6, goalReps: 20, restMins: 2.0),
        dumbbell1("Rack Chins 1",    "Rack Chinup",    "", "6-10".x(2), restMins: 2.0),
        dumbbell2("Power DB Bench",  "Dumbbell Bench Press", "", "3-5".x(3), restMins: 4.0, main: true),
        bodyweight("Dips",           "Dips",           numSets: 2, startReps: 6, goalReps: 20, restMins: 2.0),
        dumbbell2("Seated DB OHP 1", "Dumbbell Seated Shoulder Press", "", "6-10".x(3), restMins: 2.0),
        barbell("EZ Curls",          "Barbell Curl",   "", "6-10".x(3), restMins: 2.0),
        barbell("Skullcrushers 1",   "Skull Crushers", "", "6-10".x(3), restMins: 2.0),

        // Lower Power
        barbell("Power Squat",           "Low bar Squat",         powerSquatWarmup, "3-5".x(3), restMins: 4.0, main: true),
        barbell("Hack Squat",            "Hack Squats",           "", "6-10".x(2), restMins: 2.0),
        machine("Leg Extension 1",       "Leg Extensions",        "", "6-10".x(2), restMins: 2.0),
        barbell("Stiff-legged Deadlift", "Stiff-Legged Deadlift", "", "5-8".x(3), restMins: 2.0, bumpers: defaultBumpers()),
        machine("Leg Curls 1",           "Lying Leg Curls",       "", "6-10".x(2), restMins: 2.0),
        barbell("Standing Calf Raises",  "Standing Calf Raises",  "", "6-10".x(3), restMins: 2.0),
        machine("Seated Calf Raise 1",   "Seated Calf Raises",    "", "6-10".x(2), restMins: 2.0),

        // Back and Shoulders
        barbell("Speed Row",         "Pendlay Row",        speedWarmup, "3@70%".x(6), other: "Power Row", restMins: 1.5),
        dumbbell1("Rack Chins 2",    "Rack Chinup",        "", "8-12".x(3), restMins: 2.0),
        cable("Cable Row",           "Seated Cable Row",   "", "8-12".x(3), restMins: 2.0),
        dumbbell1("Kroc Row",        "Kroc Row",           "", "12-15".x(2), restMins: 2.0),
        cable("CG Lat Pulldown",     "Lat Pulldown",       "", "15-20".x(2), restMins: 2.0),
        dumbbell2("Seated DB OHP 2", "Dumbbell Seated Shoulder Press", "", "8-12".x(3), restMins: 2.0),
        barbell("Upright Row",       "Upright Row",        "", "12-15".x(2), restMins: 2.0),
        dumbbell2("Lateral Raise",   "Side Lateral Raise", "", "12-20".x(3), restMins: 2.0),

        // Lower Body
        barbell("Speed Squat",         "Low bar Squat",       speedSquatWarmup, "3@70%".x(6), other: "Power Squat", restMins: 1.5),
        barbell("Hack Squat",          "Hack Squat",          "", "8-12".x(3), restMins: 2.0),
        pairedPlates("Leg Press",      "Leg Press",           "", "12-15".x(2), restMins: 2.0),
        machine("Leg Extension 2",     "Leg Extensions",      "", "15-20".x(3), restMins: 2.0),
        barbell("Romanian Deadlift",   "Romanian Deadlift",   "", "8-12".x(3), restMins: 2.0),
        machine("Leg Curls 2",         "Lying Leg Curls",     "", "12-15".x(2), restMins: 2.0),
        machine("Seated Leg Curl",     "Seated Leg Curl",     "", "15-20".x(2), restMins: 2.0),
        machine("Donkey Calf Raises",  "Donkey Calf Raises",  "", "10-15".x(4), restMins: 2.0),
        machine("Seated Calf Raise 2", "Seated Calf Raises",  "", "15-20".x(3), restMins: 2.0),

        // Chest and Arms
        barbell("Speed DB Bench",        "Dumbbell Bench Press",        speedWarmup, "3@70%".x(6), other: "Power DB Bench", restMins: 1.5),
        barbell("Incline DB Press",      "Dumbbell Incline Press",      "", "8-12".x(3), restMins: 2.0),
        machine("Hammer Press",          "Hammer Strength Chest Press", "", "12-15".x(3), restMins: 2.0),
        cable("Incline Cable Flyes",     "Incline Cable Flye",          "", "15-20".x(2), restMins: 2.0),
        barbell("Preacher Curls",        "Preacher Curl",               "", "8-12".x(3), restMins: 2.0),
        dumbbell1("Concentration Curls", "Concentration Curls",         "", "12-15".x(2), restMins: 2.0),
        barbell("Spider Curls",          "Spider Curls",                "", "15-20".x(2), restMins: 2.0),
        barbell("Skullcrushers 2",       "Skull Crushers",              "", "8-12".x(3), restMins: 2.0),
        cable("Cable Pressdown",         "Cable Pressdown",             "", "12-15".x(2), restMins: 2.0),
        cable("Cable Kickbacks",         "Cable Kickbacks",             "", "12-15".x(2), restMins: 2.0)]
    
    let workouts = [
        Workout("Upper Power", ["Power Row", "Pullups", "Rack Chins 1", "Power DB Bench", "Dips", "Seated DB OHP 1", "EZ Curls", "Skullcrushers 1"], scheduled: true, optional: []),
            
        Workout("Lower Power", ["Power Squat", "Hack Squat", "Leg Extension 1", "Stiff-legged Deadlift", "Leg Curls 1", "Standing Calf Raises", "Seated Calf Raise 1"], scheduled: true, optional: []),
        
        Workout("Back and Shoulders", ["Speed Row", "Rack Chins 2", "Cable Row", "Kroc Row", "CG Lat Pulldown", "Seated DB OHP 2", "Upright Row", "Lateral Raise"], scheduled: true),
        
        Workout("Lower Body", ["Speed Squat", "Hack Squat", "Leg Press", "Leg Extension 2", "Romanian Deadlift", "Leg Curls 2", "Seated Leg Curl", "Donkey Calf Raises", "Seated Calf Raise 2"], scheduled: true),
        
        Workout("Chest and Arms", ["Speed DB Bench", "Incline DB Press", "Hammer Press", "Incline Cable Flyes", "Preacher Curls", "Concentration Curls", "Spider Curls", "Skullcrushers 2", "Cable Pressdown", "Cable Kickbacks"], scheduled: true)]
    
    let tags: [Program.Tags] = [.intermediate, .hypertrophy, .barbell, .unisex, .fiveDays, .ageUnder40]
    
    let description = """
[Power Hypertrophy Adaptive Training](http://www.simplyshredded.com/mega-feature-layne-norton-training-series-full-powerhypertrophy-routine-updated-2011.html) by Layne Norton. This is a five day a week program:

**Upper Power**
* Power Row 3x3-5
* Pullups 2x6-10
* Rack Chins 2x6-10
* Power DB Bench 3x3-5
* Dips 2x6-10
* Seated DB OHP 3x6-10
* EZ Curls 3x6-10
* Skullcrushers 3x6-10

**Lower Power**
* Power Squat 3x3-5
* Hack Squats 2x6-10
* Leg Extensions 2x6-10
* Stiff-legged Deadlift 3x5-8
* Lying Leg Curls 2x6-10
* Standing Calf Raise 3x6-10
* Seated Calf Raise 2x6-10

**Back and Shoulders**
* Speed Rows 6x3
* Rack Chins 3x8-12
* Cable Row 3x8-12
* Kroc Rows 2x12-15
* CG Pulldowns 2x15-20
* Seated DB OHP 3x8-12
* Upright Rows 2x12-15
* Lateral Raises 3x12-20

**Lower Body**
* Speed Squat 6x3
* Hack Squats 3x8-12
* Leg Press 2x12-15
* Leg Extensions 3x15-20
* Romanian Deadlift 3x8-12
* Lying Leg Curls 2x12-15
* Seated Leg Curls 2x15-20
* Donkey Calf Raises 4x10-15
* Seated Calf Raises 3x15-20

**Chest and Arms**
* Speed DB Bench 6x3
* Incline DB Press 3x8-12
* Hammer Press 3x12-15
* Incline Cable Flyes 2x15-20
* Preacher Curls 3x8-12
* Concentration Curls 2x12-15
* Spider Curls 2x15-20
* Cable Pressdown 2x12-15
* Cable Kickbacks 2x15-20

**Notes**
* This program has a lot of volume: until you adapt to the work load you may want to skip some of the assistence exercises.
* For the power lifts focus on lifting heavy and don't be afraid to take long rests (up to six minutes).
* For the speed lifts focus on explosive movements and don't rest longer than ninety seconds.
* Layne recommends deloading every 6-12 weeks: for 1-3 weeks lift at 60-70% of normal.
"""
    return Program("PHAT", workouts, exercises, tags, description)
}

