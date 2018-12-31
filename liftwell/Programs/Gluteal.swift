//  Created by Jesse Jones on 12/1/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation

fileprivate let notes = """
* This program should be started once you have built a base of strength using a program like Booty-ful Beginnings.
* Attempt to increase weights by 5-10 pounds each week.
* Bret recommends spending 10-15 minutes warming up before each workout.
* When foam rolling Bret recommends hitting the erectors, quads, IT Band, hip flexors, hamsttrings, adductors, glutes, calves, and lats.
* For the Stick/Tiger Tail roller warmup hit the IT-band, quads, calves, and shins.
* Focus on activating the glutes with each exercise.
* When performing a single leg/arm exercise begin with the weaker limb and then do the same number of reps with the stronger limb.
* If you're having an off day don't continue a set if your form begins to break down.
* To speed up the workouts you can superset the exercises: do a set of a lower body exercise, a set of an upper body, rest for 60-120s, and repeat until you've finished all the sets for both exercises.
* Once you've done all the indicated workouts the app will prompt you to move onto the next program.
"""

// Weeks 1-4 for 3 days/week version of Gluteal Goddess.
func GlutealGoddess1() -> Program {
    let exercises: [Exercise] = [
        // A
        barbell("Glute Bridge",            "Glute Bridge",           "", "20".x(3), restMins: 2.0, main: true),
        dumbbell1("One Arm Row",            "Kroc Row",               "", "8".x(3), restMins: 1.0, main: true),
        barbell("Box Squat",               "Body-weight Box Squat",  "", "5".x(3), restMins: 2.0, main: true),
        dumbbell2("Dumbbell Incline Press", "Dumbbell Incline Press", "", "8".x(3), restMins: 1.0, main: true),
        barbell("Deadlift",                "Deadlift",               "", "8".x(3), restMins: 2.0, main: true),
        cable("Cable Hip Abduction",     "Cable Hip Abduction",    "", "20", restMins: 0.5),
        bodyweight("RKC Plank",            "RKC Plank",              1, secs: 60),
        bodyweight("Side Plank",           "Side Plank",             2, secs: 60),
        
        // B
        bodyweight("Single Leg Hip Thrust",   "Body-weight Single Leg Hip Thrust", "8-20".x(3), restMins: 1.0, main: true),
        bodyweight("Chinup",                  "Chinup",                            "5".x(3), restMins: 2.0, main: true),
        dumbbell2("Dumbbell Step Up",          "Deep Step-ups",                     "", "10".x(3), restMins: 2.0, main: true),
        barbell("Overhead Press",             "Overhead Press",                    "", "8".x(3), restMins: 2.0, main: true),
        bodyweight("Prisoner Back Extension", "Back Extension",                    2, by: 12, restMins: 1.0),
        bodyweight("Band Seated Abduction",   "Band Seated Abduction",             "20", restMins: 1.0),
        bodyweight("Straight-leg Situp",      "Straight Leg Situp",                "20", restMins: 1.0),
        bodyweight("Side Bend",               "Side Bend (45 degree)",             "20", restMins: 1.0),
        
        // C
        barbell("Hip Thrust",              "Hip Thrust",                   "", "20".x(3), restMins: 2.0, main: true),
        cable("One Arm Cable Row",       "Standing One Arm Cable Row",   "", "8".x(3), restMins: 1.0, main: true),
        dumbbell1("Goblet Squat",           "Goblet Squat",                 "", "5".x(3), restMins: 2.0, main: true),
        dumbbell1("One Arm Bench Press",    "Dumbbell One Arm Bench Press", "", "8".x(3), restMins: 1.0, main: true),
        cable("Pull Through",            "Pull Through",                 "", "8-12".x(3), restMins: 1.0),
        bodyweight("Side Lying Hip Raise", "Side Lying Hip Raise",         1, by: 10, restMins: 1.0),
        bodyweight("Turkish Get-Up",       "Turkish Get-Up",               "5", restMins: 1.0),
        cable("Anti-Rotation Press",     "Half-kneeling Cable Anti-Rotation Press", "", "8-12", restMins: 2.0),
        ] + strongCurvesWarmups
    
    let aExercises = ["Glute Bridge", "One Arm Row", "Box Squat", "Dumbbell Incline Press", "Deadlift", "Cable Hip Abduction", "RKC Plank", "Side Plank"]
    let bExercises = ["Single Leg Hip Thrust", "Chinup", "Dumbbell Step Up", "Overhead Press", "Prisoner Back Extension", "Band Seated Abduction", "Straight-leg Situp", "Side Bend"]
    let cExercises = ["Hip Thrust", "One Arm Cable Row", "Goblet Squat", "One Arm Bench Press", "Pull Through", "Side Lying Hip Raise", "Turkish Get-Up", "Anti-Rotation Press"]
    
    let workouts = [
        Workout("A", aExercises, scheduled: true, optional: []),
        Workout("B", bExercises, scheduled: true, optional: []),
        Workout("C", cExercises, scheduled: true, optional: []),
        
        Workout("AC warmup", strongCurvesACWarmup, scheduled: false, optional: []),
        Workout("B warmup", strongCurvesBWarmup, scheduled: false, optional: []),
        ]
    
    let tags: [Program.Tags] = [.intermediate, .hypertrophy, .gym, .threeDays, .female, .ageUnder40, .age40s, .age50s]
    let description = """
This is the weeks 1-4 of the intermediate program from [Strong Curves: A Woman's Guide to Building a Better Butt and Body](https://www.amazon.com/Strong-Curves-Womans-Building-Better-ebook/dp/B00C4XI0QM/ref=sr_1_1?ie=UTF8&qid=1516764374&sr=8-1&keywords=strong+curves). The program is as follows (Bret recommends warmups, and they are part of the program, but there are a lot so they aren't listed here):

**Workout A**
* Barbell Glute Bridge 3x20
* One Arm Row 3x8 (per side)
* Barbell Box Squat 3x5
* Dumbbell Incline Press 3x8
* Deadlift 3x8
* Cable Standing Abduction 1x20 (per side)
* RKC Plank 1x60s
* Side Plank 2x60s (per side)

**Cardio**

**Workout B**
* Bodyweight Shoulder Elevated Single-leg Hip Thrust 3x8-20 (per side)
* Chinup 3x5
* Dumbbell High Step-up 3x10 (per side)
* Barbell Overhead Press 3x8
* Prisoner Back Extension 2x12
* Band Seated Abduction 1x20
* Straight-leg Situp 1x20
* 45-degree Side Bend 1x20

**Cardio**

**Workout C**
* Barbell Hip Thrust 3x20
* Standing Single-arm Cable Row 3x8 (per side)
* Goblet Squat 3x5
* Single Arm Bench Press 3x8
* Cable Straight-leg Pull-Through 3x8-12
* Side-lying Hip Raise 1x10 (per side)
* Turkish Get Up 1x5 (per side)
* Half-kneeling Cable Anti-rotation Press 1x8-12 (per side)

**Cardio**

**Rest**

**Notes**
\(notes)
"""
    return Program("Gluteal Goddess 1-4", workouts, exercises, tags, description, maxWorkouts: 3*4, nextProgram: "Gluteal Goddess 5-8")
}

