//  Created by Jesse Jones on 10/6/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation

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
            problems += repsErrors(cycle)
        }
        return problems
    }
    
    func sublabel(_ apparatus: Apparatus) -> String {
        return setsSublabel(apparatus, cycles[cycleIndex], weight, reps)
    }
    
    func activities(_ apparatus: Apparatus) -> [Activity] {
        return setsActivities(cycles[cycleIndex], weight, apparatus)
    }

    func completions() -> [Completion] {
        var result: [Completion] = []
        
        if let advance2 = advance2 {
            result.append(Completion(title: "Advance x2", info: advance2, callback: {() -> Void in self.doAdvance(2)}))
        }
        if let advance = advance {
            result.append(Completion(title: "Advance", info: advance, callback: {() -> Void in self.doAdvance(1)}))
        }
        result.append(Completion(title: "Maintain", info: "", callback: {() -> Void in self.doMaintain()}))

        return result
    }
    
    private func doAdvance(_ by: Int) {
        
    }
    
    private func doMaintain() {
        // TODO: update history
    }
    
    var cycles: [[Reps]]
    var advance: String?    // prompt that allows the user to advance reps or weight, note that deloads are handled at the program level
    var advance2: String?   // allows the user to advance by twice as much
    
    var weight: Double         // starts out at 0.0
    var cycleIndex: Int
    var restSecs: Int
    var reps: Int           // this only applies when minReps < maxReps, also this can be less than minReps
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
    
    func sublabel() -> String {
        return "\(numSets) sets"    // TODO: use last result to compute number of reps, include weight
    }
    
    // TODO: add a reps field
    // use that for activities
    func activities() -> [Activity] {
        var result: [Activity] = []
        for i in 1...numSets {
            let w = weight > 0.0 ? Weight.friendlyUnitsStr(weight) : ""
            result.append(Activity(
                title: "Set \(i+1) of \(numSets)",
                subtitle: "",
                amount: w,  // TODO: use history to figure how what to say here, note that history should be keyed by formalName not program/workout
                details: "",
                buttonName: i+1 == numSets ? "Done" : "Next",
                showStartButton: true,
                color: nil))
        }
        return result
    }
    
    func completions() -> [Completion] {
        var result: [Completion] = []
        
        if let advance2 = advance2 {
            result.append(Completion(title: "Advance x2", info: advance2, callback: {() -> Void in self.doAdvance(2)}))
        }
        if let advance = advance {
            result.append(Completion(title: "Advance", info: advance, callback: {() -> Void in self.doAdvance(1)}))
        }
        result.append(Completion(title: "Maintain", info: "", callback: {() -> Void in self.doMaintain()}))
        
        return result
    }
    
    private func doAdvance(_ by: Int) {
        
    }
    
    private func doMaintain() {
        // TODO: update history
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
        return repsErrors(sets)
    }
    
    func sublabel(_ apparatus: Apparatus?) -> String {
        return setsSublabel(apparatus, sets, weight, reps)
    }

    func activities(_ apparatus: Apparatus?) -> [Activity] {
        if let apparatus = apparatus {
            return setsActivities(sets, weight, apparatus)
        } else {
            return setsActivities(sets, weight)
        }
    }
    
    func completions() -> [Completion] {
        var result: [Completion] = []
        
        if let advance2 = advance2 {
            result.append(Completion(title: "Advance x2", info: advance2, callback: {() -> Void in self.doAdvance(2)}))
        }
        if let advance = advance {
            result.append(Completion(title: "Advance", info: advance, callback: {() -> Void in self.doAdvance(1)}))
        }
        result.append(Completion(title: "Maintain", info: "", callback: {() -> Void in self.doMaintain()}))
        
        return result
    }
    
    private func doAdvance(_ by: Int) {
        
    }
    
    private func doMaintain() {
        // TODO: update history
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
    
    func sublabel() -> String {
        let weightStr = weight > 0.0 ? " @ \(Weight.friendlyUnitsStr(weight, plural: true))" : ""
        return "\(numSets)x\(secsToStr(currentTime))\(weightStr)"
    }
    
    func activities() -> [Activity] {
        var result: [Activity] = []
        for i in 1...numSets {
            let w = weight > 0.0 ? Weight.friendlyUnitsStr(weight) : ""
            result.append(Activity(
                title: "Set \(i+1) of \(numSets)",
                subtitle: "",
                amount: w,  // TODO: use history to figure how what to say here
                details: "",
                buttonName: "",
                showStartButton: true,
                color: nil))
        }
        return result
    }
    
    func completions() -> [Completion] {
        var result: [Completion] = []
        
        if let advance2 = advance2 {
            result.append(Completion(title: "Advance x2", info: advance2, callback: {() -> Void in self.doAdvance(2)}))
        }
        if let advance = advance {
            result.append(Completion(title: "Advance", info: advance, callback: {() -> Void in self.doAdvance(1)}))
        }
        result.append(Completion(title: "Maintain", info: "", callback: {() -> Void in self.doMaintain()}))
        
        return result
    }
    
    private func doAdvance(_ by: Int) {
        
    }
    
    private func doMaintain() {
        // TODO: update history
    }
    
    var numSets: Int
    var targetTime: Int?
    var advance: String?    // prompt that allows the user to advance reps or weight
    var advance2: String?   // allows the user to advance by twice as much
    
    var weight: Double         // starts out at 0.0
    var currentTime: Int
    var restSecs: Int
}

fileprivate func repsErrors(_ sets: [Reps]) -> [String] {
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
