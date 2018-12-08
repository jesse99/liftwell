//  Created by Jesse Jones on 11/14/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation

let strongCurvesWarmups = [
    // AC Warmup
    bodyweight("Foam Rolling",                 "IT-Band Foam Roll",               "10", restMins: 0.0),
    bodyweight("Hamstring Stretch",            "Foot Elevated Hamstring Stretch", 2, secs: 30),
    bodyweight("Psoas Stretch",                "Forward Lunge Stretch",           2, secs: 30),
    bodyweight("Adductors",                    "Standing Wide Leg Straddle",      1, secs: 30),
    bodyweight("Side Lying Abduction",         "Side Lying Abduction",            2, secs: 30),
    bodyweight("Bird-dog",                     "Bird-dog",                        1, by: 8, restMins: 0.0),
    bodyweight("Front Plank",                  "Front Plank",                     1, secs: 20, targetSecs: 120),
    bodyweight("LYTP",                         "LYTP",                            "10", restMins: 0.0),
    bodyweight("Walking Lunge",                "Body-weight Walking Lunge",       "10", restMins: 0.0),
    bodyweight("Wall Ankle Mobility",          "Wall Ankle Mobility",             "10", restMins: 0.0),
    bodyweight("Quadruped Thoracic Extension", "Quadruped Thoracic Extension",    "10", restMins: 0.0),
    bodyweight("Rotational Lunge",             "Rotational Lunge",                "10", restMins: 0.0),
    
    // B Warmup
    bodyweight("Tiger Tail Roller",             "Tiger Tail Roller",                "10", restMins: 0.0),
    bodyweight("SMR Glutes with Ball",          "SMR Glutes with Ball",             "10", restMins: 0.0),
    bodyweight("Standing Quad Stretch",         "Standing Quad Stretch",            2, secs: 30),
    bodyweight("Seated Piriformis Stretch",     "Seated Piriformis Stretch",        2, secs: 30),
    bodyweight("One-Handed Hang",               "One-Handed Hang",                  2, secs: 20, targetSecs: 30),
    bodyweight("Pec Stretch",                   "Doorway Chest Stretch",            2, secs: 30),
    bodyweight("Clam",                          "Clam",                             2, secs: 30),
    bodyweight("Side Plank",                    "Side Plank",                       2, secs: 20, targetSecs: 60),
    bodyweight("Pushup Plus",                   "Pushup Plus",                      "10", restMins: 0.0),
    bodyweight("Wall Extensions",               "Wall Extensions",                  "10", restMins: 0.0),
    bodyweight("Walking Knee Hugs",             "Walking Knee Hugs",                "10", restMins: 0.0),
    // omitted Superman per https://www.duncansportspt.com/2015/07/superman-exercise
    bodyweight("Squat to Stand",                "Squat to Stand",                   "10", restMins: 0.0),
    bodyweight("Swiss Ball Internal Rotation",  "Swiss Ball Hip Internal Rotation", "10", restMins: 0.0),
]

