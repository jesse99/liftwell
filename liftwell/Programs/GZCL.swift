//  Created by Jesse Jones on 12/28/18.
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
    let subtype = T1RepsSubType(sets, restSecs: rest)
    
    let apparatus = Apparatus.barbell(bar: 45.0, collar: 0.0, plates: defaultPlates(), bumpers: bumpers, magnets: [])
    let type = WeightsType(apparatus, .t1(subtype))
    
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
    let subtype = CyclicRepsSubType(sets, restSecs: rest, advance: .always)
    
    // Didn't find much on T2 progression but it's apparently different than GZCLP: you're supposed to go up each week.
    let apparatus = Apparatus.barbell(bar: 45.0, collar: 0.0, plates: defaultPlates(), bumpers: bumpers, magnets: [])
    let type = WeightsType(apparatus, .cyclic(subtype))
    
    return Exercise(name, formalName, .weights(type), main: false)
}

fileprivate func dumbbell2T2(_ name: String, _ formalName: String, _ cycles: [(String, String, String)], restMins: Double) -> Exercise {
    let rest = Int(restMins*60.0)
    let sets: [Sets] = cycles.map {
        let warmups = parseSets($0.0)
        let worksets = parseSets($0.1)
        let backoff = parseSets($0.2)
        return Sets(warmups, worksets, backoff)
    }
    let subtype = CyclicRepsSubType(sets, restSecs: rest, advance: .always)
    
    let apparatus = Apparatus.dumbbells(weights: defaultDumbbells(), magnets: defaultMagnets(), paired: true)
    let type = WeightsType(apparatus, .cyclic(subtype))
    
    return Exercise(name, formalName, .weights(type), main: false)
}

