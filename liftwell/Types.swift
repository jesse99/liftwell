//  Created by Jesse Jones on 10/6/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation

enum Type {
    case weights(WeightsType)
    case body(BodyType)
}

/// Used for exercises that use plates, or dumbbells, or machines with reps weights.
class WeightsType: Storable {
    enum SubType {
        case cyclic(CyclicRepsSubtype)
        case reps(RepsSubType)
        case timed(TimedSubType)
    }
    
    init(_ apparatus: Apparatus, _ subType: WeightsType.SubType) {
        self.apparatus = apparatus
        self.subtype = subType
    }
    
    func errors() -> [String] {
        switch subtype {
        case .cyclic(let subtype): return subtype.errors()
        case .reps(let subtype): return subtype.errors()
        case .timed(let subtype): return subtype.errors()
        }
    }
    
    required init(from store: Store) {
        apparatus = store.getObj("apparatus")
        
        let name = store.getStr("subtypeName")
        switch name {
        case "cyclic": self.subtype = .cyclic(store.getObj("subtype"))
        case "reps": self.subtype = .reps(store.getObj("subtype"))
        case "timed": self.subtype = .timed(store.getObj("subtype"))
        default: assert(false, "bad subtype name: \(name)"); abort()
        }
    }
    
    func save(_ store: Store) {
        store.addObj("apparatus", apparatus)
        
        switch subtype {
        case .cyclic(let subtype): store.addStr("subtypeName", "cyclic"); store.addObj("subtype", subtype)
        case .reps(let subtype): store.addStr("subtypeName", "reps"); store.addObj("subtype", subtype)
        case .timed(let subtype): store.addStr("subtypeName", "timed"); store.addObj("subtype", subtype)
        }
    }

    var apparatus: Apparatus
    var subtype: WeightsType.SubType
}

/// Used for exercises that like dips that are normally body-weight but can use odd sizes weights (like a vest
/// or chains or a plate or a dumbbell).
class BodyType: Storable {
    enum SubType {
        case reps(RepsSubType)
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
        case "reps": self.subtype = .reps(store.getObj("subtype"))
        case "timed": self.subtype = .timed(store.getObj("subtype"))
        default: assert(false, "bad subtype name: \(name)"); abort()
        }
    }
    
    func save(_ store: Store) {
        switch subtype {
        case .maxReps(let subtype): store.addStr("subtypeName", "maxReps"); store.addObj("subtype", subtype)
        case .reps(let subtype): store.addStr("subtypeName", "reps"); store.addObj("subtype", subtype)
        case .timed(let subtype): store.addStr("subtypeName", "timed"); store.addObj("subtype", subtype)
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
