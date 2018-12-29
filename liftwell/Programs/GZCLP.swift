//  Created by Jesse Jones on 11/12/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation

fileprivate func barbellT1(_ name: String, _ formalName: String, _ cycles: [(String, String, String)], restMins: Double, bumpers: [Double] = []) -> Exercise {
    let rest = Int(restMins*60.0)
    let sets: [Sets] = cycles.map {
        let warmups = parseSets($0.0)
        let worksets = parseSets($0.1)
        let backoff = parseSets($0.2)
        return Sets(warmups, worksets, backoff)
    }
    let subtype = T1LPRepsSubType(sets, restSecs: rest)
    
    let apparatus = Apparatus.barbell(bar: 45.0, collar: 0.0, plates: defaultPlates(), bumpers: bumpers, magnets: [])
    let type = WeightsType(apparatus, .t1LP(subtype))
    
    return Exercise(name, formalName, .weights(type), main: true)
}

fileprivate func barbellT2(_ name: String, _ formalName: String, _ cycles: [(String, String, String)], restMins: Double, bumpers: [Double] = []) -> Exercise {
    let rest = Int(restMins*60.0)
    let sets: [Sets] = cycles.map {
        let warmups = parseSets($0.0)
        let worksets = parseSets($0.1)
        let backoff = parseSets($0.2)
        return Sets(warmups, worksets, backoff)
    }
    let subtype = T2RepsSubType(sets, restSecs: rest)
    
    let apparatus = Apparatus.barbell(bar: 45.0, collar: 0.0, plates: defaultPlates(), bumpers: bumpers, magnets: [])
    let type = WeightsType(apparatus, .t2(subtype))
    
    return Exercise(name, formalName, .weights(type), main: true)
}

func cableT3(_ name: String, _ formalName: String, _ worksets: String, restMins: Double, main: Bool = false) -> Exercise {
    let rest = Int(restMins*60.0)
    let workSets = parseSets(worksets)
    let subtype = T3RepsSubType(Sets([], workSets, []), restSecs: rest)
    
    let apparatus = Apparatus.machine(range1: defaultMachine(), range2: zeroMachine(), extra: [])
    let type = WeightsType(apparatus, .t3(subtype))
    
    return Exercise(name, formalName, .weights(type), main: main)
}

func dumbbellT3(_ name: String, _ formalName: String, _ worksets: String, restMins: Double) -> Exercise {
    let rest = Int(restMins*60.0)
    let workSets = parseSets(worksets)
    let subtype = T3RepsSubType(Sets([], workSets, []), restSecs: rest)
    
    let apparatus = Apparatus.dumbbells(weights: defaultDumbbells(), magnets: defaultMagnets(), paired: false)
    let type = WeightsType(apparatus, .t3(subtype))
    
    return Exercise(name, formalName, .weights(type), main: false)
}

fileprivate func t1Cycles() -> [(String, String, String)] {
    let warmup    = "10@0% 5@50% 3@75% 1@90%"
    
    let worksets1 = "3".x(5, amrap: true)
    let sets1     = (warmup, worksets1, "")
    
    let worksets2 = "2".x(6, amrap: true)
    let sets2     = (warmup, worksets2, "")
    
    let worksets3 = "1".x(10, amrap: true)
    let sets3     = (warmup, worksets3, "")
    
    return [sets1, sets2, sets3]
}

fileprivate func t2Cycles() -> [(String, String, String)] {
    let warmup    = "10@0% 5@50% 3@75% 1@90%"   // these are upper if T1 is lower and vice versa so probably a good idea to do a full warmup

    let worksets1 = "10".x(3)
    let sets1     = (warmup, worksets1, "")

    let worksets2 = "8".x(3)
    let sets2     = (warmup, worksets2, "")

    let worksets3 = "6".x(3)
    let sets3     = (warmup, worksets3, "")

    return [sets1, sets2, sets3]
}

