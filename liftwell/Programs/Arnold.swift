//  Created by Jesse Vorisek on 7/14/19.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation

func Arnold1() -> Program {
    let exercises = [
        // Chest and Back
        barbell("Bench Press",         "Bench Press",    "", "10".x(4), restMins: 1.0, main: true),
        barbell("Incline Bench Press", "Incline Bench Press",    "", "10".x(4), restMins: 1.0, main: true),
        dumbbell1("Dumbbell Pullovers",  "Dumbbell Pullovers",    "", "10".x(4), restMins: 1.0, main: true),
        bodyweight("Chinups",          "Chinup",      numSets: 4, startReps: 5, goalReps: 10, restMins: 1.0),
        barbell("Bent Over Row",       "Pendlay Row",    "", "10".x(4), restMins: 1.0, main: true),
        barbell("Deadlift",            "Deadlift",    "", "10".x(4), restMins: 1.0, main: true),
        bodyweight("Crunches",         "Situp",      numSets: 5, startReps: 10, goalReps: 25, restMins: 1.0, main: false),
        
        // Shoulders and Arms
        barbell("Barbell Clean and Press",  "Clean and Press",    "", "10".x(4), restMins: 1.0, main: true),
        dumbbell2("Dumbbell Lateral Raise", "Side Lateral Raise",    "", "10".x(4), restMins: 1.0, main: true),
        barbell("Upright Row",              "Upright Row",    "", "10".x(4), restMins: 1.0, main: true),
        barbell("Military Press",           "Military Press",    "", "10".x(4), restMins: 1.0, main: true),
        barbell("Standing Barbell Curl",    "Barbell Curl",    "", "10".x(4), restMins: 1.0, main: true),
        dumbbell2("Seated Dumbbell Curl",   "Incline Dumbbell Curl",    "", "10".x(4), restMins: 1.0, main: true),
        barbell("Close Grip Bench Press",   "Close-Grip Bench Press",    "", "10".x(4), restMins: 1.0, main: true),
        barbell("Standing Tricep Extension","French Press",    "", "10".x(4), restMins: 1.0, main: true),
        dumbbell1("Wrist Curls",            "Wrist Curls",    "", "10".x(4), restMins: 1.0, main: false),
        dumbbell2("Reverse Wrist Curls",    "Reverse Wrist Curl",    "", "10".x(4), restMins: 1.0, main: false),
        bodyweight("Reverse Crunch",        "Reverse Crunch",      numSets: 5, startReps: 10, goalReps: 25, restMins: 1.0, main: false),
        
        // Legs and Lower Back
        barbell("Squat",          "Low bar Squat",   "", "10".x(4), restMins: 1.0, main: true),
        barbell("Lunge",          "Barbell Lunge",   "", "10".x(4), restMins: 1.0, main: true),
        machine("Leg Curl",       "Seated Leg Curl", "", "10".x(4), restMins: 1.0),
        barbell("Stiff-Leg Dead", "Stiff-Legged Deadlift",   "", "10".x(4), restMins: 1.0, main: true),
        barbell("Good Morning",   "Good Morning",   "", "10".x(4), restMins: 1.0),
        barbell("Calf Raises",    "Standing Calf Raises",   "", "10".x(4), restMins: 1.0),
        // Crunches
    ]
    
    let workouts = [
        Workout("Chest and Back 1", ["Bench Press", "Incline Bench Press", "Dumbbell Pullovers", "Chinups", "Bent Over Row", "Deadlift", "Crunches"], scheduled: true, optional: []),
        
        Workout("Shoulders and Arms 2", ["Barbell Clean and Press", "Dumbbell Lateral Raise",  "Upright Row", "Military Press", "Standing Barbell Curl", "Seated Dumbbell Curl", "Close Grip Bench Press", "Standing Tricep Extension", "Wrist Curls", "Reverse Wrist Curls", "Reverse Crunch"], scheduled: true, optional: []),
        
        Workout("Legs and Lower Back 3", ["Squat", "Lunge", "Leg Curl", "Stiff-Leg Dead", "Good Morning", "Calf Raises", "Crunches"], scheduled: true),
        
        Workout("Chest and Back 4", ["Bench Press", "Incline Bench Press", "Dumbbell Pullovers", "Chinups", "Bent Over Row", "Deadlift", "Crunches"], scheduled: true),
        
        Workout("Shoulders and Arms 5",["Barbell Clean and Press", "Dumbbell Lateral Raise",  "Upright Row", "Military Press", "Standing Barbell Curl", "Seated Dumbbell Curl", "Close Grip Bench Press", "Standing Tricep Extension", "Wrist Curls", "Reverse Wrist Curls", "Reverse Crunch"], scheduled: true),
        
        Workout("Legs and Lower Back 6", ["Squat", "Lunge", "Leg Curl", "Stiff-Leg Dead", "Good Morning", "Calf Raises", "Crunches"], scheduled: true)]
    
    let tags: [Program.Tags] = [.advanced, .hypertrophy, .barbell, .sixDays, .ageUnder40] + anySex
    
    let description = """
High volume and frequency [workout](https://www.muscleandstrength.com/workouts/arnold-schwarzenegger-volume-workout-routines) from the [New Encyclopedia of Modern Bodybuilding](https://www.amazon.com/New-Encyclopedia-Modern-Bodybuilding-Updated-ebook/dp/B007US9NA8/ref=tmm_kin_swatch_0?_encoding=UTF8&qid=1569292919&sr=8-1) by Arnold Schwarzenegger and Bill Dobbins. This is a six day a week program and this version trains each body part twice a week:

**Chest and Back (days 1 & 4)**
* Bench Press 3-4x10
* Incline Bench Press 3-4x10
* Dumbbell Pullovers 3-4x10
* Chinups 3-4x10
* Bent Over Row 3-4x10
* Deadlift 3-4x10
* Crunches 5x25

**Shoulders and Arms (days 2 and 5)**
* Barbell Clean and Press 3-4x10
* Dumbbell Lateral Raise 3-4x10
* Upright Row 3-4x10
* Military Press 3-4x10
* Standing Barbell Curl 3-4x10
* Seated Dumbbell Curl 3-4x10
* Close Grip Bench Press 3-4x10
* Standing Barbell Tricep Extension 3-4x10
* Wrist Curls 3-4x10
* Reverse Wrist Curls 3-4x10
* Reverse Crunch 5x25

**Legs and Lower Back (days 3 & 6)**
* Squat 3-4x10
* Lunge 3-4x10
* Leg Curl 3-4x10
* Stiff Leg Deadlift 3-4x10
* Good Mornings 3-4x10
* Standing Calf Raise 3-4x10
* Crunches 5x25

**Notes**
* Attempt to reach failure around 10 reps for your first set of each exercise.
* For the remaining sets try for 10 reps.
* For everything but the ab work do 3-4 sets.
"""
    return Program("Arnold1", workouts, exercises, tags, description)
}

