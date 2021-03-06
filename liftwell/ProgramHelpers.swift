//  Created by Jesse Jones on 11/12/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation

func parseSets(_ text: String) -> [Set] {
    let parser = Parser(text: text)
    switch parser.parseSets() {
    case .left(let err): assert(false, err.mesg); abort()
    case .right(let result): return result
    }
}

func barbell(_ name: String, _ formalName: String, _ warmups: String, _ worksets: String, _ backoff: String = "", restMins: Double, bumpers: [Double] = [], trainingMaxPercent: Double? = nil, fixedSubTitle: String? = nil, main: Bool = false) -> Exercise {
    let rest = Int(restMins*60.0)
    let warmupSets = parseSets(warmups)
    let workSets = parseSets(worksets)
    let backoffSets = parseSets(backoff)
    let subtype = RepsApparatusSubType(Sets(warmupSets, workSets, backoffSets), restSecs: rest, trainingMaxPercent: trainingMaxPercent, fixedSubTitle: fixedSubTitle)
    
    let apparatus = Apparatus.barbell(bar: 45.0, collar: 0.0, plates: defaultPlates(), bumpers: bumpers, magnets: [])
    let type = WeightsType(apparatus, .reps(subtype))
    
    return Exercise(name, formalName, .weights(type), main: main)
}

func barbell(_ name: String, _ formalName: String, _ cycles: [(String, String, String)], restMins: Double, bumpers: [Double] = [], advance: AdvanceOn = .lastCycle, trainingMaxPercent: Double? = nil, resetIndex: [Int] = [], main: Bool = false) -> Exercise {
    let rest = Int(restMins*60.0)
    let sets: [Sets] = cycles.map {
        let warmups = parseSets($0.0)
        let worksets = parseSets($0.1)
        let backoff = parseSets($0.2)
        return Sets(warmups, worksets, backoff)
    }
    let subtype = CyclicRepsSubType(sets, restSecs: rest, advance: advance, trainingMaxPercent: trainingMaxPercent, resetIndex: resetIndex)
    
    let apparatus = Apparatus.barbell(bar: 45.0, collar: 0.0, plates: defaultPlates(), bumpers: bumpers, magnets: [])
    let type = WeightsType(apparatus, .cyclic(subtype))
    
    return Exercise(name, formalName, .weights(type), main: main)
}

func barbell(_ name: String, _ formalName: String, amrap1rm: [String], restMins: Double, bumpers: [Double] = [], main: Bool = false) -> Exercise {
    let rest = Int(restMins*60.0)
    let sets: [Sets] = amrap1rm.map {
        let worksets = parseSets($0)
        return Sets([], worksets, [])
    }
    let subtype = AMRAP1RMSubType(sets, restSecs: rest)
    
    let apparatus = Apparatus.barbell(bar: 45.0, collar: 0.0, plates: defaultPlates(), bumpers: bumpers, magnets: [])
    let type = WeightsType(apparatus, .amrap1RM(subtype))
    
    return Exercise(name, formalName, .weights(type), main: main)
}

func barbell(_ name: String, _ formalName: String, emom: [String], restMins: Double, bumpers: [Double] = [], main: Bool = false) -> Exercise {
    let rest = Int(restMins*60.0)
    let sets: [Sets] = emom.map {
        let worksets = parseSets($0)
        return Sets([], worksets, [])
    }
    let subtype = EMOMSubType(sets, restSecs: rest)
    
    let apparatus = Apparatus.barbell(bar: 45.0, collar: 0.0, plates: defaultPlates(), bumpers: bumpers, magnets: [])
    let type = WeightsType(apparatus, .emom(subtype))
    
    return Exercise(name, formalName, .weights(type), main: main)
}

