//  Created by Jesse Jones on 10/19/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation

struct Set: Storable, CustomStringConvertible {
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
