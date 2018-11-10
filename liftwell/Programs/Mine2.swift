//  Created by Jesse Jones on 10/5/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation

// TODO:
// move these functions into a helpers file
func parseCycles(_ text: String) -> [Sets] {
    let parser = Parser(text: text)
    switch parser.parseCycles() {
        case .left(let err): assert(false, err.mesg); abort()
        case .right(let result): return result
    }
}

func parseSets(_ text: String) -> Sets {
    let parser = Parser(text: text)
    switch parser.parseSets() {
    case .left(let err): assert(false, err.mesg); abort()
    case .right(let result): return result
    }
}

fileprivate func bodyweight(_ name: String, _ formalName: String, _ numSets: Int, secs: Int, main: Bool = false) -> Exercise {
    let subtype = TimedSubType(numSets: numSets, currentTime: secs, targetTime: nil)
    let type = BodyType(.timed(subtype))
    return Exercise(name, formalName, .body(type), main: main)
}

fileprivate func bodyweight(_ name: String, _ formalName: String, _ numSets: Int, by: Int, main: Bool = false) -> Exercise {
    let reps = Set(reps: by)
    let sets = Sets(Array(repeating: reps, count: numSets))
    let subtype = RepsSubType(sets: sets, reps: by, restSecs: 0)
    let type = BodyType(.reps(subtype))
    return Exercise(name, formalName, .body(type), main: main)
}

fileprivate func bodyweight(_ name: String, _ formalName: String, numSets: Int, goalReps: Int, restMins: Double, restAtEnd: Bool, main: Bool = false) -> Exercise {
    let rest = Int(restMins*60.0)
    let subtype = MaxRepsSubType(numSets: numSets, goalReps: goalReps, restSecs: rest, restAtEnd: restAtEnd)
    let type = BodyType(.maxReps(subtype))
    return Exercise(name, formalName, .body(type), main: main)
}

fileprivate func pairedPlates(_ name: String, _ formalName: String, _ reps: String, startReps: Int, restMins: Double, main: Bool = false) -> Exercise {
    let rest = Int(restMins*60.0)
    let subtype = RepsSubType(sets: parseSets(reps), reps: startReps, restSecs: rest)
    
    let apparatus = Apparatus.pairedPlates(plates: defaultPlates())
    let type = WeightsType(apparatus, .reps(subtype))
    
    return Exercise(name, formalName, .weights(type), main: main)
}

fileprivate func cable(_ name: String, _ formalName: String, _ reps: String, startReps: Int, restMins: Double, main: Bool = false) -> Exercise {
    let rest = Int(restMins*60.0)
    let subtype = RepsSubType(sets: parseSets(reps), reps: startReps, restSecs: rest)
    
    let apparatus = Apparatus.machine(range1: defaultMachine(), range2: zeroMachine(), extra: [])
    let type = WeightsType(apparatus, .reps(subtype))
    
    return Exercise(name, formalName, .weights(type), main: main)
}

fileprivate func dumbbell1(_ name: String, _ formalName: String, _ reps: String, startReps: Int, restMins: Double, main: Bool = false) -> Exercise {
    let rest = Int(restMins*60.0)
    let subtype = RepsSubType(sets: parseSets(reps), reps: startReps, restSecs: rest)

    let apparatus = Apparatus.dumbbells(weights: defaultDumbbells(), magnets: defaultMagnets(), paired: false)
    let type = WeightsType(apparatus, .reps(subtype))
    
    return Exercise(name, formalName, .weights(type), main: main)
}

fileprivate func dumbbell2(_ name: String, _ formalName: String, _ reps: String, startReps: Int, restMins: Double, main: Bool = false) -> Exercise {
    let rest = Int(restMins*60.0)
    let subtype = RepsSubType(sets: parseSets(reps), reps: startReps, restSecs: rest)
    
    let apparatus = Apparatus.dumbbells(weights: defaultDumbbells(), magnets: defaultMagnets(), paired: true)
    let type = WeightsType(apparatus, .reps(subtype))
    
    return Exercise(name, formalName, .weights(type), main: main)
}

fileprivate func barbell(_ name: String, _ formalName: String, _ reps: String, startReps: Int, restMins: Double, main: Bool = false) -> Exercise {
    let rest = Int(restMins*60.0)
    let subtype = RepsSubType(sets: parseSets(reps), reps: startReps, restSecs: rest)
    
    let apparatus = Apparatus.barbell(bar: 45.0, collar: 0.0, plates: defaultPlates(), bumpers: defaultBumpers(), magnets: [])
    let type = WeightsType(apparatus, .reps(subtype))
    
    return Exercise(name, formalName, .weights(type), main: main)
}

func Mine2() -> Program {
    let exercises = [
        // Heavy
        dumbbell2("Dumbbell Bench", "Dumbbell Bench Press",            "10@50% 3@70% 1@90% 5-10@100% R 5-10@100% R 5-10@100% R", startReps: 5, restMins: 4.0, main: true),
        dumbbell2("Split Squat",    "Dumbbell Single Leg Split Squat", "5@50% 3@75% 4-8@100% R 4-8@100% R 4-8@100% R", startReps: 4, restMins: 4.0, main: true),
        dumbbell2("Dumbbell Flyes", "Dumbbell Flyes",                  "10@50% 5-10@100% R 5-10@100% R 5-10@100%", startReps: 5, restMins: 3.0),
        barbell("Deadlift",         "Deadlift",                        "5@0% 5@0% 5@60% 5@70% 3@80% 1@90% 5@100% R", startReps: 5, restMins: 4.0, main: true),

        // Light
        dumbbell2("Dumbbell OHP",    "Dumbbell Shoulder Press", "10@50% 3@70% 1@90% 5-10@100% R 5-10@100% R 5-10@100% R", startReps: 5, restMins: 3.5, main: true),
        dumbbell2("Farmer's Walk",   "Farmer's Walk",           "1@100% R 1@100% R", startReps: 1, restMins: 3.0),
        barbell("Static Hold",       "Static Hold",             "1@100% R 1@100% R 1@100% R", startReps: 1, restMins: 3.0),
        dumbbell1("Back Extensions", "Back Extensions",         "10@50% 6-12@100% R 6-12@100% R 6-12@100% R", startReps: 6, restMins: 3.0),
        cable("Cable Crunches",      "Cable Crunch",            "6-12@100% R 6-12@100% R 6-12@100%", startReps: 5, restMins: 3.0),
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

