//  Created by Jesse Jones on 10/6/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation
import os.log

enum Type {
    case weights(WeightsType)
    case body(BodyType)
}

/// Used for exercises that use plates, or dumbbells, or machines with reps weights.
class WeightsType: Storable {
    enum SubType {
        case amrap(AMRAPSubType)
        case amrap1RM(AMRAP1RMSubType)
        case cyclic(CyclicRepsSubType)
        case derived(DerivedSubType)
        case emom(EMOMSubType)
        case find(FindWeightSubType)
        case percent1RM(Percent1RMSubType)
        case reps(RepsApparatusSubType)
        case t1(T1RepsSubType)
        case t1LP(T1LPRepsSubType)
        case t2(T2RepsSubType)
        case t3(T3RepsSubType)
        case timed(TimedSubType)
    }
    
    init(_ apparatus: Apparatus, _ subType: WeightsType.SubType) {
        self.apparatus = apparatus
        self.subtype = subType
    }
    
    func errors() -> [String] {
        switch subtype {
        case .amrap(let subtype): return subtype.errors()
        case .amrap1RM(let subtype): return subtype.errors()
        case .cyclic(let subtype): return subtype.errors()
        case .derived(let subtype): return subtype.errors()
        case .emom(let subtype): return subtype.errors()
        case .find(let subtype): return subtype.errors()
        case .percent1RM(let subtype): return subtype.errors()
        case .reps(let subtype): return subtype.errors()
        case .t1(let subtype): return subtype.errors()
        case .t1LP(let subtype): return subtype.errors()
        case .t2(let subtype): return subtype.errors()
        case .t3(let subtype): return subtype.errors()
        case .timed(let subtype): return subtype.errors()
        }
    }
    
    required init(from store: Store) {
        apparatus = store.getObj("apparatus")

        let name = store.getStr("subtypeName")
        switch name {
        case "amrap": self.subtype = .amrap(store.getObj("subtype"))
        case "amrap-1rm": self.subtype = .amrap1RM(store.getObj("subtype"))
        case "cyclic": self.subtype = .cyclic(store.getObj("subtype"))
        case "derived": self.subtype = .derived(store.getObj("subtype"))
        case "emom": self.subtype = .emom(store.getObj("subtype"))
        case "find": self.subtype = .find(store.getObj("subtype"))
        case "percent": self.subtype = .percent1RM(store.getObj("subtype"))
        case "percent-1rm": self.subtype = .percent1RM(store.getObj("subtype"))
        case "reps": self.subtype = .reps(store.getObj("subtype"))
        case "t1N": self.subtype = .t1(store.getObj("subtype"))
        case "t1": self.subtype = .t1LP(store.getObj("subtype"))
        case "t2": self.subtype = .t2(store.getObj("subtype"))
        case "t3": self.subtype = .t3(store.getObj("subtype"))
        case "timed": self.subtype = .timed(store.getObj("subtype"))
        default: assert(false, "bad subtype name: \(name)"); abort()
        }
    }
    
    func save(_ store: Store) {
        store.addObj("apparatus", apparatus)

        switch subtype {
        case .amrap(let subtype): store.addStr("subtypeName", "amrap"); store.addObj("subtype", subtype)
        case .amrap1RM(let subtype): store.addStr("subtypeName", "amrap-1rm"); store.addObj("subtype", subtype)
        case .cyclic(let subtype): store.addStr("subtypeName", "cyclic"); store.addObj("subtype", subtype)
        case .derived(let subtype): store.addStr("subtypeName", "derived"); store.addObj("subtype", subtype)
        case .emom(let subtype): store.addStr("subtypeName", "emom"); store.addObj("subtype", subtype)
        case .find(let subtype): store.addStr("subtypeName", "find"); store.addObj("subtype", subtype)
        case .percent1RM(let subtype): store.addStr("subtypeName", "percent-1rm"); store.addObj("subtype", subtype)
        case .reps(let subtype): store.addStr("subtypeName", "reps"); store.addObj("subtype", subtype)
        case .t1(let subtype): store.addStr("subtypeName", "t1N"); store.addObj("subtype", subtype)
        case .t1LP(let subtype): store.addStr("subtypeName", "t1"); store.addObj("subtype", subtype)
        case .t2(let subtype): store.addStr("subtypeName", "t2"); store.addObj("subtype", subtype)
        case .t3(let subtype): store.addStr("subtypeName", "t3"); store.addObj("subtype", subtype)
        case .timed(let subtype): store.addStr("subtypeName", "timed"); store.addObj("subtype", subtype)
        }
    }
    