fileprivate let details = """
[This program](https://www.reddit.com/r/Fitness/wiki/gzclp) and [5/3/1](https://old.reddit.com/r/Fitness/wiki/531-beginners) are the two programs recommended by reddit/fitness if you're familiar with the barbell lifts or if you have run [Phrak's Greyskull](https://old.reddit.com/r/Fitness/wiki/phraks-gslp) program for a few months. This program is a bit more complex than most other beginner programs but offers a more balanced selection of exercises and more sophisticated weight progression.

The exercises are divided up into three [tiers](http://swoleateveryheight.blogspot.com/2014/07/the-gzcl-method-simplified_13.html), Tier 1 are the main lifts. They are done as 5x3+ (where the plus means As Many Reps As Possible for the last set). If you are able to do 3 or more reps in the last set the weight is automatically increased. If you can't do 3 reps on the AMRAP set then the next time 6x2+ is used. When you fail on that 10x1+ is used. When that fails the app will ask you to rest 2-3 days and then help you find a new five rep max to start the cycle over again.

Tier 2 are exercises that directly support your main lifts. These start with 3x10. As before if you are able to do all the reps the weight is automatically increased. If you can't do all the reps this will change to 3x8 and then 3x6. Once 3x6 fails you'll be asked to add weight to whatever you lifted for the 3x10 sets and the cycle starts over.

Tier 3 is designed to address individual body parts and is done with 3x15+. Weight is increased automatically once you're able to do 25 reps on the AMRAP set.
"""

fileprivate let workoutDetails = """
**Squat**
* T1: Squat 5x3+, 6x2+, 10x1+
* T2: Bench 3x10, 3x8. 3x6
* T3: Lat Pulldown 3x15+

**Overhead Press**
* T1: OHP (reps are same as above)
* T2: Deadlift
* T3: Dumbbell Row

**Bench Press**
* T1: Bench Press
* T2: Squat
* T3: Lat Pulldown

**Deadlift**
* T1: Deadlift
* T2: OHP
* T3: Dumbbell Row
"""

fileprivate let notes = """
**Notes**
* Avoid lifting to failure on the AMRAP sets: if you're not sure you can squeeze out one more set or if the bar slows down significantly then stop.
* Add five pounds to upper body T1 and T2 lifts. Add ten pounds to lower body T1 and T2 lifts.
* Don't do more than ten T1 AMRAP reps.
"""

func GZCLP4() -> Program {
    let t1 = t1Cycles()
    let t2 = t2Cycles()
    let t3 = "15 R 15 R 15+"
    
    let exercises: [Exercise] = [
        barbellT1("T1 Squat",    "Low bar Squat",  t1, restMins: 4.0),
        barbellT1("T1 OHP",      "Overhead Press", t1, restMins: 4.0),
        barbellT1("T1 Bench",    "Bench Press",    t1, restMins: 4.0),
        barbellT1("T1 Deadlift", "Deadlift",       t1, restMins: 4.0, bumpers: defaultBumpers()),
        
        barbellT2("T2 Bench",    "Bench Press",    t2, restMins: 2.5),
        barbellT2("T2 Deadlift", "Deadlift",       t2, restMins: 2.5, bumpers: defaultBumpers()),
        barbellT2("T2 Squat",    "Low bar Squat",  t2, restMins: 2.5),
        barbellT2("T2 OHP",      "Overhead Press", t2, restMins: 2.5),
        
        cableT3("T3 Lat Pulldown",    "Lat Pulldown", t3, restMins: 1.0),
        dumbbellT3("T3 Dumbbell Row", "Kroc Row",     t3, restMins: 1.0)]
    
    let workouts = [
        Workout("Squat",    ["T1 Squat",    "T2 Bench",    "T3 Lat Pulldown"], scheduled: true),
        Workout("OHP",      ["T1 OHP",      "T2 Deadlift", "T3 Dumbbell Row"], scheduled: true),
        Workout("Bench",    ["T1 Bench",    "T2 Squat",    "T3 Lat Pulldown"], scheduled: true),
        Workout("Deadlift", ["T1 Deadlift", "T2 OHP",      "T3 Dumbbell Row"], scheduled: true)]
    
    let tags: [Program.Tags] = [.beginner, .strength, .barbell, .unisex, .fourDays, .ageUnder40]
    
    let description = """
\(details)

This is a four day version of the program:

\(workoutDetails)

\(notes)
"""
    return Program("GZCLP4", workouts, exercises, tags, description)
}

