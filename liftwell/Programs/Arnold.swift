//  Created by Jesse Vorisek on 7/14/19.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation

func Arnold1() -> Program {
    let exercises = [
        // Chest and Back
        barbell("Bench Press",         "Bench Press",    "", "10".x(4), restMins: 2.0, main: true),
        barbell("Incline Bench Press", "Incline Bench Press",    "", "10".x(4), restMins: 2.0, main: true),
        dumbbell1("Dumbbell Pullovers",  "Dumbbell Pullovers",    "", "10".x(4), restMins: 2.0, main: true),
        bodyweight("Chinups",          "Chinup",      numSets: 4, startReps: 5, goalReps: 10, restMins: 2.0, main: true),
        barbell("Bent Over Row",       "Pendlay Row",    "", "10".x(4), restMins: 2.0, main: true),
        barbell("Deadlift",            "Deadlift",    "", "10".x(4), restMins: 2.0, main: true),
        bodyweight("Crunches",         "Situp",      numSets: 5, startReps: 10, goalReps: 25, restMins: 2.0, main: false),

        // Shoulders and Arms
//        * Barbell Clean and Press 3-4x10
//        * Dumbbell Lateral Raise 3-4x10
//        * Upright Row 3-4x10
//        * Military Press 3-4x10
//        * Standing Barbell Curl 3-4x10
//        * Seated Dumbbell Curl 3-4x10
//        * Close Grip Bench Press 3-4x10
//        * Standing Barbell Tricep Extension 3-4x10
//        * Wrist Curls 3-4x10
//        * Reverse Wrist Curls 3-4x10
//        * Reverse Crunch 5x25
        barbell("Barbell Clean and Press",         "Clean and Press",    "", "10".x(4), restMins: 2.0, main: true),
        dumbbell2("Dumbbell Lateral Raise",  "Side Lateral Raise",    "", "10".x(4), restMins: 2.0, main: true),
        barbell("Upright Row",         "Upright Row",    "", "10".x(4), restMins: 2.0, main: true),
        barbell("Military Press",         "Military Press",    "", "10".x(4), restMins: 2.0, main: true),
        barbell("Standing Barbell Curl",         "Barbell Curl",    "", "10".x(4), restMins: 2.0, main: true),
        dumbbell2("Seated Dumbbell Curl",  "Incline Dumbbell Curl",    "", "10".x(4), restMins: 2.0, main: true),
        barbell("Close Grip Bench Press",         "Close-Grip Bench Press",    "", "10".x(4), restMins: 2.0, main: true),
        barbell("Standing Barbell Tricep Extension",         "French Press",    "", "10".x(4), restMins: 2.0, main: true),
        dumbbell1("Wrist Curls",  "Wrist Curls",    "", "10".x(4), restMins: 2.0, main: true),
        dumbbell2("Reverse Wrist Curls",  "Reverse Wrist Curls",    "", "10".x(4), restMins: 2.0, main: true),
        bodyweight("Reverse Crunch",         "Reverse Crunch",      numSets: 5, startReps: 10, goalReps: 25, restMins: 2.0, main: false),

        // Legs and Lower Back (days 3 & 6)
//        * Squat 3-4x10
//        * Lunge 3-4x10
//        * Leg Curl 3-4x10
//        * Stiff Leg Deadlift 3-4x10
//        * Good Mornings 3-4x10
//        * Standing Calf Raise 3-4x10
//        * Crunches 5x25



        ]
    
    let workouts = [
        Workout("Chest and Back 1", ["Power Row", "Pullups", "Rack Chins 1", "Power DB Bench", "Dips", "Seated DB OHP 1", "EZ Curls", "Skullcrushers 1"], scheduled: true, optional: []),
        
        Workout("Shoulders and Arms 2", ["Power Squat", "Hack Squat", "Leg Extension 1", "Stiff-legged Deadlift", "Leg Curls 1", "Standing Calf Raises", "Seated Calf Raise 1"], scheduled: true, optional: []),
        
        Workout("Legs and Lower Back 3", ["Speed Row", "Rack Chins 2", "Cable Row", "Kroc Row", "CG Lat Pulldown", "Seated DB OHP 2", "Upright Row", "Lateral Raise"], scheduled: true),
        
        Workout("Chest and Back 4", ["Speed Squat", "Hack Squat", "Leg Press", "Leg Extension 2", "Romanian Deadlift", "Leg Curls 2", "Seated Leg Curl", "Donkey Calf Raises", "Seated Calf Raise 2"], scheduled: true),
        
        Workout("Shoulders and Arms 5", ["Speed DB Bench", "Incline DB Press", "Hammer Press", "Incline Cable Flyes", "Preacher Curls", "Concentration Curls", "Spider Curls", "Skullcrushers 2", "Cable Pressdown", "Cable Kickbacks"], scheduled: true),
    
        Workout("Legs and Lower Back 6", ["Speed DB Bench", "Incline DB Press", "Hammer Press", "Incline Cable Flyes", "Preacher Curls", "Concentration Curls", "Spider Curls", "Skullcrushers 2", "Cable Pressdown", "Cable Kickbacks"], scheduled: true)]
    
    let tags: [Program.Tags] = [.advanced, .hypertrophy, .barbell, .sixDays, .ageUnder40] + anySex
    
    let description = """
High volume and frquency [workout](https://www.muscleandstrength.com/workouts/arnold-schwarzenegger-volume-workout-routines) from the New Encyclopedia of Modern Bodybuilding by Arnold Schwarzenegger and Bill Dobbins. This is a six day a week program and this version trains each body part twice a week:

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