fileprivate let booty14Exercises: [Exercise] = [
    // A
    bodyweight("Glute Bridge",              "Glute Bridge",               "10-20".x(3), restMins: 0.5, main: true),
    dumbbell1("One Arm Row",                "Kroc Row",                   "", "8-12".x(3), restMins: 0.5, main: true),
    bodyweight("Box Squat",                 "Body-weight Box Squat",      "10-20".x(3), restMins: 1.0, main: true),
    dumbbell2("Dumbbell Bench Press",       "Dumbbell Bench Press",       "", "8-12".x(3), restMins: 1.0, main: true),
    dumbbell2("Dumbbell Romanian Deadlift", "Dumbbell Romanian Deadlift", "", "10-20".x(3), restMins: 1.0, main: true),
    bodyweight("Side Lying Abduction",      "Side Lying Abduction",       "15-30".x(2), restMins: 0.5),
    bodyweight("Front Plank",               "Front Plank",                1, secs: 20, targetSecs: 120),
    bodyweight("Side Plank from Knees",     "Side Plank",                 2, secs: 20, targetSecs: 60),
    
    // B
    // Glute Bridge
    cable("Lat Pulldown",       "Lat Pulldown",            "", "8-12".x(3), restMins: 1.0, main: true),
    bodyweight("Step-up",         "Step-ups",                "10-20".x(3), restMins: 0.5, main: true),
    dumbbell2("Dumbbell OHP",      "Dumbbell Shoulder Press", "", "8-12".x(3), restMins: 1.0, main: true),
    bodyweight("Back Extension",  "Back Extension",          "10-20".x(3), restMins: 0.5),
    bodyweight("Side Lying Clam", "Clam",                    "15-30", restMins: 0.5),
    bodyweight("Crunch",          "Situp",                   "15-30", restMins: 0.5),
    bodyweight("Side Crunch",     "Oblique Crunches",        "15-30", restMins: 0.5),
    
    // C
    bodyweight("Glute March",           "Glute March",                     3, secs: 60, main: true),
    cable("Seated Row",                 "Seated Cable Row",                "", "8-12".x(3), restMins: 1.0, main: true),
    bodyweight("Body-weight Squat",     "Body-weight Squat",               "10-20".x(3), restMins: 1.0, main: true),
    dumbbell2("Dumbbell Incline Press", "Dumbbell Incline Press",          "", "8-12".x(3), restMins: 1.0, main: true),
    bodyweight("Romanian Deadlift",     "Body-weight Single Leg Deadlift", "10-20".x(3), restMins: 0.5, main: true),
    bodyweight("X-Band Walk",           "X-Band Walk",                     "10-20", restMins: 0.5),
    bodyweight("RKC Plank",             "RKC Plank",                       1, secs: 10, targetSecs: 30),
    cable("Rope Horizontal Chop",       "Rope Horizontal Chop",            "", "5-10", restMins: 0.5),
    ] + strongCurvesWarmups

fileprivate let booty58Exercises: [Exercise] = [
    // A
    bodyweight("Hip Thrust",              "Body-weight Hip Thrust",               "10-20".x(3), restMins: 0.5, main: true),
    cable("One Arm Cable Row",          "Standing One Arm Cable Row",           "", "8-12".x(3), restMins: 0.5, main: true),
    bodyweight("Step Up + Reverse Lunge", "Body-weight Step Up + Reverse Lunge",  "10-20".x(3), restMins: 0.5, main: true),
    barbell("Bench Press",                "Bench Press",                          "", "8-12".x(3), restMins: 2.0, main: true),
    barbell("Romanian Deadlift",          "Romanian Deadlift",                    "", "10-20".x(3), restMins: 2.0, main: true),
    bodyweight("Side Lying Abduction",    "Side Lying Abduction",                 "15-30", restMins: 0.5),
    bodyweight("Decline Plank",           "Decline Plank",                        1, secs: 20, targetSecs: 60),
    bodyweight("Side Plank",              "Side Plank",                           2, secs: 20, targetSecs: 60),
    
    // B
    bodyweight("Glute Bridge",           "Glute Bridge",              "10-20".x(3), restMins: 0.5, main: true),
    bodyweight("Negative Chinup",        "Chinup",                    "3".x(3), restMins: 1.0, main: true),
    bodyweight("Walking Lunge",          "Body-weight Walking Lunge", "10-20".x(3), restMins: 1.0, main: true),
    dumbbell2("Dumbbell OHP",            "Dumbbell Shoulder Press",   "", "8-12".x(3), restMins: 1.0, main: true),
    bodyweight("Reverse Hyperextension", "Reverse Hyperextension",    "10-20".x(3), restMins: 0.5),
    bodyweight("Clam",                   "Clam",                      "15-30", restMins: 0.5),
    bodyweight("Swiss Ball Crunch",      "Exercise Ball Crunch",      "15-30", restMins: 0.5),
    bodyweight("Swiss Ball Side Crunch", "Exercise Ball Side Crunch", "15-30", restMins: 0.5),
    
    // C
    bodyweight("Hip Thrust (paused)", "Hip Thrust (rest pause)",  "10-20".x(3), restMins: 0.5, main: true),
    bodyweight("Inverted Row",        "Inverted Row",             "8-12".x(3), restMins: 0.5, main: true),
    dumbbell1("Goblet Squat",         "Goblet Squat",             "", "10-20".x(3), restMins: 2.0, main: true),
    barbell("Close-Grip Bench Press", "Close-Grip Bench Press",   "", "8-12".x(3), restMins: 2.0, main: true),
    bodyweight("Kettlebell Swing",    "Kettlebell Two Arm Swing", "10-20".x(3), restMins: 0.5),
    bodyweight("X-Band Walk",         "X-Band Walk",              "15-30", restMins: 0.5),
    bodyweight("Straight Leg Situp",  "Straight Leg Situp",       "15-30", restMins: 0.5),
    bodyweight("Anti-Rotary Hold",    "Band Anti-Rotary Hold",    2, secs: 10, targetSecs: 20),
    ] + strongCurvesWarmups

