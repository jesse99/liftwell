//  Created by Jesse Jones on 10/19/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation

struct Sets: Storable {
    init(_ warmups: [Set], _ worksets: [Set], _ backoff: [Set] = []) {
        self.warmups = warmups
        self.worksets = worksets
        self.backoff = backoff
    }
    
    init(from store: Store) {
        if store.hasKey("warmups") {
            self.warmups = store.getObjArray("warmups")
            self.worksets = store.getObjArray("worksets")
            self.backoff = store.getObjArray("backoff")

        } else {
            self.warmups = []
            self.worksets = store.getObjArray("sets")
            self.backoff = []
        }
    }
    
    func save(_ store: Store) {
        store.addObjArray("warmups", warmups)
        store.addObjArray("worksets", worksets)
        store.addObjArray("backoff", backoff)
    }
    
    func errors() -> [String] {
        var problems: [String] = []

        for set in warmups {
            problems += set.errors()
        }
        for set in worksets {
            problems += set.errors()
        }
        for set in backoff {
            problems += set.errors()
        }

        if worksets.isEmpty {
            problems += ["There are no work sets."]
        } else {
            var minReps: Int? = nil
            var maxReps: Int? = nil
            for set in worksets {
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
    
    var count: Int {get {return warmups.count + worksets.count + backoff.count}}
    
    func set(_ index: Int) -> Set {
        var i = index
        
        if i < warmups.count {
            return warmups[i]
        }
        i -= warmups.count
        
        if i < worksets.count {
            return worksets[i]
        }
        i -= worksets.count
        
        return backoff[i]
    }
    
    // So here we need to return the minimum and maximum we're supposed to use for worksets.
    // In general, we can't really do this but hopefully there are no programs that do stuff
    // like have worksets at [4-8, 3-5]. TODO: should we warn for that?
    func repRange(minimum: Int?) -> (Int, Int) {
        var minReps = 1
        var maxReps = 1
        
        if let set = worksets.first(where: {$0.minReps < $0.maxReps}) {
            if let min = minimum {            // minimum only applies if set.minReps < set.maxReps
                minReps = min
            } else {
                minReps = set.minReps
            }
            maxReps = set.maxReps

        } else if let last = worksets.last {
            minReps = last.minReps
            maxReps = last.maxReps
        }
        
        return (minReps, maxReps)
    }
    
    /// 3x5 @ 195 lbs     if reps are all the same
    /// 5,3,1+ @ 195 lbs  if percentages are all the same
    /// 1+ @ 195 lbs      otherwise
    func sublabel(_ apparatus: Apparatus?, _ targetWeight: Double, _ currentReps: Int?) -> String {
        func repsStr(_ reps: Set) -> String {
            let suffix = reps.amrap ? "+" : ""
            if let current = currentReps, current < reps.maxReps {
                return "\(current)-\(reps.maxReps)\(suffix)"
            } else {
                return "\(reps.maxReps)\(suffix)"
            }
        }
        
        func weightStr(_ reps: Set) -> String {
            var weight = ""
            if targetWeight > 0.0 {
                let suffix = reps.percent < 1.0 ? " (\(Int(reps.percent*100))%)" : ""
                if let apparatus = apparatus {
                    weight = " @ " + Weight(targetWeight*reps.percent, apparatus).closest().text + suffix
                } else {
                    weight = " @ " + Weight.friendlyUnitsStr(targetWeight*reps.percent) + suffix
                }
            }
            return weight
        }
        
        if let first = worksets.first {
            let sameReps = worksets.all {$0.minReps == first.minReps && $0.maxReps == first.maxReps && $0.amrap == first.amrap}
            let samePercents = worksets.all {abs($0.percent - first.percent) < 0.02}
            
            if sameReps && samePercents {
                return "\(worksets.count)x\(repsStr(first))\(weightStr(first))"

            } else if samePercents {
                let labels = worksets.map {repsStr($0)}
                let label = labels.joined(separator: ",")
                return "\(label)\(weightStr(first))"
            
            } else if let last = worksets.last {
                return "\(repsStr(last))\(weightStr(last))"
            }
        }
        return ""
    }

    func activities(_ weight: Double, _ apparatus: Apparatus, minimum: Int?) -> (Int, [Activity]) {
        var result: [Activity] = []
        let maxWeight = Weight(weight, apparatus).closest()
        for (i, reps) in warmups.enumerated() {
            let setWeight = Weight(reps.percent*weight, apparatus).closest(below: weight)
            result.append(Activity(
                title: "Warmup \(i+1) of \(warmups.count)",
                subtitle: "\(Int(100*reps.percent))% of \(maxWeight.text)",
                amount: "\(reps) @ \(setWeight.text)",
                details: setWeight.plates,
                buttonName: "Next",
                showStartButton: true,
                color: nil))
        }
        for (i, reps) in worksets.enumerated() {
            let setWeight = Weight(reps.percent*weight, apparatus).closest()
            result.append(Activity(
                title: "Workset \(i+1) of \(worksets.count)",
                subtitle: "\(Int(100*reps.percent))% of \(maxWeight.text)",
                amount: "\(reps.label(minimum: minimum)) @ \(setWeight.text)",
                details: setWeight.plates,
                buttonName: i+1 == worksets.count && backoff.isEmpty ? "Done" : "Next",
                showStartButton: true,
                color: nil))
        }
        for (i, reps) in backoff.enumerated() {
            let setWeight = Weight(reps.percent*weight, apparatus).closest(below: weight)
            result.append(Activity(
                title: "Backoff \(i+1) of \(backoff.count)",
                subtitle: "\(Int(100*reps.percent))% of \(maxWeight.text)",
                amount: "\(reps) @ \(setWeight.text)",  // TODO: should probably check that variable reps is only used with worksets
                details: setWeight.plates,
                buttonName: i+1 == backoff.count ? "Done" : "Next",
                showStartButton: true,
                color: nil))
        }
        return (warmups.count, result)
    }
    
    func activities(_ weight: Double, minimum: Int?) -> (Int, [Activity]) {
        var result: [Activity] = []
        for (i, reps) in warmups.enumerated() {
            let w = Weight.friendlyUnitsStr(reps.percent*weight)
            result.append(Activity(
                title: "Warmup \(i+1) of \(warmups.count)",
                subtitle: "\(Int(100*reps.percent))% of \(Weight.friendlyUnitsStr(weight))",
                amount: "\(reps) @ \(w)",
                details: "",
                buttonName: "Next",
                showStartButton: true,
                color: nil))
        }
        for (i, reps) in worksets.enumerated() {
            let w = Weight.friendlyUnitsStr(reps.percent*weight)
            result.append(Activity(
                title: "Workset \(i+1) of \(worksets.count)",
                subtitle: "\(Int(100*reps.percent))% of \(Weight.friendlyUnitsStr(weight))",
                amount: "\(reps.label(minimum: minimum)) @ \(w)",
                details: "",
                buttonName: i+1 == worksets.count && backoff.isEmpty ? "Done" : "Next",
                showStartButton: true,
                color: nil))
        }
        for (i, reps) in backoff.enumerated() {
            let w = Weight.friendlyUnitsStr(reps.percent*weight)
            result.append(Activity(
                title: "Backoff \(i+1) of \(backoff.count)",
                subtitle: "\(Int(100*reps.percent))% of \(Weight.friendlyUnitsStr(weight))",
                amount: "\(reps) @ \(w)",
                details: "",
                buttonName: i+1 == backoff.count ? "Done" : "Next",
                showStartButton: true,
                color: nil))
        }
        return (warmups.count, result)
    }

    let warmups: [Set]
    let worksets: [Set]
    let backoff: [Set]
}

