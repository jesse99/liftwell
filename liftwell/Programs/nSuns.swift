//  Created by Jesse Jones on 12/22/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation

fileprivate let programSuffix = """
Each day has a main lift, a secondary lift, and customizable assistence lifts. The main lift works up to a 1+ AMRAP set followed by five or six backoff sets. The secondary lift is done at less intensity. Assistence work is typically three sets at 8-12 reps. For the main lifts weights should be increased based on how well you did on the 1+ set:
* If you did 0-1 reps then don't increase the weight.
* If you did 2-3 reps then increase the weight by one step (n-Suns recommends five pounds).
* If you did 4-5 reps then increase the weight by one or two steps.
* If you did 6+ reps then increase the weight by two or three steps.
"""

fileprivate let notes = """
* When starting the program you need to find your Training Max for each of the main lifts. The program will do this for you: when you start an exercise it will guide you to find the five rep max for that exercise, then it will estimate your one rep max, and use 90% of the 1RM for your training max.
* This program uses a lot of sets at a relatively low intensity so be conservative with your initial weights.
* Don't do the AMRAP sets to failure: try and leave one or two reps in the tank, e.g. stop if the bar speed slows significantly.
* You can do up to four assistence lifts during a workout.
* The assistence lifts should be tailored to address your weak areas.
* Wendler recommends a 10% deload for a lift if you think you've stalled on it.
"""