fileprivate let booty912Exercises: [Exercise] = [
    // A
    barbell("Hip Thrust",              "Hip Thrust",             "", "10-20".x(3), restMins: 1.0, main: true),
    dumbbell2("Dumbbell Row",           "Bent Over Dumbbell Row", "", "8-12".x(3), restMins: 1.0, main: true),
    barbell("Box Squat",               "Box Squat",              "", "10-20".x(3), restMins: 2.0, main: true),
    bodyweight("Pushup",               "Pushup",                 "3-10".x(3), restMins: 0.5, main: true),
    barbell("Deadlift",                "Deadlift",               "", "10-20".x(3), restMins: 2.0, main: true),
    bodyweight("Side Lying Abduction", "Side Lying Abduction",   "15-30", restMins: 0.5),
    dumbbell1("Dumbbell Ball Crunch",  "Exercise Ball Crunch",   "", "15-30", restMins: 0.5),
    cable("Anti-Rotation Press",       "Half-kneeling Cable Anti-Rotation Press", "", "10-15", restMins: 0.5),
    
    // B
    bodyweight("Single Leg Hip Thrust", "Body-weight Single Leg Hip Thrust", "10-20".x(3), restMins: 1.0, main: true),
    bodyweight("Chinup",                "Chinup",                            "1-5".x(3), restMins: 1.0, main: true),
    bodyweight("Bulgarian Split Squat", "Body-weight Bulgarian Split Squat", "10-20".x(3), restMins: 1.0, main: true),
    dumbbell1("One Arm OHP",             "Dumbbell One Arm Shoulder Press",   "", "8-12".x(3), restMins: 1.0, main: true),
    barbell("Good Morning",             "Good Morning",                      "", "10-20".x(3), restMins: 1.0, main: true),
    bodyweight("X-Band Walk",           "X-Band Walk",                       "15-30", restMins: 0.5),
    bodyweight("Decline Plank",         "Decline Plank",                     1, secs: 60, targetSecs: 120),
    dumbbell2("Side Bend",              "Dumbbell Side Bend",                "", "15-30", restMins: 1.0),
    
    // C
    barbell("Hip Thrust (paused)",   "Hip Thrust (rest pause)", "", "8-12".x(3), restMins: 1.0, main: true),
    dumbbell2("Incline Row",          "Dumbbell Incline Row",    "", "8-12".x(3), restMins: 1.0, main: true),
    barbell("Squat",                 "Low bar Squat",           "", "10-20".x(3), restMins: 2.0, main: true),
    barbell("Incline Bench Press",   "Incline Bench Press",     "", "3-10".x(3), restMins: 2.0, main: true),
    bodyweight("Back Extension",     "Back Extension",          "10-30".x(3), restMins: 0.5),
    bodyweight("Clam",               "Clam",                    "15-30", restMins: 0.5),
    bodyweight("Hanging Leg Raise",  "Hanging Leg Raise",       "10-20", restMins: 0.5),
    cable("Rope Horizontal Chop",    "Rope Horizontal Chop",    "", "10-15", restMins: 0.5),
    ] + strongCurvesWarmups

fileprivate let booty14AExercises = ["Glute Bridge", "One Arm Row", "Box Squat", "Dumbbell Bench Press", "Dumbbell Romanian Deadlift", "Side Lying Abduction", "Front Plank", "Side Plank from Knees"]
fileprivate let booty14BExercises = ["Glute Bridge", "Lat Pulldown", "Step-up", "Dumbbell OHP", "Back Extension", "Side Lying Clam", "Crunch", "Side Crunch"]
fileprivate let booty14CExercises = ["Glute March", "Seated Row", "Body-weight Squat", "Dumbbell Incline Press", "Romanian Deadlift", "X-Band Walk", "RKC Plank", "Rope Horizontal Chop"]

