//  Created by Jesse Jones on 10/1/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation
import os.log

class Exercise: Storable {
    init(_ name: String, _ formalName: String, _ type: Type) {
        self.name = name
        self.formalName = formalName
//        self.nextExercise = nil
//        self.prevExercise = nil
        self.type = type
        self.completed = [:]
//        self.hidden = hidden
    }
    
    required init(from store: Store) {
        self.name = store.getStr("name")
        self.formalName = store.getStr("formalName")
        self.type = store.getObj("type")
//        self.hidden = store.getBool("hidden")
        
        self.completed = [:]
        if store.hasKey("completed-names") {
            let names = store.getStrArray("completed-names")
            let dates = store.getDateArray("completed-dates")
            
            for (i, name) in names.enumerated() {
                self.completed[name] = dates[i]
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
//        store.addBool("hidden", hidden)
        
//        if let next = nextExercise {
//            store.addStr("nextExercise", next)
//        }
//        if let prev = prevExercise {
//            store.addStr("prevExercise", prev)
//        }
        
        store.addStrArray("completed-names", Array(completed.keys))
        store.addDateArray("completed-dates", Array(completed.values))
    }
    
//    func sync(_ savedExercise: Exercise) {
//        if plan.shouldSync(savedExercise.plan) {
//            plan = savedExercise.plan
//            completed = savedExercise.completed
//            setting = savedExercise.setting
//        } else {
//            os_log("ignoring saved exercise %@", type: .info, name)
//        }
//    }
    
    var name: String             // "Heavy Bench"
    var formalName: String       // "Bench Press"
    var type: Type
    
    /// Date the exercise was last completed keyed by workout name (exercises can be shared across workouts).
    var completed: [String: Date]
    
    /// These are used for exercises that support progression. For example, progressively harder planks. Users
    /// can use the Options screens to choose which version they want to perform.
//    var prevExercise: String?
//    var nextExercise: String?
    
    /// If true don't display the plan in UI.
//    var hidden: Bool
    
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
}

internal func repsStr(_ reps: Int, amrap: Bool = false) -> String {
    if amrap {
        return "\(reps)+ reps"
        
    } else {
        if reps == 1 {
            return "1 rep"
        } else {
            return "\(reps) reps"
        }
    }
}
