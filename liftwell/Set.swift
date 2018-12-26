//  Created by Jesse Jones on 10/19/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation

struct Set: Storable, CustomStringConvertible {
    let minReps: Int
    let maxReps: Int
    let percent: Double
    let amrap: Bool
    let rest: Bool
    let optionalAMRAP: Bool
    let optionalSet: Bool
    
    init(reps: Int, percent: Double = 1.0, amrap: Bool = false, optionalAMRAP: Bool = false, optionalSet: Bool = false, rest: Bool = false) {
        self.minReps = reps
        self.maxReps = reps
        self.percent = percent
        self.amrap = amrap
        self.rest = rest
        self.optionalAMRAP = optionalAMRAP
        self.optionalSet = optionalSet
    }
    
    init(minReps: Int, maxReps: Int, amrap: Bool = false, optionalAMRAP: Bool = false, optionalSet: Bool = false, rest: Bool = false) {
        self.minReps = minReps
        self.maxReps = maxReps
        self.percent = 1.0
        self.amrap = amrap
        self.rest = rest
        self.optionalAMRAP = optionalAMRAP
        self.optionalSet = optionalSet
    }
    
    init(minReps: Int, maxReps: Int, percent: Double, amrap: Bool = false, optionalAMRAP: Bool = false, optionalSet: Bool = false, rest: Bool = false) {
        self.minReps = minReps
        self.maxReps = maxReps
        self.percent = percent
        self.amrap = amrap
        self.rest = rest
        self.optionalAMRAP = optionalAMRAP
        self.optionalSet = optionalSet
    }
    
    init(from store: Store) {
        self.minReps = store.getInt("minReps")
        self.maxReps = store.getInt("maxReps")
        self.percent = store.getDbl("percent")
        self.amrap = store.getBool("amrap")
        self.rest = store.getBool("rest")
        self.optionalAMRAP = store.getBool("optionalAMRAP", ifMissing: false)
        self.optionalSet = store.getBool("optionalSet", ifMissing: false)
    }
    
    func save(_ store: Store) {
        store.addInt("minReps", minReps)
        store.addInt("maxReps", maxReps)
        store.addDbl("percent", percent)
        store.addBool("amrap", amrap)
        store.addBool("rest", rest)
        store.addBool("optionalAMRAP", optionalAMRAP)
        store.addBool("optionalSet", optionalSet)
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
    
    func label(currentReps: Int?) -> String {
        let alabel = optionalAMRAP ? "+?" : "+"
        let slabel = optionalSet ? "?" : ""
        if minReps < maxReps {
            if let current = currentReps {
                if current < maxReps {
                    return amrap ? "\(current)-\(maxReps)\(slabel)\(alabel) reps" : "\(current)-\(maxReps)\(slabel) reps"
                } else {
                    return amrap ? "\(current)\(slabel)\(alabel) reps" : "\(current)\(slabel) reps"
                }
            } else {
                return amrap ? "\(minReps)-\(maxReps)\(slabel)\(alabel) reps" : "\(minReps)-\(maxReps)\(slabel) reps"
            }
        } else {
            if minReps == 1 {
                return amrap ? "1\(slabel)\(alabel) reps" : "1\(slabel) rep"
            } else {
                return amrap ? "\(minReps)\(slabel)\(alabel) reps" : "\(minReps)\(slabel) reps"
            }
        }
    }

    var description: String {
        get {
            return label(currentReps: nil)
        }
    }
}