// Weeks 5-8 for 3 days/week version of Gluteal Goddess.
func GlutealGoddess2() -> Program {
    let exercises: [Exercise] = [
        // A
        barbell("Hip Thrust",                 "Hip Thrust",              "", "3-8".x(3), restMins: 2.0, main: true),
        cable("Seated Row",                 "Seated Cable Row",        "", "8".x(3), restMins: 1.0, main: true),
        barbell("Squat",                      "Low bar Squat",           "", "5".x(3), restMins: 2.0, main: true),
        barbell("Bench Press",                "Bench Press",             "", "3-8".x(3), restMins: 2.0, main: true),
        barbell("Good Morning",               "Good Morning",            "", "8-12".x(3), restMins: 2.0),
        bodyweight("Band Standing Abduction", "Band Standing Abduction", "10-30", restMins: 1.0),
        bodyweight("Ab Wheel Rollout",        "Ab Wheel Rollout",        "8-20", restMins: 1.0),
        dumbbell2("Dumbbell Side Bend",        "Dumbbell Side Bend",      "", "10-20".x(3) , restMins: 1.0),
        
        // B
        bodyweight("Single Leg Hip Thrust",   "Body-weight Single Leg Hip Thrust", "8-20".x(3), restMins: 1.0, main: true),
        bodyweight("Pullup",                  "Pullup",                            "3-8".x(3), restMins: 2.0, main: true),
        dumbbell2("Dumbbell Lunge",            "Dumbbell Lunge",                    "", "10".x(3), restMins: 2.0, main: true),
        barbell("Push Press",                 "Push Press",                        "", "6".x(3), restMins: 2.0, main: true),
        dumbbell1("Dumbbell Back Extension", "Back Extension",                    "", "20".x(2), restMins: 1.0),
        bodyweight("Band Seated Abduction",   "Band Seated Abduction",             "10-30", restMins: 1.0),
        bodyweight("Hanging Leg Raise",       "Hanging Leg Raise",                 "8-20", restMins: 1.0),
        singlePlates("Landmine 180's",        "Landmine 180's",                    "", "8-12", restMins: 1.0),
        
        // C
        barbell("Hip Thrust (isohold)",         "Hip Thrust (isohold)",         "", "1".x(3), restMins: 2.0, main: true),
        cable("D-handle Lat Pulldown",        "Lat Pulldown",                 "", "8".x(3), restMins: 1.0, main: true),
        bodyweight("Skater Squat",              "Skater Squat",                 "8".x(3), restMins: 1.0, main: true),
        bodyweight("Narrow-base Pushup",        "Pushup",                       "5-15".x(3), restMins: 2.0, main: true),
        barbell("Single-leg Romanian Deadlift", "Single Leg Romanian Deadlift", "", "8-12".x(3), restMins: 2.0, main: true),
        bodyweight("Side Lying Hip Raise",      "Side Lying Hip Raise",         "10-30", restMins: 1.0),
        bodyweight("Straight-leg Situp",        "Straight Leg Situp",           "10-20", restMins: 1.0),
        bodyweight("Side Bend",                 "Side Bend (45 degree)",        "10-20", restMins: 1.0),
        ] + strongCurvesWarmups
    
    let aExercises = ["Hip Thrust", "Seated Row", "Squat", "Bench Press", "Good Morning", "Band Standing Abduction", "Ab Wheel Rollout", "Dumbbell Side Bend"]
    let bExercises = ["Single Leg Hip Thrust", "Pullup", "Dumbbell Lunge", "Push Press", "Dumbbell Back Extension", "Band Seated Abduction", "Hanging Leg Raise", "Landmine 180's"]
    let cExercises = ["Hip Thrust (isohold)", "D-handle Lat Pulldown", "Skater Squat", "Narrow-base Pushup", "Single-leg Romanian Deadlift", "Side Lying Hip Raise", "Straight-leg Situp", "Side Bend"]
    
    let workouts = [
        Workout("A", aExercises, scheduled: true, optional: []),
        Workout("B", bExercises, scheduled: true, optional: []),
        Workout("C", cExercises, scheduled: true, optional: []),
        
        Workout("AC warmup", strongCurvesACWarmup, scheduled: false, optional: []),
        Workout("B warmup", strongCurvesBWarmup, scheduled: false, optional: []),
        ]
    
    let tags: [Program.Tags] = [.intermediate, .hypertrophy, .gym, .threeDays, .female, .ageUnder40, .age40s, .age50s]
    let description = """
This is the 3 days/week version of weeks 5-8 of the intermediate program from [Strong Curves: A Woman's Guide to Building a Better Butt and Body](https://www.amazon.com/Strong-Curves-Womans-Building-Better-ebook/dp/B00C4XI0QM/ref=sr_1_1?ie=UTF8&qid=1516764374&sr=8-1&keywords=strong+curves) by Bret Contreras. The program is as follows (Bret recommends warmups, and they are part of the program, but there are a lot so they aren't listed here):

**Workout A**
* Barbell Hip Thrust 3x3-8
* Seated Row 3x8
* Barbell Squat 3x5
* Bench Press 3x3-8
* Good Morning 3x8-12
* Band Standing Abduction 1x10-30 (per side)
* Ab Wheel Rollout from Knees 1x8-20
* Dumbbell Side Bend 1x10-20 (per side)

**Cardio**

**Workout B**
* Bodyweight Single-leg Hip Thrust (shoulder and foot elevated) 3x8-20
* Pullup 3x3-8
* Dumbbell Walking Lunge 3x10
* Push Press 3x6
* Dumbbell Back Extension 2x20
* Band Seated Abduction 1x10-30
* Hanging Leg Raise 1x8-20
* Landmine 180's 1x8-12 (per side)

**Cardio**

**Workout C**
* Barbell Hip Thrust (isohold) 3x30-60s
* D-handle Lat Pulldowns 3x8
* Skater Squat 3x8
* Narrow-base Pushup 3x5-15
* Barbell Single-leg Romanian Deadlift 3x8-12
* Side-lying Hip Raise 1x10-30
* Straight-leg Situp 1x10-20
* 45-degree Side Bend 1x10-20 (per side)

**Cardio**

**Rest**

**Notes**
\(notes)
"""
    return Program("Gluteal Goddess 5-8", workouts, exercises, tags, description, maxWorkouts: 3*4, nextProgram: "Gluteal Goddess 9-12")
}

