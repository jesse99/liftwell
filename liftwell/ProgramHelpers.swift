//  Created by Jesse Jones on 11/12/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation

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

func barbell(_ name: String, _ formalName: String, _ reps: String, restMins: Double, main: Bool = false) -> Exercise {
    let rest = Int(restMins*60.0)
    // TODO: probably want to use parseCycles if reps has a /
    let sets = parseSets(reps)
    let (_, maxReps) = sets.repRange(minimum: nil)
    let subtype = RepsSubType(sets: sets, reps: maxReps, restSecs: rest)
    
    let apparatus = Apparatus.barbell(bar: 45.0, collar: 0.0, plates: defaultPlates(), bumpers: defaultBumpers(), magnets: [])
    let type = WeightsType(apparatus, .reps(subtype))
    
    return Exercise(name, formalName, .weights(type), main: main)
}

func bodyweight(_ name: String, _ formalName: String, _ numSets: Int, secs: Int, main: Bool = false) -> Exercise {
    let subtype = TimedSubType(numSets: numSets, currentTime: secs, targetTime: nil)
    let type = BodyType(.timed(subtype))
    return Exercise(name, formalName, .body(type), main: main)
}

func bodyweight(_ name: String, _ formalName: String, _ numSets: Int, by: Int, main: Bool = false) -> Exercise {
    let reps = Set(reps: by)
    let sets = Sets(Array(repeating: reps, count: numSets))
    let subtype = RepsSubType(sets: sets, reps: by, restSecs: 0)
    let type = BodyType(.reps(subtype))
    return Exercise(name, formalName, .body(type), main: main)
}

func bodyweight(_ name: String, _ formalName: String, _ reps: String, restMins: Double, main: Bool = false) -> Exercise {
    let rest = Int(restMins*60.0)
    let sets = parseSets(reps)
    let (_, maxReps) = sets.repRange(minimum: nil)
    let subtype = RepsSubType(sets: sets, reps: maxReps, restSecs: rest)
    let type = BodyType(.reps(subtype))
    return Exercise(name, formalName, .body(type), main: main)
}

func bodyweight(_ name: String, _ formalName: String, numSets: Int, goalReps: Int, restMins: Double, restAtEnd: Bool, main: Bool = false) -> Exercise {
    let rest = Int(restMins*60.0)
    let subtype = MaxRepsSubType(numSets: numSets, goalReps: goalReps, restSecs: rest, restAtEnd: restAtEnd)
    let type = BodyType(.maxReps(subtype))
    return Exercise(name, formalName, .body(type), main: main)
}

func cable(_ name: String, _ formalName: String, _ reps: String, restMins: Double, main: Bool = false) -> Exercise {
    let rest = Int(restMins*60.0)
    let sets = parseSets(reps)
    let (_, maxReps) = sets.repRange(minimum: nil)
    let subtype = RepsSubType(sets: sets, reps: maxReps, restSecs: rest)
    
    let apparatus = Apparatus.machine(range1: defaultMachine(), range2: zeroMachine(), extra: [])
    let type = WeightsType(apparatus, .reps(subtype))
    
    return Exercise(name, formalName, .weights(type), main: main)
}

func dumbbell1(_ name: String, _ formalName: String, _ reps: String, restMins: Double, main: Bool = false) -> Exercise {
    let rest = Int(restMins*60.0)
    let sets = parseSets(reps)
    let (_, maxReps) = sets.repRange(minimum: nil)
    let subtype = RepsSubType(sets: sets, reps: maxReps, restSecs: rest)
    
    let apparatus = Apparatus.dumbbells(weights: defaultDumbbells(), magnets: defaultMagnets(), paired: false)
    let type = WeightsType(apparatus, .reps(subtype))
    
    return Exercise(name, formalName, .weights(type), main: main)
}

func dumbbell2(_ name: String, _ formalName: String, _ reps: String, restMins: Double, main: Bool = false) -> Exercise {
    let rest = Int(restMins*60.0)
    let sets = parseSets(reps)
    let (_, maxReps) = sets.repRange(minimum: nil)
    let subtype = RepsSubType(sets: sets, reps: maxReps, restSecs: rest)
    
    let apparatus = Apparatus.dumbbells(weights: defaultDumbbells(), magnets: defaultMagnets(), paired: true)
    let type = WeightsType(apparatus, .reps(subtype))
    
    return Exercise(name, formalName, .weights(type), main: main)
}

func pairedPlates(_ name: String, _ formalName: String, _ reps: String, restMins: Double, main: Bool = false) -> Exercise {
    let rest = Int(restMins*60.0)
    let sets = parseSets(reps)
    let (_, maxReps) = sets.repRange(minimum: nil)
    let subtype = RepsSubType(sets: sets, reps: maxReps, restSecs: rest)
    
    let apparatus = Apparatus.pairedPlates(plates: defaultPlates())
    let type = WeightsType(apparatus, .reps(subtype))
    
    return Exercise(name, formalName, .weights(type), main: main)
}