fileprivate let booty58AExercises = ["Hip Thrust", "One Arm Cable Row", "Step Up + Reverse Lunge", "Bench Press", "Romanian Deadlift", "Side Lying Abduction", "Decline Plank", "Side Plank"]
fileprivate let booty58BExercises = ["Glute Bridge", "Negative Chinup", "Walking Lunge", "Dumbbell OHP", "Reverse Hyperextension", "Clam", "Swiss Ball Crunch", "Swiss Ball Side Crunch"]
fileprivate let booty58CExercises = ["Hip Thrust (paused)", "Inverted Row", "Goblet Squat", "Close-Grip Bench Press", "Kettlebell Swing", "X-Band Walk", "Straight Leg Situp", "Anti-Rotary Hold"]

fileprivate let booty912AExercises = ["Hip Thrust", "Dumbbell Row", "Box Squat", "Pushup", "Deadlift", "Side Lying Abduction", "Dumbbell Ball Crunch", "Anti-Rotation Press"]
fileprivate let booty912BExercises = ["Single Leg Hip Thrust", "Chinup", "Bulgarian Split Squat", "One Arm OHP", "Good Morning", "X-Band Walk", "Decline Plank", "Side Bend"]
fileprivate let booty912CExercises = ["Hip Thrust (paused)", "Incline Row", "Squat", "Incline Bench Press", "Back Extension", "Clam", "Hanging Leg Raise", "Rope Horizontal Chop"]

let strongCurvesACWarmup = ["Foam Rolling", "Hamstring Stretch", "Psoas Stretch", "Adductors", "Side Lying Abduction", "Bird-dog", "Front Plank", "LYTP", "Walking Lunge", "Wall Ankle Mobility", "Quadruped Thoracic Extension", "Rotational Lunge"]
let strongCurvesBWarmup = ["Tiger Tail Roller", "SMR Glutes with Ball", "Standing Quad Stretch", "Seated Piriformis Stretch", "One-Handed Hang", "Pec Stretch", "Clam", "Side Plank", "Pushup Plus", "Wall Extensions", "Walking Knee Hugs", "Squat to Stand", "Swiss Ball Internal Rotation"]

fileprivate let booty14ADesc = """
* Bodyweight Glute Bridge 3x10-20
* One Arm Row 3x8-12 (each side)
* Bodyweight Box Squat 3x10-20
* Dumbbell Bench Press 3x8-12
* Dumbbell Romanian Deadlift 3x10-20
* Side Lying Abduction 2x15-30 (per side)
* Front Plank 1x20-120s
* Side Plank from Knees 1x20-60s (per side)
"""

fileprivate let booty14BDesc = """
* Bodyweight Single-leg Glute Bridge 3x10-20 (set per side)
* Lat Pulldown 3x8-12
* Bodyweight Step-up 3x10-20 (per side)
* Dumbbell Overhead Press 3x8-12
* Back Extension 3x10-20
* Side Lying Clam 1x15-30 (per side)
* Crunch 1x15-30
* Side Crunch 1x15-30 (per side)
"""

fileprivate let booty14CDesc = """
* Glute March 3x60s
* Seated Row 3x8-12
* Bodyweight Squat 3x10-20
* Dumbbell Incline Press 3x8-12
* Bodyweight Romanian Deadlift 3x10-20 (per side)
* X-Band Walk (light tension) 1x10-20 steps (per side)
* RKC Plank 1x10-30s
* Rope Horz Chop 1x5-10 (per side)
"""

fileprivate let booty58ADesc = """
* Bodyweight Hip Thrust 3x10-20
* Standing Single-arm Cable-row 3x8-12
* Bodyweight Step up/Reverse lunge 3x10-20
* Bench Press 3x8-12
* Romanian Deadlift 3x10-20
* Side Lying Abduction 1x15-30
* Feet Elevated Plank 1x20-60s
* Side Plank 1x20-60s
"""

