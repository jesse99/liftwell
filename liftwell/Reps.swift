//  Created by Jesse Jones on 10/19/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation

struct Reps: Storable, CustomStringConvertible {
    let minReps: Int
    let maxReps: Int
    let percent: Double
    let amrap: Bool
    let rest: Bool
    
    init(reps: Int, percent: Double = 1.0, amrap: Bool = false, rest: Bool = false) {
        self.minReps = reps
        self.maxReps = reps
        self.percent = percent
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
    
    func errors() -> [String] {
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
    
    var description: String {
        get {
            if minReps < maxReps {
                return amrap ? "\(minReps)-\(maxReps)+ reps" : "\(minReps)-\(maxReps) reps"
            } else {
                if minReps == 1 {
                    return amrap ? "1+ reps" : "1 rep"
                } else {
                    return amrap ? "\(minReps)+ reps" : "\(minReps) reps"
                }
            }
        }
    }
}

/// "3x5-10 @ 100 lbs".
func setsSublabel(_ apparatus: Apparatus?, _ sets: [Reps], _ targetWeight: Double, _ currentReps: Int) -> String { // not fileprivate so we can use it with unit test
    if let max = sets.max(by: {(lhs, rhs) -> Bool in lhs.percent < rhs.percent}) {
        let worksets = sets.filter({(reps) -> Bool in reps.percent == max.percent})
        let labels = worksets.map({ (reps) -> String in
            if reps.minReps < reps.maxReps {
                return "\(currentReps)-\(reps.maxReps)"
            } else {
                return "\(reps.minReps)"
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

func setsActivities(_ sets: [Reps], _ weight: Double, _ apparatus: Apparatus) -> [Activity] {
    var result: [Activity] = []
    if let max = sets.max(by: {(lhs, rhs) -> Bool in lhs.percent < rhs.percent}) {
        var warmups: [Reps] = []
        var worksets: [Reps] = []
        var backoff: [Reps] = []
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
        for (i, reps) in warmups.enumerated() {
            let w = Weight(reps.percent*weight, apparatus).closest(below: weight)
            result.append(Activity(
                title: "Warmup \(i+1) of \(warmups.count)",
                subtitle: "\(Int(100*reps.percent))% of \(Weight.friendlyUnitsStr(weight))",
                amount: "\(reps) @ \(w.text)",
                details: w.plates,
                buttonName: "Next",
                showStartButton: true,
                color: nil))
        }
        for (i, reps) in worksets.enumerated() {
            let w = Weight(reps.percent*weight, apparatus).closest()
            result.append(Activity(
                title: "Workset \(i+1) of \(worksets.count)",
                subtitle: "\(Int(100*reps.percent))% of \(Weight.friendlyUnitsStr(weight))",
                amount: "\(reps) @ \(w.text)",
                details: w.plates,
                buttonName: i+1 == worksets.count && backoff.isEmpty ? "Done" : "Next",
                showStartButton: true,
                color: nil))
        }
        for (i, reps) in backoff.enumerated() {
            let w = Weight(reps.percent*weight, apparatus).closest(below: weight)
            result.append(Activity(
                title: "Backoff \(i+1) of \(backoff.count)",
                subtitle: "\(Int(100*reps.percent))% of \(Weight.friendlyUnitsStr(weight))",
                amount: "\(reps) @ \(w.text)",
                details: w.plates,
                buttonName: i+1 == backoff.count ? "Done" : "Next",
                showStartButton: true,
                color: nil))
        }
    }
    return result
}

func setsActivities(_ sets: [Reps], _ weight: Double) -> [Activity] {
    var result: [Activity] = []
    if let max = sets.max(by: {(lhs, rhs) -> Bool in lhs.percent < rhs.percent}) {
        var warmups: [Reps] = []
        var worksets: [Reps] = []
        var backoff: [Reps] = []
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
                amount: "\(reps) @ \(w)",
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
    }
    return result
}
