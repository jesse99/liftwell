//  Created by Jesse Jones on 10/5/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation

func Mine2() -> Program {
    let exercises = [
        // Heavy
        dumbbell2("Dumbbell Bench", "Dumbbell Bench Press",            "10@50% 3@70% 1@90%",          "6-12@100% R 6-12@100% R 6-12@100% R", restMins: 4.0, main: true),
        dumbbell2("Split Squat",    "Dumbbell Single Leg Split Squat", "5@50% 3@75%",                 "4-8@100% R 4-8@100% R 4-8@100% R", restMins: 4.0, main: true),
        dumbbell2("Dumbbell Flyes", "Dumbbell Flyes",                  "10@50% ",                     "6-12@100% R 6-12@100% R 6-12@100%", restMins: 3.0),
        barbell("Deadlift",         "Deadlift",                        "5@0% 5@0% 5@60% 3@75% 1@90%", "5@100% R", restMins: 4.0, bumpers: defaultBumpers(), main: true),

        // Light
        dumbbell2("Dumbbell OHP",    "Dumbbell Shoulder Press", "10@50% 3@70% 1@90%", "5-10@100% R 5-10@100% R 5-10@100% R", restMins: 3.5, main: true),
        dumbbell2("Farmer's Walk",   "Farmer's Walk",           "",                   "1@100% R 1@100%", restMins: 3.0),
        barbell("Static Hold",       "Static Hold",             "",                   "1@100% R 1@100% R 1@100%", restMins: 3.0),
        dumbbell1("Back Extensions", "Back Extensions",         "10@50%",             "6-12@100% R 6-12@100% R 6-12@100%", restMins: 3.0),
        cable("Cable Crunches",      "Cable Crunch",            "",                   "6-12@100% R 6-12@100% R 6-12@100%", restMins: 3.0),
        bodyweight("Chinups",        "Chinup", numSets: 4, goalReps: 25, restMins: 3.5, restAtEnd: true),

        // Medium
        // Dumbbell Bench
        // Split Squat
        // Chinups
        bodyweight("Dips",           "Dips", numSets: 3, goalReps: 36, restMins: 3.5, restAtEnd: false),
        
        bodyweight("Foam Rolling",            "IT-Band Foam Roll",         1, by: 15),
        bodyweight("Shoulder Dislocates",     "Shoulder Dislocate",        1, by: 12),
        bodyweight("Bent-knee Iron Cross",    "Bent-knee Iron Cross",      1, by: 10),
        bodyweight("Roll-over into V-sit",    "Roll-over into V-sit",      1, by: 15),
        bodyweight("Rocking Frog Stretch",    "Rocking Frog Stretch",      1, by: 10),
        bodyweight("Fire Hydrant Hip Circle", "Fire Hydrant Hip Circle",   1, by: 10),
        bodyweight("Mountain Climber",        "Mountain Climber",          1, by: 10),
        bodyweight("Cossack Squat",           "Cossack Squat",             1, by: 10),
        bodyweight("Piriformis Stretch",      "Seated Piriformis Stretch", 2, secs: 30),
        bodyweight("Hip Flexor Stretch",      "Rear-foot-elevated Hip Flexor Stretch", 2, secs: 30)
    ]
    
    let workouts = [
        Workout("Light", ["Dumbbell OHP", "Chinups", "Back Extensions", "Farmer's Walk", "Static Hold", "Cable Crunches"], scheduled: true, optional: ["Static Hold", "Back Extensions", "Cable Crunches"]),
        Workout("Medium", ["Dumbbell Bench", "Split Squat", "Chinups", "Farmer's Walk", "Static Hold", "Dips"], scheduled: true, optional: ["Static Hold", "Dips"]),
        Workout("Heavy", ["Split Squat", "Dumbbell Bench", "Deadlift", "Dumbbell Flyes"], scheduled: true),
        
        Workout("Mobility", ["Foam Rolling", "Shoulder Dislocates", "Bent-knee Iron Cross", "Roll-over into V-sit", "Rocking Frog Stretch", "Fire Hydrant Hip Circle", "Mountain Climber", "Cossack Squat", "Piriformis Stretch", "Hip Flexor Stretch"], scheduled: false),
        ]
    
    let tags: [Program.Tags] = [.intermediate, .strength, .barbell, .unisex, .threeDays, .age40s, .age50s]
    
    // TODO: review description
    let description = """
This is one of the programs I use when I have intermittent access to a gym with barbells. It's a three day a week program and the days look like this:

**Heavy**
* Bulgarian Split Squat 3x4-8
* Dumbbell Bench 3x5-10
* Deadlift 1x5
* Dumbbell Flyes 3x5-10

**Light**
* Dumbbell OHP 3x5-10
* Chin Ups to 25 reps
* Farmers Walk x2

**Medium**
* Dumbbell Bench 3x5-10
* Bulgarian Split Squat 3x4-8
* Chin Ups to 25 reps
* Farmers Walk x2

It should be a bit of a struggle to do all the reps.

**Notes**
* Chinups are done with as many sets as are required, once you can do twenty five add weight.
"""
    return Program("Mine2", workouts, exercises, tags, description)
}