fileprivate let booty58BDesc = """
* Bodyweight Single-leg Glute Bridge 3x-10-20 (per side)
* Negative Chinup 3x3 (or lat pulldown)
* Bodyweight Walking Lunge 3x10-20
* Dumbbell OHP 3x8-12
* Bodyweight Reverse Hyper 3x10-20
* Side Lying Clam 1x15-30 (per side)
* Swiss Ball Crunch 1x15-30
* Swiss Ball Side Crunch 1x15-30
"""

fileprivate let booty58CDesc = """
* Bodyweight Hip thrust 3x10-20 (paused)
* Modified Inverted Row 3x8-12
* Goblet squat 3x10-20
* Close-grip Bench Press 3x8-12
* Russian Kettlebell Swing 3x10-20
* X-band Walk (moderate) 1x15-30 (per side)
* Straight-leg Situp 1x15-30
* Band Rotary Hold 1x10-20s (per side)
"""

fileprivate let booty912ADesc = """
* Barbell Hip Thrust 3x10-20
* Dumbbell Bent Over Row 3x8-12
* Barbell Box Squat 3x10-20
* Push-up 3x3-10
* Barbell Deadlift 3x10-20
* Side Lying Abduction 1x15-30 (per side)
* Dumbbell Swiss Ball Crunch 1x15-30 (per side)
* Half-kneeling Cable Anti-Rotation Press 1x10-15 (per side)
"""

fileprivate let booty912BDesc = """
* Bodyweight Single-leg Hip Thrust (shoulders elevated) 3x10-20 (per side)
* Chin-up (or assisted) 3x1-5
* Bodyweight Bulgarian Split Squat 3x10-20
* Single-arm Dumbbell OHP 3x8-12
* Barbell Good Morning 3x10-20
* X-band Walk (moderate) 1x15-30 (per side)
* Feet Elevated Plank 1x60-120s
* Dumbbell Side Bend 1x15-30 (per side)
"""

fileprivate let booty912CDesc = """
* Barbell Hip Thrust (paused) 3x8-12
* Dumbbell Chest Supported Row 3x8-10
* Barbell Squat 3x10-20
* Incline Press 3x3-10
* Bodyweight Back Extension 3x10-30
* Side Lying Clam 1x15-30 (per side)
* Hanging Leg Raise 1x10-20
* Rope Horizontal Chop 1x10-15 (per side)
"""

fileprivate let bootyNotes = """
* Bret recommends spending 10-15 minutes warming up before each workout.
* When foam rolling Bret recommends hitting the erectors, quads, IT Band, hip flexors, hamsttrings, adductors, glutes, calves, and lats.
* For the Stick/Tiger Tail roller warmup hit the IT-band, quads, calves, and shins.
* Focus on activating the glutes with each exercise.
* When performing a single leg/arm exercise begin with the weaker limb and then do the same number of reps with the stronger limb.
* If you're having an off day don't continue a set if your form begins to break down.
* To speed up the workouts you can superset the exercises: do a set of a lower body exercise, a set of an upper body, rest for 60-120s, and repeat until you've finished all the sets for both exercises.
* Once you've done all the indicated workouts the app will prompt you to move onto the next program.
"""

func Bootyful14a() -> Program {
    let workouts = [
        Workout("A1", booty14AExercises, scheduled: true, optional: []),
        Workout("B",  booty14BExercises, scheduled: true, optional: []),
        Workout("A2", booty14AExercises, scheduled: true, optional: []),
        Workout("C",  booty14CExercises, scheduled: true, optional: []),
        
        Workout("AC warmup", strongCurvesACWarmup, scheduled: false, optional: []),
        Workout("B warmup", strongCurvesBWarmup, scheduled: false, optional: []),
        ]
    
    let tags: [Program.Tags] = [.beginner, .hypertrophy, .gym, .fourDays, .female, .ageUnder40, .age40s, .age50s]
    let description = """
This is the 4 days/week version of weeks 1-4 of the beginner program from [Strong Curves: A Woman's Guide to Building a Better Butt and Body](https://www.amazon.com/Strong-Curves-Womans-Building-Better-ebook/dp/B00C4XI0QM/ref=sr_1_1?ie=UTF8&qid=1516764374&sr=8-1&keywords=strong+curves). The program is as follows (Bret recommends warmups, and they are part of the program, but there are a lot so they aren't listed here):

**Workout A**
\(booty14ADesc)

**Workout B**
\(booty14BDesc)

**Cardio**

**Workout A (again)**

**Workout C**
\(booty14CDesc)

**Cardio**

**Rest**

**Notes**
\(bootyNotes)
"""
    return Program("Bootyful Beginnings/4 1-4", workouts, booty14Exercises, tags, description, maxWorkouts: 4*4, nextProgram: "Bootyful Beginnings/4 5-8")
}