func Arnold2() -> Program {
    let exercises = [
        // Chest, Back, and Legs
        barbell("Bench Press",          "Bench Press",           "", "6-10".x(5), restMins: 1.0, main: true),
        dumbbell2("Dumbbell Flye",      "Dumbbell Flyes",        "", "6-10".x(5), restMins: 1.0),
        barbell("Incline Bench Press",  "Incline Bench Press",   "", "6-10".x(6), restMins: 1.0),
        cable("Cable Cross Over",       "Cable Crossover",       "", "10-12".x(6), restMins: 1.0),
        bodyweight("Dips",              "Dips",      numSets: 5, startReps: 40, goalReps: 100, restMins: 1.0),
        dumbbell1("Dumbbell Pullovers", "Dumbbell Pullovers",    "", "10-12".x(5), restMins: 1.0),
        bodyweight("Wide Pullups",      "Pullup",    numSets: 6, startReps: 48, goalReps: 120, restMins: 1.0),
        singlePlates("T-Bar Row",       "T-Bar Row",             "", "6-10".x(5), restMins: 1.0),
        cable("Seated Row",             "Seated Cable Row",      "", "6-10".x(6), restMins: 1.0),
        dumbbell1("One-arm DB Row",     "Dumbbell One Arm Row",  "", "6-10".x(5), restMins: 1.0),
        barbell("Stiff-Leg Dead",       "Stiff-Legged Deadlift", "", "15".x(6), restMins: 1.0, main: true),
        barbell("Squat",                "Low bar Squat",         "", "8-12".x(6), restMins: 1.0, main: true),
        pairedPlates("Leg Press",       "Leg Press",             "", "8-12".x(6), restMins: 1.0),
        machine("Leg Extension",        "Leg Extensions",        "", "12-15".x(6), restMins: 1.0),
        machine("Leg Curl",             "Seated Leg Curl",       "", "10-15".x(6), restMins: 1.0),
        barbell("Lunge",                "Barbell Lunge",         "", "15".x(5), restMins: 1.0),
        barbell("Calf Raises",          "Standing Calf Raises",  "", "10".x(10), restMins: 1.0),
        machine("Seated Calf Raise",    "Seated Calf Raises",    "", "15".x(8), restMins: 1.0),
        dumbbell1("One-Leg DB Calf Raise", "One-Leg DB Calf Raises",    "", "12".x(6), restMins: 1.0),
        dumbbell1("Wrist Curls",        "Wrist Curls",    "", "10".x(4), restMins: 1.0),
        barbell("Reverse Wrist Curl",   "Reverse Grip Wrist Curl", "", "8".x(4), restMins: 1.0),
        
        dumbbell1("Dumbbell Pullovers",  "Dumbbell Pullovers",    "", "10".x(4), restMins: 1.0, main: true),
        bodyweight("Chinups",          "Chinup",      numSets: 4, startReps: 5, goalReps: 10, restMins: 1.0),
        barbell("Bent Over Row",       "Pendlay Row",    "", "10".x(4), restMins: 1.0, main: true),
        barbell("Deadlift",            "Deadlift",    "", "10".x(4), restMins: 1.0, main: true),
        bodyweight("Crunches",         "Situp",      numSets: 5, startReps: 10, goalReps: 25, restMins: 1.0, main: false),

        barbell("Good Morning",   "Good Morning",   "", "10".x(4), restMins: 1.0),

        // Shoulders and Arms
        barbell("Barbell Clean and Press",  "Clean and Press",    "", "10".x(4), restMins: 1.0, main: true),
        dumbbell2("Dumbbell Lateral Raise", "Side Lateral Raise",    "", "10".x(4), restMins: 1.0, main: true),
        barbell("Upright Row",              "Upright Row",    "", "10".x(4), restMins: 1.0, main: true),
        barbell("Military Press",           "Military Press",    "", "10".x(4), restMins: 1.0, main: true),
        barbell("Standing Barbell Curl",    "Barbell Curl",    "", "10".x(4), restMins: 1.0, main: true),
        dumbbell2("Seated Dumbbell Curl",   "Incline Dumbbell Curl",    "", "10".x(4), restMins: 1.0, main: true),
        barbell("Close Grip Bench Press",   "Close-Grip Bench Press",    "", "10".x(4), restMins: 1.0, main: true),
        barbell("Standing Tricep Extension","French Press",    "", "10".x(4), restMins: 1.0, main: true),
        dumbbell2("Reverse Wrist Curls",    "Reverse Wrist Curl",    "", "10".x(4), restMins: 1.0, main: false),
        bodyweight("Reverse Crunch",        "Reverse Crunch",      numSets: 5, startReps: 10, goalReps: 25, restMins: 1.0, main: false),
        ]
    
    let workouts = [
        Workout("Chest and Back 1", ["Bench Press", "Incline Bench Press", "Dumbbell Pullovers", "Chinups", "Bent Over Row", "Deadlift", "Crunches"], scheduled: true, optional: []),
        
        Workout("Shoulders and Arms 2", ["Barbell Clean and Press", "Dumbbell Lateral Raise",  "Upright Row", "Military Press", "Standing Barbell Curl", "Seated Dumbbell Curl", "Close Grip Bench Press", "Standing Tricep Extension", "Wrist Curls", "Reverse Wrist Curls", "Reverse Crunch"], scheduled: true, optional: []),
        
        Workout("Legs and Lower Back 3", ["Squat", "Lunge", "Leg Curl", "Stiff-Leg Dead", "Good Morning", "Calf Raises", "Crunches"], scheduled: true),
        
        Workout("Chest and Back 4", ["Bench Press", "Incline Bench Press", "Dumbbell Pullovers", "Chinups", "Bent Over Row", "Deadlift", "Crunches"], scheduled: true),
        
        Workout("Shoulders and Arms 5",["Barbell Clean and Press", "Dumbbell Lateral Raise",  "Upright Row", "Military Press", "Standing Barbell Curl", "Seated Dumbbell Curl", "Close Grip Bench Press", "Standing Tricep Extension", "Wrist Curls", "Reverse Wrist Curls", "Reverse Crunch"], scheduled: true),
    
        Workout("Legs and Lower Back 6", ["Squat", "Lunge", "Leg Curl", "Stiff-Leg Dead", "Good Morning", "Calf Raises", "Crunches"], scheduled: true)]
    
    let tags: [Program.Tags] = [.advanced, .hypertrophy, .barbell, .sixDays, .ageUnder40] + anySex
    
    let description = """
Even higher volume and frequency [workout](https://www.muscleandstrength.com/workouts/arnold-schwarzenegger-volume-workout-routines) from the [New Encyclopedia of Modern Bodybuilding](https://www.amazon.com/New-Encyclopedia-Modern-Bodybuilding-Updated-ebook/dp/B007US9NA8/ref=tmm_kin_swatch_0?_encoding=UTF8&qid=1569292919&sr=8-1) by Arnold Schwarzenegger and Bill Dobbins. This is a six day a week program and this version trains each body part three times a week:

**Chest, Back, and Legs (days 1, 3, 5)**
* Bench Press 5x6-10
* Dumbbell Flye 5x6-10
* Incline Bench Press 6x6-10
* Cable Cross Over 6x10-12
* Dips 5 sets to failure
* Dumbbell Pullovers 5x10-12
* Wide Pullup 6 sets to failure
* T-bar Row 5x6-10
* Seated Row 6x6-10
* One-arm DB Row 5x6-10
* Stiff-leg Deadlift 6x15
* Squat 6x8-12
* Leg Press 6x8-12
* Leg Extension 6x12-15
* Leg Curl 6x10-15
* Barbell Lunge 5x15
* Standing Calf Raise 10x10
* Seated Calf Raise 8x15
* One Leg DB Calf Raise 6x12
* Wrist Curls 4x10
* Reverse Barbell Curl 4x8
* Wrist Roller 4 to failure
* Abs 30 min non-stop

**Shoulders and Arms (days 2, 4, 6)**
* Barbell Curl 5x6-10
* Seated DB Curl 5x6-10
* Concentration Curl 5x6-10
* CG Bench Press 5x6-10
* Tricep Pushdown 5x6-10
* French Press 5x6-10
* 1-Arm Tricep Extension 5x6-10
* Seated Barbell Press 5x6-10
* Lateral Raise 5x6-10
* Rear Delt Lateral Raise 5x6-10
* Cable Lateral Raise 5x10-12
* Standing Calf Raise 10x10
* Seated Calf Raise 8x15
* DB Calf Raise 6x12
* Wrist Curl 4x10
* Reverse Barbell Curl 4x8
* Wrist Roller Machine 4xfailure
* Non-stop Abs 30 mins
"""
    return Program("Arnold2", workouts, exercises, tags, description)
}

