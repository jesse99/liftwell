//  Created by Jesse Jones on 10/1/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation
import UIKit

class Exercise: Storable {
    init(_ name: String, _ formalName: String, _ type: Type, main: Bool) {
        self.name = name
        self.formalName = formalName
//        self.nextExercise = nil
//        self.prevExercise = nil
        self.type = type
        self.main = main
        self.completed = [:]
        self.skipped = [:]
//        self.hidden = hidden
    }
    
    required init(from store: Store) {
        self.name = store.getStr("name")
        self.formalName = store.getStr("formalName")
        self.type = store.getObj("type")
        self.main = store.getBool("main", ifMissing: false)
//        self.hidden = store.getBool("hidden")
        
        self.completed = [:]
        self.skipped = [:]
        if store.hasKey("completed-names") {
            let names = store.getStrArray("completed-names")

            let dates = store.getDateArray("completed-dates")
            for (i, name) in names.enumerated() {
                self.completed[name] = dates[i]
            }

            let skip = store.getIntArray("completed-skip")
            for (i, name) in names.enumerated() {
                self.skipped[name] = skip[i] == 1
            }
        }
        
//        if store.hasKey("nextExercise") {
//            self.nextExercise = store.getStr("nextExercise")
//        } else {
//            self.nextExercise = nil
//        }
//        if store.hasKey("prevExercise") {
//            self.prevExercise = store.getStr("prevExercise")
//        } else {
//            self.prevExercise = nil
//        }
    }
    
    func save(_ store: Store) {
        store.addStr("name", name)
        store.addStr("formalName", formalName)
        store.addObj("type", type)
        store.addBool("main", main)
//        store.addBool("hidden", hidden)
        
//        if let next = nextExercise {
//            store.addStr("nextExercise", next)
//        }
//        if let prev = prevExercise {
//            store.addStr("prevExercise", prev)
//        }
        
        store.addStrArray("completed-names", Array(completed.keys))
        store.addDateArray("completed-dates", Array(completed.values))
        store.addIntArray("completed-skip", Array(skipped.values.map {$0 ? 1 : 0}))
    }
    
    func clone() -> Exercise {
        let store = Store()
        store.addObj("self", self)
        let result: Exercise = store.getObj("self")
        return result
    }
    
    func sync(_ savedExercise: Exercise) {
        completed = savedExercise.completed
        skipped = savedExercise.skipped
    }
    
    /// Date the exercise was last completed keyed by workout name (exercises can be shared across workouts).
    func dateCompleted(_ workout: Workout) -> (Date, Bool)? {
        if let date = completed[workout.name], let skip = skipped[workout.name] {
            return (date, skip)
        }
        return nil
    }
    
    func complete(_ workout: Workout, skipped: Bool) {
        completed[workout.name] = Date()
        self.skipped[workout.name] = skipped
    }
    
    func errors(_ program: Program) -> [String] {
        var problems: [String] = []
        
        switch type {
        case .body(let type): problems += type.errors()
        case .weights(let type): problems += type.errors()
        }
        
        //        if let name = prevExercise, program.findExercise(name) == nil {
        //            problems += ["exercise \(name) prevExercise (\(name)( is missing from the program"]
        //        }
        //        if let name = nextExercise, program.findExercise(name) == nil {
        //            problems += ["exercise \(name) nextExercise (\(name)) is missing from the program"]
        //        }
        
        return problems
    }
    
    var name: String             // "Heavy Bench"
    var formalName: String       // "Bench Press"
    var type: Type
    var main: Bool
    
    /// These are used for exercises that support progression. For example, progressively harder planks. Users
    /// can use the Options screens to choose which version they want to perform.
//    var prevExercise: String?
//    var nextExercise: String?
    
    /// If true don't display the plan in UI.
//    var hidden: Bool
    
    private var completed: [String: Date]
    private var skipped: [String: Bool]
}

extension Exercise {
    func getInfo() -> ExerciseInfo {
        switch type {
        case .body(let type):
            switch type.subtype {
            case .maxReps(let subtype): return subtype
            case .reps(let subtype): return subtype
            case .timed(let subtype): return subtype
            }
        case .weights(let type):
            switch type.subtype {
            case .amrap(let subtype): return subtype
            case .amrap1RM(let subtype): return subtype
            case .cyclic(let subtype): return subtype
            case .derived(let subtype): return subtype
            case .emom(let subtype): return subtype
            case .find(let subtype): return subtype
            case .percent1RM(let subtype): return subtype
            case .reps(let subtype): return subtype
            case .t1(let subtype): return subtype
            case .t1LP(let subtype): return subtype
            case .t2(let subtype): return subtype
            case .t3(let subtype): return subtype
            case .timed(let subtype): return subtype
            }
        }
    }
    