func barbell(_ name: String, _ formalName: String, _ warmups: String, _ worksets: String, _ backoff: String = "", advanceBy: [Int], restMins: Double, bumpers: [Double] = [], trainingMaxPercent: Double? = nil, main: Bool = false) -> Exercise {
    let rest = Int(restMins*60.0)
    let warmupSets = parseSets(warmups)
    let workSets = parseSets(worksets)
    let backoffSets = parseSets(backoff)
    let subtype = AMRAPSubType(Sets(warmupSets, workSets, backoffSets), advanceBy: advanceBy, restSecs: rest, trainingMaxPercent: trainingMaxPercent)
    
    let apparatus = Apparatus.barbell(bar: 45.0, collar: 0.0, plates: defaultPlates(), bumpers: bumpers, magnets: [])
    let type = WeightsType(apparatus, .amrap(subtype))
    
    return Exercise(name, formalName, .weights(type), main: main)
}

func barbell(_ name: String, _ formalName: String, _ warmups: String, _ worksets: String, _ backoff: String = "", other: String, restMins: Double, bumpers: [Double] = [], main: Bool = false) -> Exercise {
    let rest = Int(restMins*60.0)
    let warmupSets = parseSets(warmups)
    let workSets = parseSets(worksets)
    let backoffSets = parseSets(backoff)
    let subtype = DerivedSubType(Sets(warmupSets, workSets, backoffSets), other: other, restSecs: rest)
    
    let apparatus = Apparatus.barbell(bar: 45.0, collar: 0.0, plates: defaultPlates(), bumpers: bumpers, magnets: [])
    let type = WeightsType(apparatus, .derived(subtype))
    
    return Exercise(name, formalName, .weights(type), main: main)
}

func barbell(_ name: String, _ formalName: String, _ warmups: String, _ worksets: String, _ backoff: String = "", percent1RM: Double, other: String, restMins: Double, bumpers: [Double] = [], main: Bool = false) -> Exercise {
    let rest = Int(restMins*60.0)
    let warmupSets = parseSets(warmups)
    let workSets = parseSets(worksets)
    let backoffSets = parseSets(backoff)
    let subtype = Percent1RMSubType(Sets(warmupSets, workSets, backoffSets), percent: percent1RM, other: other, restSecs: rest)
    
    let apparatus = Apparatus.barbell(bar: 45.0, collar: 0.0, plates: defaultPlates(), bumpers: bumpers, magnets: [])
    let type = WeightsType(apparatus, .percent1RM(subtype))
    
    return Exercise(name, formalName, .weights(type), main: main)
}

func bodyweight(_ name: String, _ formalName: String, _ numSets: Int, secs: Int, targetSecs: Int? = nil, fixedSubTitle: String? = nil, main: Bool = false, prevExercise: String? = nil, nextExercise: String? = nil) -> Exercise {
    let subtype = TimedSubType(numSets: numSets, currentTime: secs, targetSecs: targetSecs, fixedSubTitle: fixedSubTitle)
    let type = BodyType(.timed(subtype))
    return Exercise(name, formalName, .body(type), main: main, prevExercise: prevExercise, nextExercise: nextExercise)
}

func bodyweight(_ name: String, _ formalName: String, _ numSets: Int, by: Int, restMins: Double = 0.0, main: Bool = false, prevExercise: String? = nil, nextExercise: String? = nil) -> Exercise {
    let rest = Int(restMins*60.0)
    let reps = Set(reps: by)
    let sets = Sets([], Array(repeating: reps, count: numSets), [])
    let subtype = RepsBodySubType(sets, restSecs: rest)
    let type = BodyType(.reps(subtype))
    return Exercise(name, formalName, .body(type), main: main, prevExercise: prevExercise, nextExercise: nextExercise)
}

func bodyweight(_ name: String, _ formalName: String, _ worksets: String, restMins: Double, main: Bool = false, prevExercise: String? = nil, nextExercise: String? = nil) -> Exercise {
    let rest = Int(restMins*60.0)
    let workSets = parseSets(worksets)
    let subtype = RepsBodySubType(Sets([], workSets, []), restSecs: rest)
    let type = BodyType(.reps(subtype))
    return Exercise(name, formalName, .body(type), main: main, prevExercise: prevExercise, nextExercise: nextExercise)
}