func nSuns5() -> Program {
    let advance: [Int] = [0, 0, 1, 1, 2, 2, 3]
    
    let assistence  = "8-12".x(3)
    
    let exercises: [Exercise] = [
        barbell("Light Bench",   "Bench Press",    "", "8@65% 6@75% R 4@85% R 4@85% R 4@85% R", "5@80% R 6@75% R 7@70% R 8+@65%", percent: 1.0, other: "Bench", restMins: 2.5, main: false),
        barbell("Light OHP",     "Overhead Press", "", "6@50% 5@60% R 3@70% R 5@70% R 7@70% R 4@70% R 6@70% R 8@70%", percent: 1.0, other: "OHP", restMins: 2.5, main: false),

        barbell("Squat",         "Low bar Squat", "", "5@75% R 3@85% R 1+@95% R", "3@90% R 3@85% R 3@80% R 5@75% R 5@70% R 5+@65%", advanceBy: advance, restMins: 3.0, trainingMaxPercent: 0.9, main: true),
        barbell("Sumo Deadlift", "Sumo Deadlift", "", "5@50% 5@60% 3@70% R 5@70% R 7@70% R 4@70% R 6@70% R 8@70%", percent: 1.0, other: "Deadlift", restMins: 3.0, bumpers: defaultBumpers(), main: false),

        barbell("OHP",           "Overhead Press", "", "5@75% R 3@85% R 1+@95% R", "3@90% R 3@85% R 3@80% R 5@75% R 5@70% R 5+@65%", advanceBy: advance, restMins: 2.5, trainingMaxPercent: 0.9, main: true),
        barbell("Incline Bench", "Incline Bench Press", "", "6@40% 5@50% R 3@60% R 5@60% R 7@60% R 4@60% R 6@60% R 8@60%", percent: 1.0, other: "Bench", restMins: 2.5, main: false),

        barbell("Deadlift",      "Deadlift",       "", "5@75% R 3@85% R 1+@95% R", "3@90% R 3@85% R 3@80% R 3@75% R 3@70% R 3+@65%", advanceBy: advance, restMins: 3.0, bumpers: defaultBumpers(), trainingMaxPercent: 0.9, main: true),
        barbell("Front Squat",   "Front Squat",    "", "5@35% 5@45% R 3@55% R 5@55% R 7@55% R 4@55% R 6@55% R 8@55%", percent: 1.0, other: "Squat", restMins: 3.0, main: false),

        barbell("Bench",         "Bench Press",    "", "5@75% R 3@85% R 1+@95% R", "3@90% R 5@85% R 3@80% R 5@75% R 3@70% R 5+@65%", advanceBy: advance, restMins: 2.5, trainingMaxPercent: 0.9, main: true),
        barbell("CG Bench",      "Close-Grip Bench Press", "", "6@40% 5@50% R 3@60% R 5@60% R 7@60% R 4@60% R 6@60% R 8@60%", percent: 1.0, other: "Bench", restMins: 2.5, main: false),

        
        
        
        // Push
        bodyweight("Dips",          "Dips",                        4, by: 12, restMins: 1.5),
        dumbbell2("Dumbbell Bench", "Dumbbell Bench Press",    "", assistence, restMins: 1.5),
        dumbbell2("Dumbbell OHP",   "Dumbbell Shoulder Press", "", assistence, restMins: 1.5),
        bodyweight("Pushup",        "Pushup",                      4, by: 12, restMins: 1.5),
        cable("Triceps Pushdown",   "Triceps Pushdown (rope)", "", assistence, restMins: 1.5),
        
        // Pull
        bodyweight("Band Pull Apart", "Band Pull Apart",      4, by: 12),
        bodyweight("Chinups",         "Chinup",               numSets: 4, goalReps: 50, restMins: 2.0, restAtEnd: false),
        cable("Face Pull",            "Face Pull", "",        assistence, restMins: 1.5),
        bodyweight("Inverted Row",    "Inverted Row",         4, by: 12, restMins: 1.5),
        cable("Lat Pulldown",         "Lat Pulldown", "",     assistence, restMins: 1.5),
        barbell("Preacher Curl",      "Preacher Curl", "",    assistence, restMins: 1.5),
        cable("Seated Cable Row",     "Seated Cable Row", "", assistence, restMins: 1.5),
        
        // Single Leg/Core
        bodyweight("Ab Wheel Rollout",  "Ab Wheel Rollout",                    4, by: 12, restMins: 1.5),
        dumbbell1("Back Extensions",    "Back Extensions",                 "", assistence, restMins: 1.5),
        cable("Cable Crunch",           "Cable Crunch", "",                    assistence, restMins: 1.5),
        dumbbell2("Dumbbell Lunge",     "Dumbbell Lunge", "",                  assistence, restMins: 1.5),
        bodyweight("Kettlebell Snatch", "One-Arm Kettlebell Snatch",           4, by: 12, restMins: 1.5),
        bodyweight("Kettlebell Swing",  "Kettlebell Two Arm Swing",            4, by: 12, restMins: 1.5),
        bodyweight("Reverse Hyper",     "Reverse Hyperextension",              4, by: 12, restMins: 1.5),
        dumbbell2("Spell Caster",       "Spell Caster", "",                    assistence, restMins: 1.5),
        dumbbell2("Split Squat",        "Dumbbell Single Leg Split Squat", "", assistence, restMins: 1.5),
        dumbbell2("Step-ups",           "Step-ups",                        "", assistence, restMins: 1.5),
        ]
    
    let workouts = [
        Workout("Light", ["Light Bench", "Light OHP"], scheduled: true, optional: []),
        Workout("Squat", ["Squat", "Sumo Deadlift"], scheduled: true, optional: []),
        Workout("OHP", ["OHP", "Incline Bench"], scheduled: true, optional: []),
        Workout("Deadlift", ["Deadlift", "Front Squat"], scheduled: true, optional: []),
        Workout("Bench", ["Bench", "CG Bench"], scheduled: true, optional: [])]
    
    let tags: [Program.Tags] = [.intermediate, .strength, .barbell, .unisex, .fiveDays, .ageUnder40, .age40s]
    
    let description = """
This is a popular [program](http://archive.is/2017.01.27-015129/https://www.reddit.com/r/Fitness/comments/5icyza/2_suns531lp_tdee_calculator_and_other_items_all/) from [reddit](https://www.reddit.com/r/nSuns/) with weekly progression. \(programSuffix)

This is the five days a week version of the program (there is also a four day a week version):
**Light**
* Light Bench
* Light OHP
* Assistence (chest, arms, back)

**Squat**
* Squat
* Sumo Deadlift
* Assistence (legs, abs)

**OHP**
* OHP
* Incline Bench
* Assistence (shoulders, chest)

**Deadlift**
* Deadlift
* Front Squat
* Assistence (back, abs)

**Bench**
* Bench Press
* Close-grip Bench
* Assistence (arms, other)

The percentages and reps vary from exercise to exercise and from day to day but are similar to:
work sets: 5@75% 3@85% 1+@95%
backoff: 3@90% 3@85% 3@80% 3@75% 5@75% 5@70% 5+@65%

There are a lot of options for assistence work (you can switch them up using the Options button in the Workout screen).

**Notes**
\(notes)
"""
    return Program("nSuns 531LP/5", workouts, exercises, tags, description)
}