    func getApparatus() -> Apparatus? {
        switch type {
        case .body(_):
            break
        case .weights(let type):
            return type.apparatus
        }
        return nil
    }
    
    /// Returns the weight the user is expected to lift. This might be a training max, in which case, the user may only be asked
    /// to lift a percentage of that.
    func getBaseWeight() -> Double? {
        switch type {
        case .body(let type):
            switch type.subtype {
            case .maxReps(let subtype):
                return subtype.weight
            case .reps(let subtype):
                return subtype.weight
            case .timed(let subtype):
                return subtype.weight
            }
        case .weights(let type):
            switch type.subtype {
            case .amrap(let subtype):
                let weight = subtype.aweight.getBaseWorkingWeight()
                let w = Weight(weight, type.apparatus)
                return w.closest().weight
            case .amrap1RM(let subtype):
                let weight = subtype.aweight.getBaseWorkingWeight()
                let w = Weight(weight, type.apparatus)
                return w.closest().weight
            case .cyclic(let subtype):
                let weight = subtype.aweight.getBaseWorkingWeight()
                let w = Weight(weight, type.apparatus)
                return w.closest().weight
            case .derived(let subtype):
                if let other = currentProgram.findExercise(subtype.otherName) {
                    return other.getBaseWeight()
                }
                return nil
            case .emom(let subtype):
                let weight = subtype.aweight.getBaseWorkingWeight()
                let w = Weight(weight, type.apparatus)
                return w.closest().weight
            case .find(_):
                return nil
            case .timed(let subtype):
                return subtype.weight
            case .percent1RM(let subtype):
                let (_, weight) = subtype.getRepsAndWeight()
                return weight
            case .reps(let subtype):
                let weight = subtype.aweight.getBaseWorkingWeight()
                let w = Weight(weight, type.apparatus)
                return w.closest().weight
            case .t1(let subtype):
                let weight = subtype.aweight.getBaseWorkingWeight()
                let w = Weight(weight, type.apparatus)
                return w.closest().weight
            case .t1LP(let subtype):
                let weight = subtype.aweight.getBaseWorkingWeight()
                let w = Weight(weight, type.apparatus)
                return w.closest().weight
            case .t2(let subtype):
                let weight = subtype.aweight.getBaseWorkingWeight()
                let w = Weight(weight, type.apparatus)
                return w.closest().weight
            case .t3(let subtype):
                let weight = subtype.aweight.getBaseWorkingWeight()
                let w = Weight(weight, type.apparatus)
                return w.closest().weight
            }
        }
    }
    
    /// Returns the next base weight.
    func getNextWeight() -> Double? {
        switch type {
        case .body(_):           // these don't have an apparatus so we can't really find a next weight
            break
        case .weights(let type):
            if let weight = getBaseWeight() {
                let w = Weight(weight, type.apparatus)
                return w.nextWeight()
            }
        }
        
        return nil
    }
    
    /// Returns the previous base weight.
    func getPrevWeight() -> Double? {
        switch type {
        case .body(_):           // these don't have an apparatus so we can't really find a next weight
            break
        case .weights(let type):
            if let weight = getBaseWeight() {
                let w = Weight(weight, type.apparatus)
                return w.prevWeight()
            }
        }
        
        return nil
    }

    /// Returns the last weight the user was able to lift (so failed lifts don't count).
    func getLastWeight() -> Double? {
        var weight: Double? = nil
        let app = UIApplication.shared.delegate as! AppDelegate
        switch type {
        case .body(let type):
            switch type.subtype {
            case .maxReps(_):
                break
            case .reps(_):
                if let result = RepsBodySubType.results[formalName]?.last, result.tag != .failed, result.pname == app.program.name {
                    weight = result.weight
                }
            case .timed(_):
                break
            }
        case .weights(let type):
            switch type.subtype {
            case .amrap(_):
                if let result = AMRAPSubType.results[formalName]?.last, result.tag != .failed, result.pname == app.program.name {
                    weight = result.liftedWeight
                }
            case .amrap1RM(_):
                if let result = AMRAP1RMSubType.results[formalName]?.last, result.tag != .failed, result.pname == app.program.name {
                    weight = result.liftedWeight
                }
            case .cyclic(_):
                if let result = CyclicRepsSubType.results[formalName]?.last, result.tag != .failed, result.pname == app.program.name {
                    weight = result.liftedWeight
                }
            case .derived(_):
                if let result = DerivedSubType.results[formalName]?.last, result.tag != .failed, result.pname == app.program.name {
                    weight = result.weight
                }
            case .emom(_):
                if let result = EMOMSubType.results[formalName]?.last, result.tag != .failed, result.pname == app.program.name {
                    weight = result.liftedWeight
                }
            case .find(_), .timed(_):
                break
            case .percent1RM(_):
                if let result = Percent1RMSubType.results[formalName]?.last, result.tag != .failed, result.pname == app.program.name {
                    weight = result.weight
                }
            case .reps(_):
                if let result = RepsApparatusSubType.results[formalName]?.last, result.tag != .failed, result.pname == app.program.name {
                    weight = result.liftedWeight
                }
            case .t1(_):
                if let result = T1RepsSubType.results[formalName]?.last, result.tag != .failed, result.pname == app.program.name {
                    weight = result.liftedWeight
                }
            case .t1LP(_):
                if let result = T1LPRepsSubType.results[formalName]?.last, result.tag != .failed, result.pname == app.program.name {
                    weight = result.liftedWeight
                }
            case .t2(_):
                if let result = T2RepsSubType.results[formalName]?.last, result.tag != .failed, result.pname == app.program.name {
                    weight = result.liftedWeight
                }
            case .t3(_):
                if let result = T3RepsSubType.results[formalName]?.last, result.tag != .failed, result.pname == app.program.name {
                    weight = result.liftedWeight
                }
            }
            
            if let w = weight {
                if case let .dumbbells(weights: _, magnets: _, paired: paired) = type.apparatus, paired {
                    weight = 2 * w
                }
            }
        }
        
        return weight
    }
    