func GZCLP3() -> Program {
    let t1 = t1Cycles()
    let t2 = t2Cycles()
    let t3 = "15 R 15 R 15+"

    let exercises: [Exercise] = [
        barbellT1("T1 Squat",    "Low bar Squat",  t1, restMins: 4.0),
        barbellT1("T1 OHP",      "Overhead Press", t1, restMins: 4.0),
        barbellT1("T1 Bench",    "Bench Press",    t1, restMins: 4.0),
        barbellT1("T1 Deadlift", "Deadlift",       t1, restMins: 4.0, bumpers: defaultBumpers()),

        barbellT2("T2 Bench",    "Bench Press",    t2, restMins: 2.5),
        barbellT2("T2 Deadlift", "Deadlift",       t2, restMins: 2.5, bumpers: defaultBumpers()),
        barbellT2("T2 Squat",    "Low bar Squat",  t2, restMins: 2.5),
        barbellT2("T2 OHP",      "Overhead Press", t2, restMins: 2.5),

        cableT3("T3 Lat Pulldown",    "Lat Pulldown", t3, restMins: 1.0),
        dumbbellT3("T3 Dumbbell Row", "Kroc Row",     t3, restMins: 1.0)]
    
    let workouts = [
        Workout("Squat1",    ["T1 Squat",    "T2 Bench",    "T3 Lat Pulldown"], scheduled: true),
        Workout("OHP1",      ["T1 OHP",      "T2 Deadlift", "T3 Dumbbell Row"], scheduled: true),
        Workout("Bench1",    ["T1 Bench",    "T2 Squat",    "T3 Lat Pulldown"], scheduled: true),

        Workout("Deadlift1", ["T1 Deadlift", "T2 OHP",      "T3 Dumbbell Row"], scheduled: true),
        Workout("Squat2",    ["T1 Squat",    "T2 Bench",    "T3 Lat Pulldown"], scheduled: true),
        Workout("OHP2",      ["T1 OHP",      "T2 Deadlift", "T3 Dumbbell Row"], scheduled: true),

        Workout("Bench2",    ["T1 Bench",    "T2 Squat",    "T3 Lat Pulldown"], scheduled: true),
        Workout("Deadlift2", ["T1 Deadlift", "T2 OHP",      "T3 Dumbbell Row"], scheduled: true),
        Workout("Squat3",    ["T1 Squat",    "T2 Bench",    "T3 Lat Pulldown"], scheduled: true),

        Workout("OHP3",      ["T1 OHP",      "T2 Deadlift", "T3 Dumbbell Row"], scheduled: true),
        Workout("Bench3",    ["T1 Bench",    "T2 Squat",    "T3 Lat Pulldown"], scheduled: true),
        Workout("Deadlift3", ["T1 Deadlift", "T2 OHP",      "T3 Dumbbell Row"], scheduled: true),

        Workout("Squat4",    ["T1 Squat",    "T2 Bench",    "T3 Lat Pulldown"], scheduled: true),
        Workout("OHP4",      ["T1 OHP",      "T2 Deadlift", "T3 Dumbbell Row"], scheduled: true),
        Workout("Bench4",    ["T1 Bench",    "T2 Squat",    "T3 Lat Pulldown"], scheduled: true),

        Workout("Deadlift4", ["T1 Deadlift", "T2 OHP",      "T3 Dumbbell Row"], scheduled: true),
        Workout("Squat5",    ["T1 Squat",    "T2 Bench",    "T3 Lat Pulldown"], scheduled: true),
        Workout("OHP5",      ["T1 OHP",      "T2 Deadlift", "T3 Dumbbell Row"], scheduled: true),
        
        Workout("Bench5",    ["T1 Bench",    "T2 Squat",    "T3 Lat Pulldown"], scheduled: true),
        Workout("Deadlift5", ["T1 Deadlift", "T2 OHP",      "T3 Dumbbell Row"], scheduled: true),
        Workout("Squat6",    ["T1 Squat",    "T2 Bench",    "T3 Lat Pulldown"], scheduled: true),
        
        Workout("OHP6",      ["T1 OHP",      "T2 Deadlift", "T3 Dumbbell Row"], scheduled: true),
        Workout("Bench6",    ["T1 Bench",    "T2 Squat",    "T3 Lat Pulldown"], scheduled: true),
        Workout("Deadlift6", ["T1 Deadlift", "T2 OHP",      "T3 Dumbbell Row"], scheduled: true)
]
    
    let tags: [Program.Tags] = [.beginner, .strength, .barbell, .unisex, .threeDays, .ageUnder40]
    
    let description = """
\(details)
    
This is a three day version of the program where you cycle through these four workouts:

\(workoutDetails)

\(notes)
"""
    return Program("GZCLP3", workouts, exercises, tags, description)
}

