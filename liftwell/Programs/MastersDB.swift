//  Created by Jesse Jones on 10/5/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation

func MastersDB() -> Program {
    let exercises = [
        // Heavy
        dumbbell2("Heavy Bench",     "Dumbbell Bench Press",            "8@50% 3@70% 1@90%", "5-10".x(3, rest: .atEnd), restMins: 4.0, main: true),
        dumbbell2("Heavy Squat",     "Dumbbell Single Leg Split Squat", "5@50% 3@75%",        "4-7".x(3, rest: .atEnd), restMins: 4.0, main: true),
        bodyweight("Chinups",        "Chinup",                          numSets: 3, startReps: 5, goalReps: 20, restMins: 3.5, restAtEnd: true, main: true),
        dumbbell1("Back Extensions", "Back Extensions",                 "8@50%",             "5-10".x(3, rest: .atEnd), restMins: 3.0, main: true),
        dumbbell1("Kroc Row",        "Kroc Row",                        "",                  "9-18".x(2, rest: .atEnd), restMins: 3.0, main: true),
        cable("Lat Pulldown",        "Lat Pulldown",                    "8@60%",             "5-10".x(3, rest: .atEnd), restMins: 2.5),
        barbell("Smith Bench",       "Smith Machine Bench",             "8@50% 3@70% 1@90%", "4-8".x(3), restMins: 4.0, main: true),

        // Light
        //dumbbell1("Deadlift",        "Dumbbell Deadlift",       "10@50%",             "6-12".x(3, rest: .atEnd), restMins: 4.0, main: true),
        dumbbell2("Dumbbell OHP",    "Dumbbell Shoulder Press", "8@50% 3@70% 1@90%", "3-8".x(3, rest: .atEnd), restMins: 3.5, main: true),
        cable("Cable Crossover",     "Cable Crossover",         "",                   "5-10".x(3), restMins: 3.0),
        dumbbell2("Farmer's Walk",   "Farmer's Walk",           "",                   "1".x(2), restMins: 3.0),
        cable("Cable Crunches",      "Cable Crunch",            "",                   "6-12".x(3), restMins: 3.0),
        cable("Face Pull",           "Face Pull",               "",                   "6-12".x(3), restMins: 2.0),
        dumbbell1("Wrist Curl",      "Reverse Wrist Curl",      "",                   "6-12".x(2, rest: .atEnd), restMins: 2.0, main: false),

        // Medium
        dumbbell2("Medium Bench",    "Dumbbell Bench Press",            "8@50% 3@70% 1@90%", "4-8".x(2, rest: .atEnd), percent1RM: 0.94, other: "Heavy Bench", restMins: 4.0),
        barbell("Medium Smith Bench", "Smith Machine Bench",            "8@50% 3@70% 1@90%", "4-8".x(2, rest: .atEnd), percent1RM: 0.94, other: "Smith Bench", restMins: 4.0),
        dumbbell2("Medium Squat",    "Dumbbell Single Leg Split Squat", "5@50% 3@75%",        "3-6".x(2, rest: .atEnd), percent1RM: 0.94, other: "Heavy Squat", restMins: 4.0),
        bodyweight("Dips",           "Dips",                            numSets: 3, startReps: 10, goalReps: 30, restMins: 3.5, restAtEnd: false),
        cable("Cable Crunch",        "Cable Crunch",                    "",                   "6-12".x(3), restMins: 3.0),

        bodyweight("Foam Rolling",            "IT-Band Foam Roll",         1, by: 15),
        bodyweight("Shoulder Dislocates",     "Shoulder Dislocate",        1, by: 12),
        bodyweight("Bent-knee Iron Cross",    "Bent-knee Iron Cross",      1, by: 10),
        bodyweight("Roll-over into V-sit",    "Roll-over into V-sit",      1, by: 15), 
        bodyweight("Rocking Frog Stretch",    "Rocking Frog Stretch",      1, by: 10),
        bodyweight("Fire Hydrant Hip Circle", "Fire Hydrant Hip Circle",   1, by: 10),
        bodyweight("Mountain Climber",        "Mountain Climber",          1, by: 10),
        bodyweight("Cossack Squat",           "Cossack Squat",             1, by: 10),
        bodyweight("Piriformis Stretch",      "Seated Piriformis Stretch", 2, secs: 30)
    ]
    
    let workouts = [
        Workout("Heavy", ["Heavy Bench", "Smith Bench", "Heavy Squat", "Dumbbell OHP", "Chinups", "Lat Pulldown", "Back Extensions", "Dips", "Kroc Row", "Wrist Curl"], scheduled: true, optional: ["Back Extensions", "Kroc Row", "Lat Pulldown", "Smith Bench", "Wrist Curl", "Dips"]),
        Workout("Light", ["Dumbbell OHP", "Back Extensions", "Cable Crossover", "Farmer's Walk", "Kroc Row", "Cable Crunches", "Face Pull", "Wrist Curl"], scheduled: true, optional: ["Farmer's Walk", "Cable Crunches", "Wrist Curl", "Kroc Row"]),
        Workout("Medium", ["Medium Bench", "Medium Smith Bench", "Medium Squat", "Dumbbell OHP", "Chinups", "Lat Pulldown", "Kroc Row", "Farmer's Walk", "Dips", "Back Extensions", "Cable Crunch", "Wrist Curl"], scheduled: true, optional: ["Dips", "Farmer's Walk", "Kroc Row", "Lat Pulldown", "Medium Smith Bench", "Back Extensions", "Dumbbell OHP", "Cable Crunch"]),
        
        Workout("Mobility", ["Foam Rolling", "Shoulder Dislocates", "Bent-knee Iron Cross", "Roll-over into V-sit", "Rocking Frog Stretch", "Fire Hydrant Hip Circle", "Mountain Climber", "Cossack Squat", "Piriformis Stretch", "Hip Flexor Stretch"], scheduled: false)]
    
    let tags: [Program.Tags] = [.intermediate, .strength, .dumbbell, .threeDays, .age40s, .age50s] + anySex
    
    let description = """
This is a dumbbell only program for older lifters. It's based on programming principles from the book [The Barbell Prescription: Strength Training for Life After 40](https://www.amazon.com/dp/B06Y4LXFCK/ref=dp-kindle-redirect?_encoding=UTF8&btkr=1). The [Limber 11](https://imgur.com/gallery/iEsaS) stretches should ideally be done several times a week. It's a three day a week program and the days look like this:

**Heavy** (should be a struggle to finish all the reps)
* Dumbbell Bench 3x5-10
* Bulgarian Split Squat 3x4-7
* Chinups 3 sets with a goal of 20 total reps

**Light**
* Dumbbell OHP 3x3-8
* Back Extensions 3x5-10
* Cable Crossover 3x5-10
* Face Pull 3x6-12

**Medium**  (should feel like you are working hard but in no danger of missing a rep)
* Dumbbell Bench 3x4-8 @ 94%
* Bulgarian Split Squat 3x3-6 @ 94%
* Chinups 3 sets with a goal of 20 total reps
* Kroc Row 3x9-18

**Limber 11**
* Foam Rolling
* Shoulder Dislocates
* Bent-knee Iron Cross
* Roll-over into V-sit
* Rocking Frog Stretch
* Fire Hydrant Hip Circle
* Mountain Climber
* Cossack Squat
* Piriformis Stretch
"""
    return Program("Masters DB", workouts, exercises, tags, description)
}
