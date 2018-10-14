//  Created by Jesse Jones on 10/6/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation

struct Reps: Storable {
    let minReps: Int
    let maxReps: Int
    let percent: Double
    let amrap: Bool
    let rest: Bool
    
    init(reps: Int, amrap: Bool = false, rest: Bool = false) {
        self.minReps = reps
        self.maxReps = reps
        self.percent = 1.0
        self.amrap = amrap
        self.rest = rest
    }

    init(minReps: Int, maxReps: Int, amrap: Bool = false, rest: Bool = false) {
        self.minReps = minReps
        self.maxReps = maxReps
        self.percent = 1.0
        self.amrap = amrap
        self.rest = rest
    }
    
    init(minReps: Int, maxReps: Int, percent: Double, amrap: Bool = false, rest: Bool = false) {
        self.minReps = minReps
        self.maxReps = maxReps
        self.percent = percent
        self.amrap = amrap
        self.rest = rest
    }
    
    init(from store: Store) {
        self.minReps = store.getInt("minReps")
        self.maxReps = store.getInt("maxReps")
        self.percent = store.getDbl("percent")
        self.amrap = store.getBool("amrap")
        self.rest = store.getBool("rest")
    }
    
    func save(_ store: Store) {
        store.addInt("minReps", minReps)
        store.addInt("maxReps", maxReps)
        store.addDbl("percent", percent)
        store.addBool("amrap", amrap)
        store.addBool("rest", rest)
    }
    
    public func errors() -> [String] {
        var problems: [String] = []
        if minReps > maxReps {
            problems += ["reps.minReps is greater than maxReps."]
        }
        if percent < 0.0 {
            problems += ["reps.percent is less than zero."]
        }
        if percent > 1.0 {
            problems += ["reps.percent is greater than one."]
        }
        return problems
    }
}

class CyclicRepsSubtype: Storable {
    init(cycles: [[Reps]], reps: Int, restSecs: Int, advance: String?, advance2: String?) {
        self.cycles = cycles
        self.advance = advance
        self.advance2 = advance2
        
        self.weight = 0.0
        self.cycleIndex = 0
        self.restSecs = restSecs
        self.reps = reps
    }
    
    required init(from store: Store) {
        cycles = []
        let count = store.getInt("cyclesCount")
        for i in 0..<count {
            let cycle: [Reps] = store.getObjArray("cycle\(i)")
            cycles.append(cycle)
        }
        let a = store.getStr("advance")
        self.advance = a != "" ? a : nil
        let a2 = store.getStr("advance2")
        self.advance2 = a2 != "" ? a2 : nil
        
        self.weight = store.getDbl("weight")
        self.cycleIndex = store.getInt("cycleIndex")
        self.restSecs = store.getInt("restSecs")
        self.reps = store.getInt("reps")
    }
    
    func save(_ store: Store) {
        store.addInt("cyclesCount", cycles.count)
        for (i, cycle) in cycles.enumerated() {
            store.addObjArray("cycle\(i)", cycle)
        }
        store.addStr("advance", advance ?? "")
        store.addStr("advanc2", advance2 ?? "")
        
        store.addDbl("weight", weight)
        store.addInt("cycleIndex", cycleIndex)
        store.addInt("restSecs", restSecs)
        store.addInt("reps", reps)
    }
    
    public func errors() -> [String] {
        var problems: [String] = []
        for cycle in cycles {
            for r in cycle {
                problems += r.errors()
            }
        }
        return problems
    }
    
    /// "3x5-10 @ 100 lbs".
    func sublabel() -> String {
        return ""
    }

    var cycles: [[Reps]]
    var advance: String?    // prompt that allows the user to advance reps or weight, note that deloads are handled at the program level
    var advance2: String?   // allows the user to advance by twice as much
    
    var weight: Double         // starts out at 0.0
    var cycleIndex: Int
    var restSecs: Int
    var reps: Int              // can be less than minReps
}

// As many reps as possible for each set.
class MaxRepsSubType: Storable {
    init(numSets: Int, goalReps: Int, restSecs: Int, restAtEnd: Bool) {
        self.numSets = numSets
        self.goalReps = goalReps
        self.restAtEnd = restAtEnd
        
        self.weight = 0.0
        self.restSecs = restSecs
    }
    
    required init(from store: Store) {
        self.numSets = store.getInt("numSets")
        self.goalReps = store.getInt("goalReps")
        self.restAtEnd = store.getBool("restAtEnd")

        self.weight = store.getDbl("weight")
        self.restSecs = store.getInt("restSecs")
    }
    
    func save(_ store: Store) {
        store.addInt("numSets", numSets)
        store.addInt("goalReps", goalReps)
        store.addBool("restAtEnd", restAtEnd)

        store.addDbl("weight", weight)
        store.addInt("restSecs", restSecs)
    }
    