func GZCL() -> Program {
    func t1Cycles() -> [(String, String, String)] {
        let warmup    = "10@0% 5@60% 3@75%"
        
        let worksets1 = "5@85%".x(3)
        let sets1     = (warmup, worksets1, "")
        
        let worksets2 = "3@90%".x(4)
        let sets2     = (warmup, worksets2, "")
        
        let worksets3 = "3@87% R 2@92% R 2@92% R 1@97% R 1@97% R 1@97%"
        let sets3     = (warmup, worksets3, "")
        
        let worksets4 = "3@90% R 2@95% R 1+@100%"
        let sets4     = (warmup, worksets4, "")
        
        return [sets1, sets2, sets3, sets4]
    }
    
    func t2Cycles() -> [(String, String, String)] {
        let warmup    = "5@60%"
        
        let worksets1 = "8@65%".x(4)
        let sets1     = (warmup, worksets1, "")
        
        let worksets2 = "6@70%".x(5)
        let sets2     = (warmup, worksets2, "")
        
        let worksets3 = "5@75%".x(5)
        let sets3     = (warmup, worksets3, "")
        
        let worksets4 = "4@80%".x(5)
        let sets4     = (warmup, worksets4, "")
        
        return [sets1, sets2, sets3, sets4]
    }
    
    let t1 = t1Cycles()
    let t2 = t2Cycles()
    let t3 = "12".x(3)
    let t3b = "6-12".x(3)
    
    let exercises: [Exercise] = [
        barbellT1("T1 Squat",    "Low bar Squat",  t1, restMins: 4.0),
        barbellT1("T1 OHP",      "Overhead Press", t1, restMins: 4.0),
        barbellT1("T1 Bench",    "Bench Press",    t1, restMins: 4.0),
        barbellT1("T1 Deadlift", "Deadlift",       t1, restMins: 4.0, bumpers: defaultBumpers()),
        
        barbellT2("T2 Incline Bench",   "Incline Bench Press", t2, restMins: 2.5),
        barbellT2("T2 Decline Bench",   "Decline Bench Press", t2, restMins: 2.5),
        barbellT2("T2 Front Squat",     "Front Squat",         t2, restMins: 2.5),
        barbellT2("T2 Good Morning",    "Good Morning",        t2, restMins: 2.5),
        barbellT2("T2 Paused Squat",    "Low bar Squat",       t2, restMins: 2.5),
        barbellT2("T2 Paused Bench",    "Bench Press",         t2, restMins: 2.5),
        barbellT2("T2 Paused Deadlift", "Deadlift",            t2, restMins: 2.5, bumpers: defaultBumpers()),
        dumbbell2T2("T2 DB Squat",      "Dumbbell Single Leg Split Squat",  t2, restMins: 2.5),
        dumbbell2T2("T2 DB OHP",        "Dumbbell Shoulder Press", t2, restMins: 2.5),
        dumbbell2T2("T2 DB Bench",      "Dumbbell Bench Press",    t2, restMins: 2.5),

        machine("T3 Leg Curl",        "Seated Leg Curl",    "", t3, restMins: 1.0),
        machine("T3 Leg Extension",   "Leg Extensions",     "", t3, restMins: 1.0),
        bodyweight("T3 Dips",         "Dips",               numSets: 3, startReps: 10, goalReps: 36, restMins: 1.0),
        barbell("T3 Shrugs",          "Barbell Shrug",      "", t3, restMins: 1.0),
        barbell("T3 Pendlay Row",     "Pendlay Row",        "", t3, restMins: 1.0),
        bodyweight("T3 Chinups",      "Chinup",             numSets: 3, startReps: 10, goalReps: 36, restMins: 1.0),
        bodyweight("T3 Dips",         "Dips",               numSets: 3, startReps: 10, goalReps: 36, restMins: 1.0),
        cable("T3 Face Pull",         "Face Pull",          "", t3, restMins: 1.0),
        barbell("T3 Shrugs",          "Barbell Shrug",      "", t3, restMins: 1.0),
        barbell("T3 Curls",           "Preacher Curl",      "", t3, restMins: 1.0),
        bodyweight("T3 Ab Wheel",     "Ab Wheel Rollout",   t3, restMins: 1.0),
        cable("T3 Cable Row",         "Seated Cable Row",   "", t3, restMins: 1.0),
        cable("T3 Cable Crunch",      "Cable Crunch",       "", t3, restMins: 1.0),
        barbell("T3 Skullcrusher",    "Skull Crushers",     "", t3b, restMins: 1.0),
        dumbbell2("T3 Arnold Press",  "Arnold Press",       "", t3b, restMins: 1.0),
        dumbbell2("T3 Lateral Raise", "Side Lateral Raise", "", t3b, restMins: 1.0),
        dumbbell1("T3 DB Row",        "Kroc Row",           "", t3b, restMins: 1.0),
        dumbbell1("T3 Back Ext",      "Back Extensions",    "", t3b, restMins: 1.0),
        dumbbell2("T3 DB Flyes",      "Dumbbell Flyes",     "", t3b, restMins: 1.0)]
    
    let workouts = [
        Workout("Squat",    ["T1 Squat",    "T2 Front Squat", "T2 Paused Squat", "T2 DB Squat",    "T3 DB Row", "T3 Cable Row", "T3 Back Ext", "T3 Leg Curl", "T3 Leg Extension", "T3 Ab Wheel", "T3 Cable Crunch"], scheduled: true, optional: ["T2 Paused Squat", "T2 DB Squat", "T3 DB Row", "T3 Back Ext", "T3 Ab Wheel", "T3 Cable Row", "T3 Cable Crunch"]),
        
        Workout("Bench",    ["T1 Bench",    "T2 Decline Bench", "T2 Paused Bench", "T2 DB Bench",  "T3 Chinups", "T3 Dips", "T3 DB Flyes", "T3 Skullcrusher"], scheduled: true, optional: ["T2 Paused Bench", "T2 DB Bench", "T3 Chinups", "T3 DB Flyes"]),
        
        Workout("Deadlift", ["T1 Deadlift", "T2 Good Morning", "T2 Paused Deadlift",   "T3 DB Row", "T3 Cable Row", "T3 Back Ext", "T3 Shrugs", "T3 Pendlay Row", "T3 Ab Wheel", "T3 Cable Crunch"], scheduled: true, optional: ["T2 Paused Deadlift", "T3 DB Row", "T3 Back Ext", "T3 Ab Wheel", "T3 Cable Row", "T3 Cable Crunch"]),
      
        Workout("OHP",      ["T1 OHP",      "T2 Incline Bench", "T2 DB OHP",  "T3 Chinups", "T3 Curls", "T3 Arnold Press", "T3 Face Pull", "T3 Lateral Raise"], scheduled: true, optional: ["T2 DB OHP", "T3 Chinups", "T3 Face Pull", "T3 Curls"])]
    
    let tags: [Program.Tags] = [.advanced, .strength, .barbell, .unisex, .threeDays, .fourDays, .ageUnder40]
    
    let description = """
[GZCL](http://swoleateveryheight.blogspot.com/2014/07/the-gzcl-method-simplified_13.html) from Cody Lefever isn't really a program but more of a template describing how to organize your [workouts](http://swoleateveryheight.blogspot.com/2012/11/the-gzcl-method-for-powerlifting.html). The workouts are organized into tiers:

**Tier 1**
These are the exercises that you think are the most important, typically squat, bench press, deadlift, and perhaps OHP. Tier 1 exercises are performed first within a workout for 10-15 total reps with 1-3 reps per set. All the reps should be completed without too much grinding. If not drop the weight and finish your reps (this can be done just for that workout if the problem is due to something like a bad night's rest or for the mesocycle if it's a persistent problem).

**Tier 2**
These are primary accessories for the main lift. They can be the main lifts themselves (e.g. using backoff sets) or exercises like front squat, decline bench, good mornings, rows, pull ups, lat pull down, etc. These are done after the tier 1 lifts for twice as many total reps as in tier 1 with 5-8 reps per set. You should be able to complete all these reps.

**Tier 3**
These are used to train body parts that you think need extra work. You can do 1-3 exercises here for three times as many total reps as in tier 1 with 8-12 reps per set.

Here's the built-in GZCL workout:

**Squat**
* T1 Squat
* T2 Front Squat
* T3 Leg Curl
* T3 Leg Extension

**Bench Press**
* T1 Bench Press
* T2 Decline Bench
* T3 Dips
* T3 Skullcrusher

**Deadlift**
* T1 Deadlift
* T2 Good Morning
* T3 Shrugs
* T3 Pendlay Row

**Overhead Press**
* T1 OHP
* T2 Incline Bench
* T3 Arnold Press
* T3 Lateral Raise

To speed up your workout you can super-set the tier 3 and tier 2 lifts.

Typically GZCL is run using a multi-week mesocycle where the weights in tier 1 and 2 gradually increase with total reps dropping. The last week uses an AMRAP set and the working set is increased based on how many additional reps you were able to do. The built-in version of GZCL uses a four week mesocycle.
"""
    return Program("GZCL", workouts, exercises, tags, description)
}