// Weeks 9-12 for 3 days/week version of Gluteal Goddess.
func GlutealGoddess3() -> Program {
    let exercises: [Exercise] = [
        // A
        barbell("Hip Thrust (rest pause)", "Hip Thrust (rest pause)", "", "10".x(3), restMins: 2.0, main: true),
        bodyweight("Inverted Row",         "Inverted Row",            "6-12".x(3), restMins: 1.0, main: true),
        barbell("Zercher Squat",           "Zercher Squat",           "", "5-10".x(3), restMins: 2.0, main: true),
        bodyweight("Elevated Pushup",      "Pushup",                  "5-20".x(3), restMins: 1.0, main: true),
        barbell("Sumo Deadlift",           "Sumo Deadlift",           "", "6-12".x(3), restMins: 2.5),
        bodyweight("X-Band Walk",          "X-Band Walk",             "20", restMins: 1.0),
        dumbbell1("Swiss Ball Crunch",      "Exercise Ball Crunch",    "", "20", restMins: 2.0),
        bodyweight("Anti-Rotary Hold",     "Band Anti-Rotary Hold",   2, secs: 15),
        
        // B
        barbell("Hip Thrust (constant tension)",  "Hip Thrust (constant tension)",   "", "20-30".x(3), restMins: 2.0, main: true),
        bodyweight("Pullup",                      "Pullup",                          "1-3".x(3), restMins: 2.0, main: true),
        dumbbell2("Deficit Bulgarian Split Squat", "Dumbbell Single Leg Split Squat", "", "10".x(3), restMins: 2.0, main: true),
        barbell("Incline Press",                  "Incline Bench Press",             "", "6-10".x(3), restMins: 2.0, main: true),
        bodyweight("Gliding Leg Curl",            "Gliding Leg Curl",                "6-15".x(2), restMins: 1.0),
        cable("Cable Hip Rotation",             "Cable Hip Rotation",              "", "8-15", restMins: 1.0),
        bodyweight("Body Saw",                    "Body Saw",                        "8-15", restMins: 1.0),
        cable("Anti-Rotation Press",            "Half-kneeling Cable Anti-Rotation Press", "", "8-12", restMins: 1.0),
        
        // C
        barbell("Hip Thrust",                 "Hip Thrust",                      "", "5".x(3), restMins: 2.5, main: true),
        dumbbell2("Chest Supported Row",       "Dumbbell Incline Row",            "", "6-12".x(3), restMins: 2.0, main: true),
        dumbbell2("Dumbbell Step Up",          "Deep Step-ups",                   "", "8-15".x(3), restMins: 2.0, main: true),
        dumbbell1("One Arm OHP",               "Dumbbell One Arm Shoulder Press", "", "8-15".x(3), restMins: 2.0, main: true),
        bodyweight("Prisoner Single-leg Back Extension", "Back Extension",       "8-15".x(3), restMins: 1.0),
        bodyweight("Side Lying Hip Raise",    "Side Lying Hip Raise",            "10-30", restMins: 1.0),
        bodyweight("Hanging Leg Raise",       "Hanging Leg Raise",               "8-20", restMins: 1.0),
        singlePlates("Landmine 180's",        "Landmine 180's",                  "", "8-12", restMins: 1.0),
        ] + strongCurvesWarmups
    
    let aExercises = ["Hip Thrust (rest pause)", "Inverted Row", "Zercher Squat", "Elevated Pushup", "Sumo Deadlift", "X-Band Walk", "Swiss Ball Crunch", "Anti-Rotary Hold"]
    let bExercises = ["Hip Thrust (constant tension)", "Pullup", "Deficit Bulgarian Split Squat", "Incline Press", "Gliding Leg Curl", "Cable Hip Rotation", "Body Saw", "Anti-Rotation Press"]
    let cExercises = ["Hip Thrust", "Chest Supported Row", "Dumbbell Step Up", "One Arm OHP", "Prisoner Single-leg Back Extension", "Side Lying Hip Raise", "Hanging Leg Raise", "Landmine 180's"]
    
    let workouts = [
        Workout("A", aExercises, scheduled: true, optional: []),
        Workout("B", bExercises, scheduled: true, optional: []),
        Workout("C", cExercises, scheduled: true, optional: []),
        
        Workout("AC warmup", strongCurvesACWarmup, scheduled: false, optional: []),
        Workout("B warmup", strongCurvesBWarmup, scheduled: false, optional: []),
        ]
    
    let tags: [Program.Tags] = [.intermediate, .hypertrophy, .gym, .threeDays, .female, .ageUnder40, .age40s, .age50s]
    let description = """
This is the 3 days/week version of weeks 9-12 of the intermediate program from [Strong Curves: A Woman's Guide to Building a Better Butt and Body](https://www.amazon.com/Strong-Curves-Womans-Building-Better-ebook/dp/B00C4XI0QM/ref=sr_1_1?ie=UTF8&qid=1516764374&sr=8-1&keywords=strong+curves) by Bret Contreras. The program is as follows (Bret recommends warmups, and they are part of the program, but there are a lot so they aren't listed here):

**Workout A**
* Barbell Hip Thrust (rest pause) 3x10
* Bodyweight Inverted Row 3x6-12
* Barbell Zercher Squat 3x5-10
* Feet Elevated Pushup 3x5-20
* Barbell Sumo Deadlift 3x6-12
* X-band Walk 1x20 (per side)
* Dumbbell Swiss Ball Crunch 1x20
* Band Rotary Hold 2x15s (per side)

**Cardio**

**Workout B**
* Barbell Hip Thrust (constant tension) 3x20-30
* Weighed Pullup 3x1-3
* Deficit Dumbbell Bulgarian Split Squat 3x10 (per side)
* Barbell Incline Press 3x6-10
* Gliding Leg Curl 2x6-15
* Cable Hip Rotation 1x8-15
* Body Saw 1x8-15
* Half-kneeling Cable Anti-Rotation Press 1x8-12 (per side)

**Cardio**

**Workout C**
* Barbell American Hip Thrust 3x5
* Dumbbell Chest Supported Row 3x6-12
* Dumbbell High Step-up 3x8-15 (per side)
* Dumbbell Single-arm OHP 3x8-15 (per side)
* Prisoner Single Leg Back Extension 3x8-15 (per side)
* Side Lying Hip Raise 1x10-30 (per side)
* Hanging Leg Raise 1x8-20
* Landmine 180's 1x8-12 (per side)

**Cardio**

**Rest**

**Notes**
\(notes)
* After finishing the four weeks Brett recommends that you do a deload week, e.g. by reducing weights 20-50%.
"""
    return Program("Gluteal Goddess 9-12", workouts, exercises, tags, description)
}