func bodyweight(_ name: String, _ formalName: String, numSets: Int, startReps: Int, goalReps: Int, restMins: Double, restAtEnd: Bool = false, main: Bool = false, prevExercise: String? = nil, nextExercise: String? = nil) -> Exercise {
    let rest = Int(restMins*60.0)
    let subtype = MaxRepsSubType(numSets: numSets, startReps: startReps, goalReps: goalReps, restSecs: rest, restAtEnd: restAtEnd)
    let type = BodyType(.maxReps(subtype))
    return Exercise(name, formalName, .body(type), main: main, prevExercise: prevExercise, nextExercise: nextExercise)
}

func cable(_ name: String, _ formalName: String, _ warmups: String, _ worksets: String, _ backoff: String = "", restMins: Double, main: Bool = false) -> Exercise {
    let rest = Int(restMins*60.0)
    let warmupSets = parseSets(warmups)
    let workSets = parseSets(worksets)
    let backoffSets = parseSets(backoff)
    let subtype = RepsApparatusSubType(Sets(warmupSets, workSets, backoffSets), restSecs: rest)
    
    let apparatus = Apparatus.machine(range1: defaultMachine(), range2: zeroMachine(), extra: [])
    let type = WeightsType(apparatus, .reps(subtype))
    
    return Exercise(name, formalName, .weights(type), main: main)
}

func cable(_ name: String, _ formalName: String, emom: [String], restMins: Double, main: Bool = false) -> Exercise {
    let rest = Int(restMins*60.0)
    let sets: [Sets] = emom.map {
        let worksets = parseSets($0)
        return Sets([], worksets, [])
    }
    let subtype = EMOMSubType(sets, restSecs: rest)
    
    let apparatus = Apparatus.machine(range1: defaultMachine(), range2: zeroMachine(), extra: [])
    let type = WeightsType(apparatus, .emom(subtype))
    
    return Exercise(name, formalName, .weights(type), main: main)
}

func dumbbell1(_ name: String, _ formalName: String, _ warmups: String, _ worksets: String, _ backoff: String = "", restMins: Double, fixedSubTitle: String? = nil, main: Bool = false) -> Exercise {
    let rest = Int(restMins*60.0)
    let warmupSets = parseSets(warmups)
    let workSets = parseSets(worksets)
    let backoffSets = parseSets(backoff)
    let subtype = RepsApparatusSubType(Sets(warmupSets, workSets, backoffSets), restSecs: rest, fixedSubTitle: fixedSubTitle)
    
    let apparatus = Apparatus.dumbbells(weights: defaultDumbbells(), magnets: defaultMagnets(), paired: false)
    let type = WeightsType(apparatus, .reps(subtype))
    
    return Exercise(name, formalName, .weights(type), main: main)
}

func dumbbell1(_ name: String, _ formalName: String, emom: [String], restMins: Double, bumpers: [Double] = [], main: Bool = false) -> Exercise {
    let rest = Int(restMins*60.0)
    let sets: [Sets] = emom.map {
        let worksets = parseSets($0)
        return Sets([], worksets, [])
    }
    let subtype = EMOMSubType(sets, restSecs: rest)
    
    let apparatus = Apparatus.dumbbells(weights: defaultDumbbells(), magnets: defaultMagnets(), paired: false)
    let type = WeightsType(apparatus, .emom(subtype))
    
    return Exercise(name, formalName, .weights(type), main: main)
}

func dumbbell2(_ name: String, _ formalName: String, _ warmups: String, _ worksets: String, _ backoff: String = "", restMins: Double, fixedSubTitle: String? = nil, main: Bool = false) -> Exercise {
    let rest = Int(restMins*60.0)
    let warmupSets = parseSets(warmups)
    let workSets = parseSets(worksets)
    let backoffSets = parseSets(backoff)
    let subtype = RepsApparatusSubType(Sets(warmupSets, workSets, backoffSets), restSecs: rest, fixedSubTitle: fixedSubTitle)
    
    let apparatus = Apparatus.dumbbells(weights: defaultDumbbells(), magnets: defaultMagnets(), paired: true)
    let type = WeightsType(apparatus, .reps(subtype))
    
    return Exercise(name, formalName, .weights(type), main: main)
}

