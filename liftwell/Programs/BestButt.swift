//  Created by Jesse Jones on 11/14/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation

fileprivate let notes = """
* This is a three day a week program designed to be performed at home.
* You'll need a bit of equipment for this program: an exercise mat, a swiss ball, valslides (or a towel if you have smooth floors). a chin-up bar, and a PVC pipe/dowel/broomstick.
* Don't be too aggressive about upping the rep ranges: the first and last reps you do should feel the same.
* When performing a single leg/arm exercise begin with the weaker limb and then do the same number of reps with the stronger limb.
* To speed up the workouts you can superset the exercises: do a set of a lower body exercise, a set of an upper body, rest for 60-120s, and repeat until you've finished all the sets for both exercises.
* Once you've done all the indicated workouts the app will prompt you to move onto the next program.
"""

func BestButt14() -> Program {
    let exercises: [Exercise] = [
        // A
        bodyweight("Glute Bridge",          "Glute Bridge",          "10-20 R 10-20 R 10-20", restMins: 1.0),
        bodyweight("Inverted Row",          "Inverted Row",          "8-12 R 8-12 R 8-12", restMins: 1.0),
        bodyweight("Box Squat",             "Body-weight Box Squat", "10-20 R 10-20 R 10-20", restMins: 1.5),
        bodyweight("Incline Pushup",        "Incline Pushup",        "8-12 R 8-12 R 8-12", restMins: 1.0),
        bodyweight("Hip Hinge with Dowel",  "Hip Hinge with Dowel",  "10-20 R 10-20 R 10-20", restMins: 1.0),
        bodyweight("Side Lying Abduction",  "Side Lying Abduction",  "10-30", restMins: 1.0),
        bodyweight("Front Plank",           "Front Plank",           1, secs: 30, targetSecs: 120),
        bodyweight("Side Plank from Knees", "Side Plank",            2, secs: 20, targetSecs: 60),
        
        // B
        bodyweight("Elevated Single-leg Glute Bridge", "Single Leg Glute Bridge",      "10-20 R 10-20 R 10-20", restMins: 1.0),
        bodyweight("Negative Chinup",                  "Chinup",                       "1-3 R 1-3 R 1-3", restMins: 1.5),
        bodyweight("Step-ups",                         "Deep Step-ups",                "10-20 R 10-20 R 10-20", restMins: 1.0),
        bodyweight("Pushup from Knees",                "Pushup",                       "5-15 R 5-15 R 5-15", restMins: 1.0),
        bodyweight("Swiss Ball Back Extension",        "Exercise Ball Back Extension", "10-20 R 10-20 R 10-20", restMins: 1.0),
        bodyweight("Side Plank from Knees",            "Side Plank",                   2, secs: 20, targetSecs: 60),
        bodyweight("Situp",                            "Situp",                        "20-30", restMins: 1.0),
        bodyweight("Oblique Crunches",                 "Oblique Crunches",             "20-30", restMins: 1.0),
        
        // C
        bodyweight("Glute March",            "Glute March",               3, secs: 30, targetSecs: 60),
        bodyweight("Inverted Row",           "Inverted Row",              "8-12 R 8-12 R 8-12", restMins: 1.0),
        bodyweight("Box Squat",              "Body-weight Box Squat",     "10-20 R 10-20 R 10-20", restMins: 1.5),
        bodyweight("Negative Pushup",        "Pushup",                    "3-5 R 3-5 R 3-5", restMins: 1.0),
        bodyweight("Hip Hinge with Dowel",   "Hip Hinge with Dowel",      "10-20 R 10-20 R 10-20", restMins: 1.0),
        bodyweight("Side Lying Clam",        "Clam",                      "20-30", restMins: 1.0),
        bodyweight("Straight Leg Situp",     "Straight Leg Situp",        "15-30", restMins: 1.0),
        bodyweight("Swiss Ball Side Crunch", "Exercise Ball Side Crunch", "15-30", restMins: 1.0)]
    
    let aExercises = ["Glute Bridge", "Inverted Row", "Box Squat", "Incline Pushup", "Hip Hinge with Dowel", "Side Lying Abduction", "Front Plank", "Side Plank from Knees"]
    let bExercises = ["Elevated Single-leg Glute Bridge", "Negative Chinup", "Step-ups", "Pushup from Knees", "Swiss Ball Back Extension", "Side Plank from Knees", "Situp", "Oblique Crunches"]
    let cExercises = ["Glute March", "Inverted Row", "Box Squat", "Negative Pushup", "Hip Hinge with Dowel", "Side Lying Clam", "Straight Leg Situp", "Swiss Ball Side Crunch"]
    
    let workouts = [
        Workout("A", aExercises, scheduled: true, optional: []),
        Workout("B", bExercises, scheduled: true, optional: []),
        Workout("C", cExercises, scheduled: true, optional: [])]
    
    let tags: [Program.Tags] = [.beginner, .hypertrophy, .minimal, .threeDays, .female, .ageUnder40, .age40s, .age50s]
    let description = """
This is the weeks 1-4 of the at home beginner program from [Strong Curves: A Woman's Guide to Building a Better Butt and Body](https://www.amazon.com/Strong-Curves-Womans-Building-Better-ebook/dp/B00C4XI0QM/ref=sr_1_1?ie=UTF8&qid=1516764374&sr=8-1&keywords=strong+curves). The program is as follows:

**Workout A**
* Glute Bridge 3x10-20
* Inverted Row 3x8-12
* Box Squat 3x10-20
* Incline Pushup 3x8-12
* Hip Hinge with Dowel 3x10-20
* Side Lying Abduction 1x10-30 (per side)
* Front Plank 1x30-120s
* Side Plank from Knees 2x20-60s (per side)

**Cardio**

**Workout B**
* Foot Elevated Single-leg Glute Bridge 3x10-20 (per side)
* Negative Chinup 3x1-3
* Step-up 3x10-20 (per side)
* Pushup from Knees 3x5-15
* Swiss Ball Back Extension 3x10-20
* Side Plank from Knees 2x20-60s (per side)
* Crunch 1x20-30
* Side Crunch 1x20-30 (per side)

**Cardio**

**Workout C**
* Glute March 3x30-60s (alternating legs)
* Inverted Row 3x8-12
* Box Squat 3x10-20
* Negative Pushup 3x3-5
* Hip Hinge with Dowel 3x10-20
* Side Lying Clam 1x20-30 (per side)
* Straight-leg Situp 1x15-30
* Swiss Ball Side Crunch 1x15-30 (per side)

**Cardio**

**Rest**


**Notes**
    
\(notes)
"""
    return Program("Best Butt 1-4", workouts, exercises, tags, description, maxWorkouts: 3*4, nextProgram: "Best Butt 5-8")
}

