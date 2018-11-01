//  Created by Jesse Jones on 10/19/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation

struct Sets: Storable {
    let sets: [Set]
    
    init(_ sets: [Set]) {
        self.sets = sets
    }
    
    init(from store: Store) {
        self.sets = store.getObjArray("sets")
    }
    
    func save(_ store: Store) {
        store.addObjArray("sets", sets)
    }
    
    func errors() -> [String] {
        var problems: [String] = []

        if sets.isEmpty {
            problems += ["There are no sets."]
        } else {
            var minReps: Int? = nil
            var maxReps: Int? = nil
            for set in sets {
                problems += set.errors()
                
                if set.minReps < set.maxReps {
                    if minReps == nil {
                        minReps = set.minReps
                        maxReps = set.maxReps
                    } else {
                        if minReps! != set.minReps || maxReps! != set.maxReps {
                            problems += ["Rep ranges should be the same."]
                        }
                    }
                }
            }
        }
        
        return problems
    }

    // Returns warmup, work, and backoff sets (some of which can be empty).
    func partition() -> (Sets, Sets, Sets) {
        if let max = sets.max(by: {(lhs, rhs) -> Bool in lhs.percent < rhs.percent}) {
            var warmups: [Set] = []
            var worksets: [Set] = []
            var backoff: [Set] = []
            for reps in sets {
                if reps.percent == max.percent {
                    worksets.append(reps)
                } else if reps.percent < max.percent {
                    if worksets.isEmpty {
                        warmups.append(reps)
                    } else {
                        backoff.append(reps)
                    }
                }
            }
            return (Sets(warmups), Sets(worksets), Sets(backoff))
        } else {
            return (Sets([]), Sets([]), Sets([]))
        }
    }
    
    // So here we need to return the minimum and maximum we're supposed to use for worksets.
    // In general, we can't really do this but hopefully there are no programs that do stuff
    // like have worksets at [4-8, 3-5]. TODO: should we warn for that?
    func repRange(minimum: Int?) -> (Int, Int) {
        var minReps = 1
        var maxReps = 1
        
        let (_, worksets, _) = partition()
        if let set = worksets.sets.first(where: {$0.minReps < $0.maxReps}) {
            if let min = minimum {            // minimum only applies if set.minReps < set.maxReps
                minReps = min
            } else {
                minReps = set.minReps
            }
            maxReps = set.maxReps

        } else if !worksets.sets.isEmpty {
            minReps = worksets.sets[0].minReps
            maxReps = worksets.sets[0].maxReps
        }
        
        return (minReps, maxReps)
    }
    
    /// "3x5-10 @ 100 lbs".
    func sublabel(_ apparatus: Apparatus?, _ targetWeight: Double, _ currentReps: Int) -> String {
        let (_, worksets, _) = partition()
        if !worksets.sets.isEmpty {
            let labels = worksets.sets.map({ (reps) -> String in
                if currentReps < reps.maxReps {
                    return "\(currentReps)-\(reps.maxReps)"
                } else {
                    return "\(reps.maxReps)"
                }
            })
            if let first = labels.first, labels.all({(label) -> Bool in label == first}) {
                var weight = ""
                if targetWeight > 0.0 {
                    if let apparatus = apparatus {
                        weight = " @ \(Weight(targetWeight, apparatus).closest().text)"
                    } else {
                        weight = " @ \(Weight.friendlyUnitsStr(targetWeight))"
                    }
                }
                return "\(labels.count)x\(first)\(weight)"
            }
        }
        return ""
    }

    func activities(_ weight: Double, _ apparatus: Apparatus, minimum: Int) -> (Int, [Activity]) {
        var result: [Activity] = []
        let (warmups, worksets, backoff) = partition()
        for (i, reps) in warmups.sets.enumerated() {
            let w = Weight(reps.percent*weight, apparatus).closest(below: weight)
            result.append(Activity(
                title: "Warmup \(i+1) of \(warmups.sets.count)",
                subtitle: "\(Int(100*reps.percent))% of \(Weight.friendlyUnitsStr(weight))",
                amount: "\(reps) @ \(w.text)",
                details: w.plates,
                buttonName: "Next",
                showStartButton: true,
                color: nil))
        }
        for (i, reps) in worksets.sets.enumerated() {
            let w = Weight(reps.percent*weight, apparatus).closest()
            result.append(Activity(
                title: "Workset \(i+1) of \(worksets.sets.count)",
                subtitle: "\(Int(100*reps.percent))% of \(Weight.friendlyUnitsStr(weight))",
                amount: "\(reps.label(minimum: minimum)) @ \(w.text)",
                details: w.plates,
                buttonName: i+1 == worksets.sets.count && backoff.sets.isEmpty ? "Done" : "Next",
                showStartButton: true,
                color: nil))
        }
        for (i, reps) in backoff.sets.enumerated() {
            let w = Weight(reps.percent*weight, apparatus).closest(below: weight)
            result.append(Activity(
                title: "Backoff \(i+1) of \(backoff.sets.count)",
                subtitle: "\(Int(100*reps.percent))% of \(Weight.friendlyUnitsStr(weight))",
                amount: "\(reps) @ \(w.text)",  // TODO: should probably check that variable reps is only used with worksets
                details: w.plates,
                buttonName: i+1 == backoff.sets.count ? "Done" : "Next",
                showStartButton: true,
                color: nil))
        }
        return (warmups.sets.count, result)
    }
    
    func activities(_ weight: Double, minimum: Int) -> (Int, [Activity]) {
        var result: [Activity] = []
        let (warmups, worksets, backoff) = partition()
        for (i, reps) in warmups.sets.enumerated() {
            let w = Weight.friendlyUnitsStr(reps.percent*weight)
            result.append(Activity(
                title: "Warmup \(i+1) of \(warmups.sets.count)",
                subtitle: "\(Int(100*reps.percent))% of \(Weight.friendlyUnitsStr(weight))",
                amount: "\(reps) @ \(w)",
                details: "",
                buttonName: "Next",
                showStartButton: true,
                color: nil))
        }
        for (i, reps) in worksets.sets.enumerated() {
            let w = Weight.friendlyUnitsStr(reps.percent*weight)
            result.append(Activity(
                title: "Workset \(i+1) of \(worksets.sets.count)",
                subtitle: "\(Int(100*reps.percent))% of \(Weight.friendlyUnitsStr(weight))",
                amount: "\(reps.label(minimum: minimum)) @ \(w)",
                details: "",
                buttonName: i+1 == worksets.sets.count && backoff.sets.isEmpty ? "Done" : "Next",
                showStartButton: true,
                color: nil))
        }
        for (i, reps) in backoff.sets.enumerated() {
            let w = Weight.friendlyUnitsStr(reps.percent*weight)
            result.append(Activity(
                title: "Backoff \(i+1) of \(backoff.sets.count)",
                subtitle: "\(Int(100*reps.percent))% of \(Weight.friendlyUnitsStr(weight))",
                amount: "\(reps) @ \(w)",
                details: "",
                buttonName: i+1 == backoff.sets.count ? "Done" : "Next",
                showStartButton: true,
                color: nil))
        }
        return (warmups.sets.count, result)
    }
}

