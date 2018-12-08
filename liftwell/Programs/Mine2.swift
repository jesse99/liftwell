//  Created by Jesse Jones on 10/5/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation

func Mine2() -> Program {
    let exercises = [
        // Heavy
        dumbbell2("Heavy Bench",    "Dumbbell Bench Press",            "10@50% 3@70% 1@90%", "6-12".x(3, rest: .atEnd), restMins: 4.0, main: true),
        dumbbell2("Heavy Squat",    "Dumbbell Single Leg Split Squat", "5@50% 3@75%",        "4-8".x(3, rest: .atEnd), restMins: 4.0, main: true),
        dumbbell1("Kroc Row",       "Kroc Row",                        "5@50% 3@75%",        "5-10".x(3, rest: .atEnd), restMins: 3.0, main: true),
        dumbbell2("Dumbbell Flyes", "Dumbbell Flyes",                  "10@50% ",            "6-12".x(3), restMins: 3.0),

        // Light
        dumbbell2("Dumbbell OHP",    "Dumbbell Shoulder Press", "10@50% 3@70% 1@90%", "5-10".x(3, rest: .atEnd), restMins: 3.5, main: true),
        dumbbell1("Back Extensions", "Back Extensions",         "10@50%",             "6-12".x(3), restMins: 3.0, main: true),
        bodyweight("Chinups",        "Chinup", numSets: 4, goalReps: 25, restMins: 3.5, restAtEnd: true, main: true),
        dumbbell2("Farmer's Walk",   "Farmer's Walk",           "",                   "1".x(2), restMins: 3.0),
        cable("Cable Crunches",      "Cable Crunch",            "",                   "6-12".x(3), restMins: 3.0),

        // Medium
        dumbbell2("Medium Bench",    "Dumbbell Bench Press",            "10@50% 3@70% 1@90%", "10".x(3, rest: .atEnd), percent: 0.94, other: "Heavy Bench", restMins: 4.0),
        dumbbell2("Medium Squat",    "Dumbbell Single Leg Split Squat", "5@50% 3@75%",        "6".x(3, rest: .atEnd), percent: 0.94, other: "Heavy Squat", restMins: 4.0),
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
        Workout("Heavy", ["Heavy Bench", "Heavy Squat", "Chinups", "Kroc Row", "Back Extensions"], scheduled: true, optional: ["Back Extensions"]),
        Workout("Light", ["Dumbbell OHP", "Back Extensions", "Dumbbell Flyes", "Farmer's Walk", "Cable Crunches"], scheduled: true, optional: ["Farmer's Walk", "Cable Crunches"]),
        Workout("Medium", ["Medium Bench", "Medium Squat", "Chinups", "Kroc Row", "Farmer's Walk", "Dips"], scheduled: true, optional: ["Dips", "Farmer's Walk"]),
        
        Workout("Mobility", ["Foam Rolling", "Shoulder Dislocates", "Bent-knee Iron Cross", "Roll-over into V-sit", "Rocking Frog Stretch", "Fire Hydrant Hip Circle", "Mountain Climber", "Cossack Squat", "Piriformis Stretch", "Hip Flexor Stretch"], scheduled: false)]
    
    let tags: [Program.Tags] = [.intermediate, .strength, .dumbbell, .unisex, .threeDays, .age40s, .age50s]
    
    let description = """
This is one of the programs I use when I don't have access to a gym with barbells. It's a three day a week program and the days look like this:

**Heavy** (should be a struggle to finish all the reps)
* Dumbbell Bench 3x6-12
* Bulgarian Split Squat 3x4-8
* Chinups to 25 reps
* Kroc Row 3x6-12

**Light**
* Dumbbell OHP 3x5-10
* Back Extensions 3x6-12
* Dumbbell Flyes 3x6-12

**Medium**  (should feel like you are working hard but in no danger of missing a rep)
* Dumbbell Bench 3x10 @ 94%
* Bulgarian Split Squat 3x8 @ 94%
* Chinups to 25 reps
* Kroc Row 3x6-12
"""
    return Program("Mine2", workouts, exercises, tags, description)
}