func Bootyful14b() -> Program {
    let workouts = [
        Workout("A1", booty58AExercises, scheduled: true, optional: []),
        Workout("B",  booty58BExercises, scheduled: true, optional: []),
        Workout("A2", booty58AExercises, scheduled: true, optional: []),
        Workout("C",  booty58CExercises, scheduled: true, optional: []),
        
        Workout("AC warmup", strongCurvesACWarmup, scheduled: false, optional: []),
        Workout("B warmup", strongCurvesBWarmup, scheduled: false, optional: []),
        ]
    
    let tags: [Program.Tags] = [.beginner, .hypertrophy, .gym, .fourDays, .female, .ageUnder40, .age40s, .age50s]
    let description = """
This is the 4 days/week version of weeks 5-8 of the beginner program from [Strong Curves: A Woman's Guide to Building a Better Butt and Body](https://www.amazon.com/Strong-Curves-Womans-Building-Better-ebook/dp/B00C4XI0QM/ref=sr_1_1?ie=UTF8&qid=1516764374&sr=8-1&keywords=strong+curves). The program is as follows (Bret recommends warmups, and they are part of the program, but there are a lot so they aren't listed here):

**Workout A**
\(booty58ADesc)

**Workout B**
\(booty58BDesc)

**Cardio**

**Workout A (again)**

**Workout C**
\(booty58CDesc)

**Cardio**

**Rest**

**Notes**
\(bootyNotes)
"""
    return Program("Bootyful Beginnings/4 5-8", workouts, booty58Exercises, tags, description, maxWorkouts: 4*4, nextProgram: "Bootyful Beginnings/4 9-12")
}

func Bootyful14c() -> Program {
    let workouts = [
        Workout("A1", booty912AExercises, scheduled: true, optional: []),
        Workout("B",  booty912BExercises, scheduled: true, optional: []),
        Workout("A2", booty912AExercises, scheduled: true, optional: []),
        Workout("C",  booty912CExercises, scheduled: true, optional: []),
        
        Workout("AC warmup", strongCurvesACWarmup, scheduled: false, optional: []),
        Workout("B warmup", strongCurvesBWarmup, scheduled: false, optional: []),
        ]
    
    let tags: [Program.Tags] = [.beginner, .hypertrophy, .gym, .fourDays, .female, .ageUnder40, .age40s, .age50s]
    let description = """
This is the 4 days/week version of weeks 9-12 of the beginner program from [Strong Curves: A Woman's Guide to Building a Better Butt and Body](https://www.amazon.com/Strong-Curves-Womans-Building-Better-ebook/dp/B00C4XI0QM/ref=sr_1_1?ie=UTF8&qid=1516764374&sr=8-1&keywords=strong+curves). The program is as follows (Bret recommends warmups, and they are part of the program, but there are a lot so they aren't listed here):

**Workout A**
\(booty912ADesc)

**Workout B**
\(booty912BDesc)

**Cardio**

**Workout A (again)**

**Workout C**
\(booty912CDesc)

**Cardio**

**Rest**

**Notes**
\(bootyNotes)
"""
    return Program("Bootyful Beginnings/4 9-12", workouts, booty912Exercises, tags, description, maxWorkouts: 4*4, nextProgram: "Gluteal Goddess/4 1-4")
}







