func BestButt58() -> Program {
    let exercises: [Exercise] = [
        // A
        bodyweight("Hip Thrust",           "Body-weight Hip Thrust",          "10-30 R 10-30 R 10-30", restMins: 1.0),
        bodyweight("Inverted Row",         "Inverted Row",                    "8-12 R 8-12 R 8-12", restMins: 1.0),
        bodyweight("Squat",                "Body-weight Squat",               "10-30 R 10-30 R 10-30", restMins: 1.5),
        bodyweight("Pushup",               "Pushup",                          "1 R 1 R 1", restMins: 1.0),
        bodyweight("Single Leg Deadlift",  "Body-weight Single Leg Deadlift", "10-20 R 10-20 R 10-20", restMins: 1.0),
        bodyweight("Side Lying Abduction", "Side Lying Abduction",            "10-30", restMins: 1.0),
        bodyweight("RKC Plank",            "RKC Plank",                       1, secs: 20, targetSecs: 60),
        bodyweight("Side Plank",           "Side Plank",                      2, secs: 20, targetSecs: 60),
        
        // B
        bodyweight("Single-leg Glute Bridge", "Single Leg Glute Bridge",   "10-20 R 10-20 R 10-20", restMins: 1.0),
        bodyweight("Chinup",                  "Chinup",                    "1 R 1 R 1", restMins: 1.5),
        bodyweight("Walking Lunge",           "Body-weight Walking Lunge", "10-20 R 10-20 R 10-20", restMins: 1.0),
        bodyweight("Pushup from Knees",       "Pushup",                    "6-20 R 6-20 R 6-20", restMins: 1.5),
        bodyweight("Reverse Hyperextension",  "Reverse Hyperextension",    "10-30 R 10-30 R 10-30", restMins: 1.0),
        bodyweight("Side Lying Clam",         "Clam",                      "10-30", restMins: 1.0),
        bodyweight("Swiss Ball Crunch",       "Exercise Ball Crunch",      "10-30", restMins: 1.0),
        bodyweight("Swiss Ball Side Crunch",  "Exercise Ball Side Crunch", "10-30", restMins: 1.0),
        
        // C
        bodyweight("Hip Thrust",             "Body-weight Hip Thrust",    "10-30 R 10-30 R 10-30", restMins: 1.0),
        bodyweight("Inverted Row",           "Inverted Row",              "8-12 R 8-12 R 8-12", restMins: 1.0),
        bodyweight("High Step-ups",          "Deep Step-ups",             "10-20 R 10-20 R 10-20", restMins: 1.0),
        bodyweight("Incline Pushup",         "Incline Pushup",            "8-12 R 8-12 R 8-12", restMins: 1.5),
        bodyweight("Back Extension",         "Back Extension",            "20-30 R 20-30 R 20-30", restMins: 1.0),
        bodyweight("Side Lying Hip Raise",   "Side Lying Hip Raise",      "10-20", restMins: 1.0),
        bodyweight("Feet Elevated Plank",    "Front Plank",               1, secs: 60, targetSecs: 120),
        bodyweight("Swiss Ball Side Crunch", "Exercise Ball Side Crunch", "10-20", restMins: 1.0)]
    
    let aExercises = ["Hip Thrust", "Inverted Row", "Squat", "Pushup", "Single Leg Deadlift", "Side Lying Abduction", "RKC Plank", "Side Plank"]
    let bExercises = ["Single-leg Glute Bridge", "Chinup", "Walking Lunge", "Pushup from Knees", "Reverse Hyperextension", "Side Lying Clam", "Swiss Ball Crunch", "Swiss Ball Side Crunch"]
    let cExercises = ["Hip Thrust", "Inverted Row", "High Step-ups", "Incline Pushup", "Back Extension", "Side Lying Hip Raise", "Feet Elevated Plank",  "Swiss Ball Side Crunch"]
    
    let workouts = [
        Workout("A", aExercises, scheduled: true, optional: []),
        Workout("B", bExercises, scheduled: true, optional: []),
        Workout("C", cExercises, scheduled: true, optional: [])]
    
    let tags: [Program.Tags] = [.beginner, .hypertrophy, .minimal, .threeDays, .female, .ageUnder40, .age40s, .age50s]
    let description = """
This is weeks 5-8 of the at home beginner program from [Strong Curves: A Woman's Guide to Building a Better Butt and Body](https://www.amazon.com/Strong-Curves-Womans-Building-Better-ebook/dp/B00C4XI0QM/ref=sr_1_1?ie=UTF8&qid=1516764374&sr=8-1&keywords=strong+curves). The program is as follows::

**Workout A**
* Hip Thrust 3x10-30
* Inverted Row 3x8-12
* Full Squat 3x10-30
* Strict Pushup 3x1
* Single-leg Romanian Deadlift 3x10-20 (per side)
* Side Lying Abduction 1x10-30 (per side)
* RKC Plank 1x20-60s
* Side Plank 1x20-60s (per side)

**Cardio**

**Workout B**
* Single-leg Glute Bridge 3x10-20
* Chinup 3x1
* Walking Lunge 3x10-20
* Pushup from knees 3x6-20
* Reverse Hyperextension 3x10-30
* Side Lying Clam 1x10-30 (per side)
* Swiss Ball Crunch 1x10-30
* Swiss Ball Side Crunch 1x10-30 (per side)

**Cardio**

**Workout C**
* Hip Thrust 3x10-30
* Inverted Row 3x8-12
* High Step-up 3x10-20 (per side)
* Torso Elevated Pushup 3x8-12
* Back Extension 3x20-30
* Side-lying Hip Raise 1x10-20
* Feet Elevated Plank 1x60-120s
* Swiss Ball Side Crunch 1x10-20 (per side)

**Cardio**

**Rest**

**Notes**

\(notes)
"""
    return Program("Best Butt 5-8", workouts, exercises, tags, description, maxWorkouts: 3*4, nextProgram: "Best Butt 9-12")
}

