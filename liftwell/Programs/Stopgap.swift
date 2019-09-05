//  Created by Jesse Jones on 12/31/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation

func Stopgap() -> Program {
    let warmup = "5@50% 3@75%"
    
    let sets = "5-10".x(3)
    
    let exercises = [
        // A
        dumbbell2("Split Squat",       "Dumbbell Single Leg Split Squat", warmup, sets, restMins: 2.0, main: true),
        dumbbell2("Lunge",             "Dumbbell Lunge",                  warmup, sets, restMins: 2.0, main: true),
        dumbbell2("Bench Press",       "Dumbbell Bench Press",            warmup, sets, restMins: 2.0, main: true),
        dumbbell2("Floor Press",       "Dumbbell Floor Press",            warmup, sets, restMins: 2.0, main: true),
        dumbbell2("Romanian Deadlift", "Dumbbell Romanian Deadlift",      warmup, sets, restMins: 2.0, main: true),
        bodyweight("Dips",             "Dips",                            numSets: 3, startReps: 3, goalReps: 36, restMins: 2.0),
        bodyweight("Plank",            "Front Plank",                     1, secs: 10, targetSecs: 180),

        // B
        dumbbell2("Seated OHP",        "Dumbbell Seated Shoulder Press", warmup, sets, restMins: 2.0, main: true),
        dumbbell2("Z Press",           "Z Press",                        warmup, sets, restMins: 2.0, main: true),
        dumbbell2("Row",               "Bent Over Dumbbell Row",         "", sets, restMins: 2.0),
        bodyweight("Chinups",          "Chinup",                         numSets: 3, startReps: 3, goalReps: 36, restMins: 2.0)]
    
    let workouts = [
        Workout("A", ["Split Squat", "Lunge", "Bench Press", "Floor Press", "Deadlift", "Dips", "Plank"], scheduled: true, optional: ["Lunge", "Floor Press", "Dips"]),
        Workout("B", ["Split Squat", "Lunge", "Seated OHP", "Z Press", "Row", "Chinups", "Plank"], scheduled: true, optional: ["Lunge", "Z Press", "Chinups"])]
    
    let tags: [Program.Tags] = [.beginner, .strength, .dumbbell, .unisex, .threeDays] + anyAge
    
    let description = """
This is a [program](https://old.reddit.com/r/Fitness/comments/zc0uy/a_beginner_dumbbell_program_the_dumbbell_stopgap/) for people who lack access to barbells. It's three days a week where workouts alternate between the A and B days:

**A**
* Bulgarian Split Squat 3x5-10
* Bench Press 3x5-10
* Straight-legged Deadlift 3x5-10
* Plank 3 sets

**B**
* Bulgarian Split Squat 3x5-10
* Seated Overhead Press 3x5-10
* Bent over Row 3x5-10
* Plank 3 sets

**Notes**
* If your lightest dumbbell is too heavy you can begin with empty hands.
* If you stall on a lift three times in a row lower the weight by two steps.
* There are some optional exercises you can swap in using the Options button in workouts.
* Progression is easier with 2.5 pound magnets.
"""
    return Program("DB Stopgap", workouts, exercises, tags, description)
}

