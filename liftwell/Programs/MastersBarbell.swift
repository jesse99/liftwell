//  Created by Jesse Jones on 8/10/19.
//  Copyright © 2018-2019 MushinApps. All rights reserved.
import Foundation

func MastersBarbell() -> Program {
    let exercises = [
        // Heavy
        barbell("Heavy Bench",  "Bench Press",   "8@0% 5@50% 3@75% 1@90%", "5".x(3, rest: .atEnd), restMins: 4.0, main: true),
        barbell("Heavy Squat",  "Low bar Squat", "5@0% 5@50% 3@75% 1@90%", "5".x(3, rest: .atEnd), restMins: 4.0, main: true),
        barbell("Deadlift",     "Deadlift",      "5@0% 5@50% 3@75% 1@90%", "5".x(1), restMins: 4.0, bumpers: defaultBumpers(), main: true),
        dumbbell1("Back Extensions", "Back Extensions", "8@50%",           "5-10".x(3, rest: .atEnd), restMins: 3.0),

        // Light
        barbell("OHP",          "Overhead Press", "8@0% 5@50% 3@75% 1@90%", "5".x(3, rest: .atEnd), restMins: 3.5, main: true),
        bodyweight("Chinups",   "Chinup",         numSets: 3, startReps: 5, goalReps: 20, restMins: 3.5, restAtEnd: true, main: true),
        cable("Lat Pulldown",   "Lat Pulldown",   "8@60%",             "5-10".x(3, rest: .atEnd), restMins: 2.5),
        cable("Cable Crunches", "Cable Crunch",   "",                  "6-12".x(3), restMins: 3.0),
        cable("Face Pull",      "Face Pull",      "",                  "6-12".x(3), restMins: 2.0),
        
        // Medium
        barbell("Medium Bench", "Bench Press",    "8@0% 5@50% 3@75% 1@90%", "5".x(2, rest: .atEnd), percent1RM: 0.94, other: "Heavy Bench", restMins: 4.0),
        barbell("Medium Squat", "Low bar Squat",  "5@0% 5@50% 3@75% 1@90%", "5".x(2, rest: .atEnd), percent1RM: 0.94, other: "Heavy Squat", restMins: 4.0),
        // Chinups
        dumbbell1("Kroc Row",   "Kroc Row",       "",                        "9-18".x(2, rest: .atEnd), restMins: 3.0, main: true),
        bodyweight("Dips",      "Dips",           numSets: 3, startReps: 10, goalReps: 30, restMins: 3.5, restAtEnd: false),

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
        Workout("Heavy", ["Heavy Bench", "Heavy Squat", "Deadlift", "Back Extensions"], scheduled: true, optional: ["Back Extensions"]),
        Workout("Light", ["OHP", "Chinups", "Lat Pulldown", "Cable Crunches", "Face Pull"], scheduled: true, optional: ["Lat Pulldown"]),
        Workout("Medium", ["Medium Bench", "Medium Squat", "Chinups", "Lat Pulldown", "Kroc Row", "Dips"], scheduled: true, optional: ["Lat Pulldown", "Dips"]),
        
        Workout("Mobility", ["Foam Rolling", "Shoulder Dislocates", "Bent-knee Iron Cross", "Roll-over into V-sit", "Rocking Frog Stretch", "Fire Hydrant Hip Circle", "Mountain Climber", "Cossack Squat", "Piriformis Stretch", "Hip Flexor Stretch"], scheduled: false)]
    
    let tags: [Program.Tags] = [.intermediate, .strength, .barbell, .unisex, .threeDays, .age40s, .age50s]
    
    let description = """
This is a program for older lifters. It's based on programming principles from the book [The Barbell Prescription: Strength Training for Life After 40](https://www.amazon.com/dp/B06Y4LXFCK/ref=dp-kindle-redirect?_encoding=UTF8&btkr=1). The [Limber 11](https://imgur.com/gallery/iEsaS) stretches should ideally be done several times a week. It's a three day a week program and the days look like this:

**Heavy** (should be a struggle to finish all the reps)
* Squat 3x5
* Bench Press 3x5
* Deadlift 1x5

**Light**
* OHP 3x5
* Chinups 3 sets with a goal of 20 total reps
* Cable Crunches 3x5-10
* Face Pulls 3x6-12

**Medium**  (should feel like you are working hard but in no danger of missing a rep)
* Bench Press 2x5 @ 94%
* Squat 2x5 @ 94%
* Chinups 3 sets with a goal of 20 total reps
* Kroc Row 3x6-12

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
    return Program("Masters Barbell", workouts, exercises, tags, description)
}