func BestButt912() -> Program {
    let exercises: [Exercise] = [
        // A
        bodyweight("Elevated Single-leg Hip Thrust", "Body-weight Single Leg Hip Thrust",   "8-20 R 8-20 R 8-20", restMins: 1.0),
        bodyweight("Chinup",                         "Chinup",                              "3-10 R 3-10 R 3-10", restMins: 1.5),
        bodyweight("Step Up + Reverse Lunge",        "Body-weight Step Up + Reverse Lunge", "3-15 R 3-15 R 3-15", restMins: 1.5),
        bodyweight("Pushup",                         "Pushup",                              "5-10 R 5-10 R 5-10", restMins: 1.5),
        bodyweight("Swiss Ball Back Extension",      "Exercise Ball Back Extension",        "8-20 R 8-20 R 8-20", restMins: 1.0),
        bodyweight("Traverse Abduction",             "Quadruped Double Traverse Abduction", "6", restMins: 1.0),
        bodyweight("Prisoner Swiss Ball Crunch",     "Exercise Ball Crunch",                "10-30", restMins: 1.0),
        bodyweight("Side Plank with Abduction",      "Side Plank",                          2, secs: 20, targetSecs: 60),
        
        // B
        bodyweight("Elevated Hip Thrust",       "Body-weight Hip Thrust",            "6-20 R 6-20 R 6-20", restMins: 1.0),
        bodyweight("Elevated Inverted Row",     "Inverted Row",                      "6-12 R 6-12 R 6-12", restMins: 1.0),
        bodyweight("Bulgarian Split Squat",     "Body-weight Bulgarian Split Squat", "5-30 R 5-30 R 5-30", restMins: 1.0),
        bodyweight("Elevated Pike Pushup",      "Pike Pushup",                       "6-20 R 6-20 R 6-20", restMins: 1.0),
        bodyweight("Sliding Leg Curl",          "Sliding Leg Curl",                  "10-20 R 10-20", restMins: 1.0),
        bodyweight("Standing Double Abduction", "Standing Double Abduction",         "6", restMins: 1.0),
        bodyweight("RKC Plank",                 "RKC Plank",                         1, secs: 30, targetSecs: 60),
        bodyweight("Elevated Side Plank",       "Side Plank",                        2, secs: 20, targetSecs: 60),
        
        // C
        bodyweight("Elevated Single-leg Hip Thrust",     "Body-weight Hip Thrust", "5-15 R 5-15 R 5-15", restMins: 1.5),
        bodyweight("Pullup",                             "Pullup",                 "3-10 R 3-10 R 3-10", restMins: 1.5),
        bodyweight("High Step-ups",                      "Deep Step-ups",          "3-15 R 3-15 R 3-15", restMins: 1.0),
        bodyweight("Narrow-base Pushup",                 "Pushup",                 "3-8 R 3-8 R 3-8", restMins: 1.5),
        bodyweight("Russian Leg Curls",                  "Russian Leg Curl",       "3-5 R 3-5 R 3-5", restMins: 1.0),
        bodyweight("Side Lying Hip Raise",               "Side Lying Hip Raise",   "10-20", restMins: 1.0),
        bodyweight("Body Saw",                           "Body Saw",               "10-15", restMins: 1.0),
        bodyweight("Elevated Side Plank with Abduction", "Side Plank",             2, secs: 20, targetSecs: 60)]
    
    let aExercises = ["Elevated Single-leg Hip Thrust", "Chinup", "Step Up + Reverse Lunge", "Pushup", "Swiss Ball Back Extension", "Traverse Abduction", "Prisoner Swiss Ball Crunch", "Side Plank with Abduction"]
    let bExercises = ["Elevated Hip Thrust", "Elevated Inverted Row", "Bulgarian Split Squat", "Elevated Pike Pushup", "Sliding Leg Curl", "Standing Double Abduction", "RKC Plank", "Elevated Side Plank"]
    let cExercises = ["Elevated Single-leg Hip Thrust", "Pullup", "High Step-ups", "Narrow-base Pushup", "Russian Leg Curls", "Side Lying Hip Raise", "Body Saw", "Elevated Side Plank with Abduction"]
    
    let workouts = [
        Workout("A", aExercises, scheduled: true, optional: []),
        Workout("B", bExercises, scheduled: true, optional: []),
        Workout("C", cExercises, scheduled: true, optional: [])]
    
    let tags: [Program.Tags] = [.beginner, .hypertrophy, .minimal, .threeDays, .female, .ageUnder40, .age40s, .age50s]
    let description = """
This is weeks 9-12 of the at home beginner program from [Strong Curves: A Woman's Guide to Building a Better Butt and Body](https://www.amazon.com/Strong-Curves-Womans-Building-Better-ebook/dp/B00C4XI0QM/ref=sr_1_1?ie=UTF8&qid=1516764374&sr=8-1&keywords=strong+curves). The program is as follows:

**Workout A**
* Shoulder Elevated Single-leg Hip Thrust 3x8-20 (per side)
* Chinup 3x3-10
* Step-up + Reverse Lunge 3x10-15 (per side)
* Pushup 3x5-10
* Swiss Ball Back Extension 3x8-20 (per side)
* Quadreped Double Traverse Abduction 1x6
* Prisoner Swiss Ball Crunch 1x10-30
* Side Plank with Abduction 1x20-60s (per side)

**Cardio**

**Workout B**
* Shoulder/foot Elevated Single-leg Hip Thrust 3x6-20 (per side)
* Feet Elevated Inverted Row 3x6-12
* Bulgarian Split Squat 3x5-30 (per side)
* Feet Elevated Pike Pushup 3x6-20
* Sliding Leg Curl 2x10-20
* Standing Double Abduction 1x6
* RKC Plank 1x30-60s
* Feet Elevated Side Plank 1x20-60s (per side)

**Cardio**

**Workout C**
* Shoulder Elevated Single-leg Hip Thrust (paused) 3x5-15 (per side)
* Pullup 3x3-10
* High Step-up 3x10-15 (per side)
* Narrow-base Pushup 3x3-8
* Russian Leg Curls 3x3-5
* Side Lying Hip Raise 1x10-20 (per side)
* Body Saw 1x10-15
* Feet Elevated Side Plank with Abduction 1x20-60s (per side)

**Cardio**

**Rest**


**Notes**

\(notes)
* After finishing the four weeks Brett recommends that you do a deload week, e.g. by reducing weights 20-50%.
"""
    return Program("Best Butt 9-12", workouts, exercises, tags, description)
}

