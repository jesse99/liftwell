//  Created by Jesse Jones on 10/1/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation

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
            case .cyclic(let subtype): return subtype
            case .find(let subtype): return subtype
            case .percent1RM(let subtype): return subtype
            case .reps(let subtype): return subtype
            case .t1(let subtype): return subtype
            case .t2(let subtype): return subtype
            case .t3(let subtype): return subtype
            case .timed(let subtype): return subtype
            }
        }
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
    
    func getLastWeight() -> Double? {
        var weight: Double? = nil
        switch type {
        case .body(let type):
            switch type.subtype {
            case .maxReps(_):
                break
            case .reps(_):
                if let result = RepsApparatusSubType.results[formalName]?.last {
                    weight = result.liftedWeight
                }
            case .timed(_):
                break
            }
        case .weights(let type):
            switch type.subtype {
            case .cyclic(_), .t1(_), .t2(_):
                if let result = CyclicRepsSubtype.results[formalName]?.last {
                    weight = result.liftedWeight
                }
            case .find(_), .timed(_):
                break
            case .percent1RM(_), .reps(_), .t3(_):
                if let result = Percent1RMSubType.results[formalName]?.last {
                    weight = result.weight
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
    
    func getLastReps() -> Int? {
        switch type {
        case .body(let type):
            switch type.subtype {
            case .maxReps(_):
                if let result = MaxRepsSubType.results[formalName]?.last {
                    return result.completed.first
                }
            case .reps(_):
                if let result = RepsApparatusSubType.results[formalName]?.last {
                    return result.reps
                }
            case .timed(_):
                break
            }
        case .weights(let type):
            switch type.subtype {
            case .cyclic(_), .t1(_), .t2(_):
                if let result = CyclicRepsSubtype.results[formalName]?.last {
                    return result.reps
                }
            case .find(_), .timed(_):
                break
            case .percent1RM(_):
                if let result = Percent1RMSubType.results[formalName]?.last {
                    return result.reps
                }
            case .reps(_), .t3(_):
                if let result = RepsApparatusSubType.results[formalName]?.last {
                    return result.reps
                }
            }
        }
        return nil
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