    func sync(_ program: Program, _ savedExercise: Exercise) {
        switch savedExercise.type {
        case .weights(let savedType):
            apparatus = savedType.apparatus
        default:
            os_log("%@ wasn't saved as weights", savedExercise.name)
        }
        switch subtype {
        case .amrap(let builtIn): builtIn.sync(program, savedExercise)
        case .amrap1RM(let builtIn): builtIn.sync(program, savedExercise)
        case .cyclic(let builtIn): builtIn.sync(program, savedExercise)
        case .derived(let builtIn): builtIn.sync(program, savedExercise)
        case .emom(let builtIn): builtIn.sync(program, savedExercise)
        case .find(let builtIn): builtIn.sync(program, savedExercise)
        case .percent1RM(let builtIn): builtIn.sync(program, savedExercise)
        case .reps(let builtIn): builtIn.sync(program, savedExercise)
        case .t1(let builtIn): builtIn.sync(program, savedExercise)
        case .t1LP(let builtIn): builtIn.sync(program, savedExercise)
        case .t2(let builtIn): builtIn.sync(program, savedExercise)
        case .t3(let builtIn): builtIn.sync(program, savedExercise)
        case .timed(let builtIn): builtIn.sync(program, savedExercise)
        }
    }

    var apparatus: Apparatus
    var subtype: WeightsType.SubType
}

/// Used for exercises that like dips that are normally body-weight but can use odd sizes weights (like a vest
/// or chains or a plate or a dumbbell).
class BodyType: Storable {
    enum SubType {
        case reps(RepsBodySubType)
        case maxReps(MaxRepsSubType)
        case timed(TimedSubType)
    }
    
    init(_ subType: BodyType.SubType) {
        self.subtype = subType
    }
    
    func errors() -> [String] {
        switch subtype {
        case .maxReps(let subtype): return subtype.errors()
        case .reps(let subtype): return subtype.errors()
        case .timed(let subtype): return subtype.errors()
        }
    }
    
    required init(from store: Store) {
        let name = store.getStr("subtypeName")
        switch name {
        case "maxReps": self.subtype = .maxReps(store.getObj("subtype"))
        case "repsB": self.subtype = .reps(store.getObj("subtype"))
        case "reps": self.subtype = .reps(RepsBodySubType(Sets([], []), restSecs: 30))  // sync will fix this up
        case "timed": self.subtype = .timed(store.getObj("subtype"))
        default: assert(false, "bad subtype name: \(name)"); abort()
        }
    }
    
    func save(_ store: Store) {
        switch subtype {
        case .maxReps(let subtype): store.addStr("subtypeName", "maxReps"); store.addObj("subtype", subtype)
        case .reps(let subtype): store.addStr("subtypeName", "repsB"); store.addObj("subtype", subtype)
        case .timed(let subtype): store.addStr("subtypeName", "timed"); store.addObj("subtype", subtype)
        }
    }
    
    func sync(_ program: Program, _ savedExercise: Exercise) {
        switch subtype {
        case .reps(let builtIn): builtIn.sync(program, savedExercise)
        case .maxReps(let builtIn): builtIn.sync(program, savedExercise)
        case .timed(let builtIn): builtIn.sync(program, savedExercise)
        }
    }

    var subtype: BodyType.SubType
}

extension Type: Storable {
    public init(from store: Store) {
        let tname = store.getStr("typeName")
        switch tname {
        case "weights":
            self = .weights(store.getObj("type"))
        case "body":
            self = .body(store.getObj("type"))
        default:
            assert(false, "loading type had unknown type name: \(tname)"); abort()
        }
    }
    
    public func save(_ store: Store) {
        switch self {
        case .weights(let type):
            store.addStr("typeName", "weights")
            store.addObj("type", type)
        case .body(let type):
            store.addStr("typeName", "body")
            store.addObj("type", type)
        }
    }
}