    /// Returns the last reps the user was able to lift with (so failed lifts don't count).
    func getLastReps() -> Int? {
        let app = UIApplication.shared.delegate as! AppDelegate
        switch type {
        case .body(let type):
            switch type.subtype {
            case .maxReps(_):
                if let result = MaxRepsSubType.results[formalName]?.last, result.tag != .failed, result.pname == app.program.name {
                    return result.completed.first
                }
            case .reps(_):
                if let result = RepsBodySubType.results[formalName]?.last, result.tag != .failed, result.pname == app.program.name {
                    return result.reps
                }
            case .timed(_):
                break
            }
        case .weights(let type):
            switch type.subtype {
            case .amrap(_):
                if let result = AMRAPSubType.results[formalName]?.last, result.tag != .failed, result.pname == app.program.name {
                    return result.reps
                }
            case .amrap1RM(_):
                if let result = AMRAP1RMSubType.results[formalName]?.last, result.tag != .failed, result.pname == app.program.name {
                    return result.reps
                }
            case .cyclic(_):
                if let result = CyclicRepsSubType.results[formalName]?.last, result.tag != .failed, result.pname == app.program.name {
                    return result.reps
                }
            case .derived(_):
                if let result = DerivedSubType.results[formalName]?.last, result.tag != .failed, result.pname == app.program.name {
                    return result.reps
                }
            case .emom(_):
                if let result = EMOMSubType.results[formalName]?.last, result.tag != .failed, result.pname == app.program.name {
                    return result.reps
                }
            case .find(_), .timed(_):
                break
            case .percent1RM(_):
                if let result = Percent1RMSubType.results[formalName]?.last, result.tag != .failed, result.pname == app.program.name {
                    return result.reps
                }
            case .reps(_):
                if let result = RepsApparatusSubType.results[formalName]?.last, result.tag != .failed, result.pname == app.program.name {
                    return result.reps
                }
            case .t1(_):
                if let result = T1RepsSubType.results[formalName]?.last, result.tag != .failed, result.pname == app.program.name {
                    return result.reps
                }
            case .t1LP(_):
                if let result = T1LPRepsSubType.results[formalName]?.last, result.tag != .failed, result.pname == app.program.name {
                    return result.reps
                }
            case .t2(_):
                if let result = T2RepsSubType.results[formalName]?.last, result.tag != .failed, result.pname == app.program.name {
                    return result.reps
                }
            case .t3(_):
                if let result = T3RepsSubType.results[formalName]?.last, result.tag != .failed, result.pname == app.program.name {
                    return result.reps
                }
            }
        }
        return nil
    }

    /// Returns a list of (label, number of down steps) for weights less than the specified weight and above maxPercent.
    func findDeloads(_ weight: Double, _ maxPercent: Double) -> [(String, Int)] {
        switch type {
        case .body(_):
            assert(false)
            abort()
        case .weights(let type):
            var result: [(String, Int)] = []
            
            // For variable reps we don't change the current reps so this should be fine.
            let currentWeight = Weight(weight, type.apparatus).closest().weight
            var newWeight = currentWeight
            for i in stride(from: -1, through: -8, by: -1) {
                newWeight = Weight(newWeight, type.apparatus).prevWeight()
                
                let percent = 1.0 - newWeight/currentWeight
                let label = "\(String(format: "%.0f", currentWeight - newWeight)) lbs (\(String(format: "%.0f", 100*percent))%)"
                result.append((label, i))
                
                if percent + 0.005 >= maxPercent {
                    break
                }
            }
            
            return result
        }
    }
}