    public func errors() -> [String] {
        var problems: [String] = []
        if goalReps <= 0 {
            problems += ["subtype.goalReps should be greater than zero."]
        }
        return problems
    }
    
    var numSets: Int
    var goalReps: Int       // typically user would then switch to a harder version of the exercise or add weights
    var restAtEnd: Bool

    var weight: Double         // starts out at 0.0
    var restSecs: Int
}

class RepsSubType: Storable {
    init(sets: [Reps], reps: Int, restSecs: Int, advance: String?, advance2: String?) {
        self.sets = sets
        self.advance = advance
        self.advance2 = advance2
        
        self.weight = 0.0
        self.restSecs = restSecs
        self.reps = reps
    }
    
    required init(from store: Store) {
        self.sets = store.getObjArray("sets")
        let a = store.getStr("advance")
        self.advance = a != "" ? a : nil
        let a2 = store.getStr("advance2")
        self.advance2 = a2 != "" ? a2 : nil
        
        self.weight = store.getDbl("weight")
        self.restSecs = store.getInt("restSecs")
        self.reps = store.getInt("reps")
    }
    
    func save(_ store: Store) {
        store.addObjArray("sets", sets)
        store.addStr("advance", advance ?? "")
        store.addStr("advanc2", advance2 ?? "")
        
        store.addDbl("weight", weight)
        store.addInt("restSecs", restSecs)
        store.addInt("reps", reps)
    }
    
    public func errors() -> [String] {
        var problems: [String] = []
        
        var minReps: Int? = nil
        var maxReps: Int? = nil
        for r in sets {
            problems += r.errors()
            
            if r.minReps < r.maxReps {
                if minReps == nil {
                    minReps = r.minReps
                    maxReps = r.maxReps
                } else {
                    if minReps! != r.minReps || maxReps! != r.maxReps {
                        problems += ["Rep ranges should be the same."]
                    }
                }
            }
        }
        return problems
    }
    
    /// "3x5-10 @ 0 lbs".       TODO: probably should have a test for this
    func sublabel() -> String {
        if let max = sets.max(by: {(lhs, rhs) -> Bool in lhs.percent < rhs.percent}) {
            let worksets = sets.filter({(reps) -> Bool in reps.percent == max.percent})
            let labels = worksets.map({ (reps) -> String in
                if reps.minReps < reps.maxReps {
                    return "\(self.reps)-\(reps.maxReps)"
                } else {
                    return "\(reps.minReps)"
                }
            })
            if let first = labels.first, labels.all({(label) -> Bool in label == first}) {
                return "\(labels.count)x\(first)"
            }
        }
        return ""
                // if variable reps then use reps-maxReps
            // else use minReps
    }

    var sets: [Reps]
    var advance: String?    // prompt that allows the user to advance reps or weight
    var advance2: String?   // allows the user to advance by twice as much
    
    var weight: Double      // starts out at 0.0
    var restSecs: Int
    var reps: Int           // this only applies when minReps < maxReps, also this can be less than minReps
}

class TimedSubType: Storable {
    init(numSets: Int, currentTime: Int, targetTime: Int?, restSecs: Int, advance: String?, advance2: String?) {
        self.numSets = numSets
        self.currentTime = currentTime
        self.targetTime = targetTime
        self.advance = advance
        self.advance2 = advance2
        
        self.weight = 0.0
        self.restSecs = restSecs
    }
    
    required init(from store: Store) {
        self.numSets = store.getInt("numSets")
        let t = store.getInt("targetTime")
        self.targetTime = t > 0 ? t : nil
        let a = store.getStr("advance")
        self.advance = a != "" ? a : nil
        let a2 = store.getStr("advance2")
        self.advance2 = a2 != "" ? a2 : nil
        
        self.weight = store.getDbl("weight")
        self.currentTime = store.getInt("currentTime")
        self.restSecs = store.getInt("restSecs")
    }
    
    func save(_ store: Store) {
        store.addInt("numSets", numSets)
        store.addInt("targetTime", targetTime ?? 0)
        store.addStr("advance", advance ?? "")
        store.addStr("advanc2", advance2 ?? "")
        
        store.addDbl("weight", weight)
        store.addInt("currentTime", currentTime)
        store.addInt("restSecs", restSecs)
    }
    
    public func errors() -> [String] {
        var problems: [String] = []
        if numSets <= 0 {
            problems += ["subtype.numSets should be greater than zero."]
        }
        return problems
    }
    
    var numSets: Int
    var targetTime: Int?
    var advance: String?    // prompt that allows the user to advance reps or weight
    var advance2: String?   // allows the user to advance by twice as much
    
    var weight: Double         // starts out at 0.0
    var currentTime: Int
    var restSecs: Int
}