// Weeks 1-4 for 3 days/week version of Bootyful Beginnings.
func Bootyful3a() -> Program {
    let workouts = [
        Workout("A", booty14AExercises, scheduled: true, optional: []),
        Workout("B", booty14BExercises, scheduled: true, optional: []),
        Workout("C", booty14CExercises, scheduled: true, optional: []),
        
        Workout("AC warmup", strongCurvesACWarmup, scheduled: false, optional: []),
        Workout("B warmup", strongCurvesBWarmup, scheduled: false, optional: []),
        ]
    
    let tags: [Program.Tags] = [.beginner, .hypertrophy, .gym, .threeDays, .female, .ageUnder40, .age40s, .age50s]
    let description = """
This is the 3 days/week version of weeks 1-4 of the beginner program from [Strong Curves: A Woman's Guide to Building a Better Butt and Body](https://www.amazon.com/Strong-Curves-Womans-Building-Better-ebook/dp/B00C4XI0QM/ref=sr_1_1?ie=UTF8&qid=1516764374&sr=8-1&keywords=strong+curves). The program is as follows (Bret recommends warmups, and they are part of the program, but there are a lot so they aren't listed here):

**Workout A**
\(booty14ADesc)

**Cardio**

**Workout B**
\(booty14BDesc)

**Cardio**

**Workout C**
\(booty14CDesc)

**Cardio**

**Rest**

**Notes**
\(bootyNotes)
"""
    return Program("Bootyful Beginnings/3 1-4", workouts, booty14Exercises, tags, description, maxWorkouts: 3*4, nextProgram: "Bootyful Beginnings/3 5-8")
}

// Weeks 5-8 for 3 days/week version of Bootyful Beginnings.
func Bootyful3b() -> Program {
    let workouts = [
        Workout("A", booty58AExercises, scheduled: true, optional: []),
        Workout("B", booty58BExercises, scheduled: true, optional: []),
        Workout("C", booty58CExercises, scheduled: true, optional: []),
        
        Workout("AC warmup", strongCurvesACWarmup, scheduled: false, optional: []),
        Workout("B warmup", strongCurvesBWarmup, scheduled: false, optional: []),
        ]
    
    let tags: [Program.Tags] = [.beginner, .hypertrophy, .gym, .threeDays, .female, .ageUnder40, .age40s, .age50s]
    let description = """
This is the 3 days/week version of weeks 5-8 of the beginner program from [Strong Curves: A Woman's Guide to Building a Better Butt and Body](https://www.amazon.com/Strong-Curves-Womans-Building-Better-ebook/dp/B00C4XI0QM/ref=sr_1_1?ie=UTF8&qid=1516764374&sr=8-1&keywords=strong+curves). The program is as follows (Bret recommends warmups, and they are part of the program, but there are a lot so they aren't listed here):

**Workout A**
\(booty58ADesc)

**Cardio**

**Workout B**
\(booty58BDesc)

**Cardio**

**Workout C**
\(booty58CDesc)

**Cardio**

**Rest**

**Notes**
\(bootyNotes)
"""
    return Program("Bootyful Beginnings/3 5-8", workouts, booty58Exercises, tags, description, maxWorkouts: 3*4, nextProgram: "Bootyful Beginnings/3 9-12")
}

// Weeks 9-12 for 3 days/week version of Bootyful Beginnings.
func Bootyful3c() -> Program {
    let workouts = [
        Workout("A", booty912AExercises, scheduled: true, optional: []),
        Workout("B", booty912BExercises, scheduled: true, optional: []),
        Workout("C", booty912CExercises, scheduled: true, optional: []),
        
        Workout("AC warmup", strongCurvesACWarmup, scheduled: false, optional: []),
        Workout("B warmup", strongCurvesBWarmup, scheduled: false, optional: []),
        ]
    
    let tags: [Program.Tags] = [.beginner, .hypertrophy, .gym, .threeDays, .female, .ageUnder40, .age40s, .age50s]
    let description = """
This is the 3 days/week version of weeks 9-12 of the beginner program from [Strong Curves: A Woman's Guide to Building a Better Butt and Body](https://www.amazon.com/Strong-Curves-Womans-Building-Better-ebook/dp/B00C4XI0QM/ref=sr_1_1?ie=UTF8&qid=1516764374&sr=8-1&keywords=strong+curves). The program is as follows (Bret recommends warmups, and they are part of the program, but there are a lot so they aren't listed here):

**Workout A**
\(booty912ADesc)

**Cardio**

**Workout B**
\(booty912BDesc)

**Cardio**

**Workout C**
\(booty912CDesc)

**Cardio**

**Rest**

**Notes**
\(bootyNotes)
"""
    return Program("Bootyful Beginnings/3 9-12", workouts, booty912Exercises, tags, description, maxWorkouts: 3*4, nextProgram: "Gluteal Goddess 1-4")
}

