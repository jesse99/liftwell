//  Created by Jesse Jones on 10/2/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation

public struct MachineRange {
    public let min: Double
    public let max: Double
    public let step: Double
}

public enum Apparatus {
    case barbell(bar: Double, collar: Double, plates: [Double], bumpers: [Double], magnets: [Double])
    
    /// Dumbbell, both single and double (we treat these the same because in practice it seems annoying to show 2x the double weight).
    case dumbbells(weights: [Double], magnets: [Double])
    
    /// Used for stuff like cable machines with a stack of plates. Range2 is for machines that have weights like [5, 10, 15, 20, 30, ...]. Extra are small weights that can be optionally added.
    case machine(range1: MachineRange, range2: MachineRange, extra: [Double])
    
    /// Used with plates attached to a machine two at a time (e.g. a Leg Press machine).
    case pairedPlates(plates: [Double])
    
    /// Used with plates attached to a machine one at a time (e.g. a T-Bar Row machine).
    case singlePlates(plates: [Double])
}

extension Apparatus {
    public func errors() -> [String] {
        var problems: [String] = []
        
        switch self {
        case .barbell(bar: let bar, collar: let collar, plates: let plates, bumpers: let bumpers, magnets: let magnets):
            if bar < 0 {
                problems += ["barbell.bar is less than 0"]
            }
            if collar < 0 {
                problems += ["barbell.collar is less than 0"]
            }
            if plates.isEmpty {
                problems += ["barbell.plates is empty"]
            }
            if plates.any({$0 < 0.0}) {
                problems += ["barbell.plates is less than 0"]
            }
            if bumpers.any({$0 < 0.0}) {
                problems += ["barbell.bumpers is less than 0"]
            }
            if magnets.any({$0 < 0.0}) {
                problems += ["barbell.magnets is less than 0"]
            }
            
        case .pairedPlates(plates: let plates):
            if plates.isEmpty {
                problems += ["pairedPlates.plates is empty"]
            }
            if plates.any({$0 < 0.0}) {
                problems += ["pairedPlates.plates is less than 0"]
            }
            
        case .singlePlates(plates: let plates):
            if plates.isEmpty {
                problems += ["singlePlates.plates is empty"]
            }
            if plates.any({$0 < 0.0}) {
                problems += ["singlePlates.plates is less than 0"]
            }
            
        case .dumbbells(weights: let weights, magnets: let magnets):
            if weights.isEmpty {
                problems += ["dumbbells.weights is empty"]
            }
            if weights.any({$0 < 0.0}) {
                problems += ["dumbbells.weights is less than 0"]
            }
            if magnets.any({$0 < 0.0}) {
                problems += ["dumbbells.magnets is less than 0"]
            }
            
        case .machine(let range1, let range2, let extra):
            problems += range1.errors("range1")
            
            if range2.min > 0 || range2.max > 0 {
                problems += range2.errors("range2")
            }
            
            if extra.any({$0 < 0.0}) {
                problems += ["machine.extra.weights is less than 0"]
            }
        }
        
        return problems
    }
}

func defaultDumbbells() -> [Double] {
    //    switch units {
    //    case .imperial:
    return [
        5.0, 10, 15, 20, 25,
        30, 35, 40, 45, 50, 55,
        60, 70, 80, 90,
        100, 110, 120, 130, 140, 150]
    
    //    case .metric:
    //        let plates = [1.0, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 14, 16, 18, 20, 22,
    //                      24, 26, 28, 30, 32, 34, 36, 38, 40,
    //                      45, 50, 55, 60, 70]
    //        return plates.map {$0*Double.kgToLb}
    //    }
}

func defaultMagnets() -> [Double] {
    return []
}

func availableMagnets() -> [Double] {
    //    let app = UIApplication.shared.delegate as! AppDelegate
    //    switch app.units() {
    //    case .imperial:
    return [0.25, 0.5, 0.625, 0.75, 1.0, 1.25, 2.0, 2.5]
    
    //    case .metric:
    //        let plates = [0.25, 0.5, 0.75, 1.0]
    //        return plates.map {$0*Double.kgToLb}
    //    }
}

func defaultPlates() -> [Double] {
    //    switch units {
    //    case .imperial:
    return [2.5, 5, 10, 25, 45]
    
    //    case .metric:
    //        let plates = [1.25, 2.5, 5, 10, 15, 20, 25]
    //        return plates.map {$0*Double.kgToLb}
    //    }
}