func dumbbell2(_ name: String, _ formalName: String, _ warmups: String, _ worksets: String, _ backoff: String = "", percent1RM: Double, other: String, restMins: Double, main: Bool = false) -> Exercise {
    let rest = Int(restMins*60.0)
    let warmupSets = parseSets(warmups)
    let workSets = parseSets(worksets)
    let backoffSets = parseSets(backoff)
    let subtype = Percent1RMSubType(Sets(warmupSets, workSets, backoffSets), percent: percent1RM, other: other, restSecs: rest)
    
    let apparatus = Apparatus.dumbbells(weights: defaultDumbbells(), magnets: defaultMagnets(), paired: true)
    let type = WeightsType(apparatus, .percent1RM(subtype))
    
    return Exercise(name, formalName, .weights(type), main: main)
}

func dumbbell2(_ name: String, _ formalName: String, emom: [String], restMins: Double, bumpers: [Double] = [], main: Bool = false) -> Exercise {
    let rest = Int(restMins*60.0)
    let sets: [Sets] = emom.map {
        let worksets = parseSets($0)
        return Sets([], worksets, [])
    }
    let subtype = EMOMSubType(sets, restSecs: rest)
    
    let apparatus = Apparatus.dumbbells(weights: defaultDumbbells(), magnets: defaultMagnets(), paired: true)
    let type = WeightsType(apparatus, .emom(subtype))
    
    return Exercise(name, formalName, .weights(type), main: main)
}

func machine(_ name: String, _ formalName: String, _ warmups: String, _ worksets: String, _ backoff: String = "", restMins: Double, main: Bool = false) -> Exercise {
    let rest = Int(restMins*60.0)
    let warmupSets = parseSets(warmups)
    let workSets = parseSets(worksets)
    let backoffSets = parseSets(backoff)
    let subtype = RepsApparatusSubType(Sets(warmupSets, workSets, backoffSets), restSecs: rest)
    
    let apparatus = Apparatus.machine(range1: defaultMachine(), range2: zeroMachine(), extra: [])
    let type = WeightsType(apparatus, .reps(subtype))
    
    return Exercise(name, formalName, .weights(type), main: main)
}

func pairedPlates(_ name: String, _ formalName: String, _ warmups: String, _ worksets: String, _ backoff: String = "", restMins: Double, main: Bool = false) -> Exercise {
    let rest = Int(restMins*60.0)
    let warmupSets = parseSets(warmups)
    let workSets = parseSets(worksets)
    let backoffSets = parseSets(backoff)
    let subtype = RepsApparatusSubType(Sets(warmupSets, workSets, backoffSets), restSecs: rest)
    
    let apparatus = Apparatus.pairedPlates(plates: defaultPlates())
    let type = WeightsType(apparatus, .reps(subtype))
    
    return Exercise(name, formalName, .weights(type), main: main)
}

func singlePlates(_ name: String, _ formalName: String, _ warmups: String, _ worksets: String, _ backoff: String = "", restMins: Double, main: Bool = false) -> Exercise {
    let rest = Int(restMins*60.0)
    let warmupSets = parseSets(warmups)
    let workSets = parseSets(worksets)
    let backoffSets = parseSets(backoff)
    let subtype = RepsApparatusSubType(Sets(warmupSets, workSets, backoffSets), restSecs: rest)
    
    let apparatus = Apparatus.singlePlates(plates: defaultPlates())
    let type = WeightsType(apparatus, .reps(subtype))
    
    return Exercise(name, formalName, .weights(type), main: main)
}

func singlePlates(_ name: String, _ formalName: String, emom: [String], restMins: Double, main: Bool = false) -> Exercise {
    let rest = Int(restMins*60.0)
    let sets: [Sets] = emom.map {
        let worksets = parseSets($0)
        return Sets([], worksets, [])
    }
    let subtype = EMOMSubType(sets, restSecs: rest)
    
    let apparatus = Apparatus.singlePlates(plates: defaultPlates())
    let type = WeightsType(apparatus, .emom(subtype))
    
    return Exercise(name, formalName, .weights(type), main: main)
}