func defaultBumpers() -> [Double] {
    //    switch units
    //    {
    //    case .imperial:
    return [15.0, 25, 45]
    
    //    case .metric:
    //        let plates = [5.0, 10, 20]
    //        return plates.map {$0*Double.kgToLb}
    //    }
}

func defaultMachine() -> MachineRange {
    //    switch units
    //    {
    //    case .imperial:
    return MachineRange(min: 10, max: 200, step: 10)
    
    //    case .metric:
    //        return (5.0, 5.0, 100.0)
    //    }
}

func zeroMachine() -> MachineRange {
    return MachineRange(min: 0, max: 0, step: 0)
}

func secsToStr(_ secs: Int) -> String {
    if secs <= 60 {
        return "\(secs)s"
    } else {
        return String(format: "%0.1fm", arguments: [Double(secs)/60.0])
    }
}

extension Apparatus: Storable {
    public init(from store: Store) {
        let tname = store.getStr("type")
        switch tname {
        case "barbell":
            let bar = store.getDbl("bar")
            let collar = store.getDbl("collar")
            let plates = store.getDblArray("plates", ifMissing: defaultPlates())
            let bumpers = store.getDblArray("bumpers", ifMissing: defaultBumpers())
            let magnets = store.getDblArray("magnets")
            self = .barbell(bar: bar, collar: collar, plates: plates, bumpers: bumpers, magnets: magnets)
            
        case "paired-plates":
            let plates = store.getDblArray("plates", ifMissing: defaultPlates())
            self = .pairedPlates(plates: plates)
            
        case "single-plates":
            let plates = store.getDblArray("plates", ifMissing: defaultPlates())
            self = .singlePlates(plates: plates)
            
        case "dumbbells":
            let weights = store.getDblArray("weights")
            let magnets = store.getDblArray("magnets")
            self = .dumbbells(weights: weights, magnets: magnets)
            
        case "machine":
            let min1 = store.getDbl("min1")
            let max1 = store.getDbl("max1")
            let step1 = store.getDbl("step1")
            let range1 = MachineRange(min: min1, max: max1, step: step1)
            
            let min2 = store.getDbl("min2")
            let max2 = store.getDbl("max2")
            let step2 = store.getDbl("step2")
            let range2 = MachineRange(min: min2, max: max2, step: step2)
            
            let extra = store.getDblArray("extra")
            self = .machine(range1: range1, range2: range2, extra: extra)
            
        default:
            assert(false, "loading apparatus had unknown type: \(tname)"); abort()
        }
    }
    
    public func save(_ store: Store) {
        switch self {
        case .barbell(bar: let bar, collar: let collar, plates: let plates, bumpers: let bumpers, magnets: let magnets):
            store.addStr("type", "barbell")
            store.addDbl("bar", bar)
            store.addDbl("collar", collar)
            store.addDblArray("plates", plates)
            store.addDblArray("bumpers", bumpers)
            store.addDblArray("magnets", magnets)
            
        case .pairedPlates(plates: let plates):
            store.addStr("type", "paired-plates")
            store.addDblArray("plates", plates)
            
        case .singlePlates(plates: let plates):
            store.addStr("type", "single-plates")
            store.addDblArray("plates", plates)
            
        case .dumbbells(weights: let weights, magnets: let magnets):
            store.addStr("type", "dumbbells")
            store.addDblArray("weights", weights)
            store.addDblArray("magnets", magnets)
            
        case .machine(let range1, let range2, let extra):
            store.addStr("type", "machine")
            store.addDbl("min1", range1.min)
            store.addDbl("max1", range1.max)
            store.addDbl("step1", range1.step)
            
            store.addDbl("min2", range2.min)
            store.addDbl("max2", range2.max)
            store.addDbl("step2", range2.step)
            
            store.addDblArray("extra", extra)
        }
    }
}

extension MachineRange {
    public func errors(_ prefix: String) -> [String] {
        var problems: [String] = []
        
        if self.min < 1 {
            problems += ["\(prefix) min is less than 1"]
        }
        if self.max < 1 {
            problems += ["\(prefix) max is less than 1"]
        }
        if self.step < 0.1 {
            problems += ["\(prefix) step is less than 0.1"]
        }
        
        if self.min > self.max {
            problems += ["\(prefix) min is greater than max"]
        }
        
        return problems
    }
}

