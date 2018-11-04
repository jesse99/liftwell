//  Created by Jesse Jones on 10/1/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation
import os.log

class Workout: Storable {
    init(_ name: String, _ exercises: [String], scheduled: Bool = true, optional: [String] = []) {
        self.name = name
        self.exercises = exercises
        self.optional = optional
        self.scheduled = scheduled
        self.lastWorkout = nil
    }
    
    required init(from store: Store) {
        self.name = store.getStr("name")
        self.exercises = store.getStrArray("exercises")
        self.optional = store.getStrArray("optional")
        self.scheduled = store.getBool("scheduled", ifMissing: true)
        
        if store.hasKey("lastWorkout") {
            self.lastWorkout = store.getDate("lastWorkout")
        } else {
            self.lastWorkout = nil
        }
    }
    
    func save(_ store: Store) {
        store.addStr("name", name)
        store.addStrArray("exercises", exercises)
        store.addStrArray("optional", optional)
        store.addBool("scheduled", scheduled)
        if let date = lastWorkout {
            store.addDate("lastWorkout", date)
        }
    }
    
    func sync(_ savedWorkout: Workout) {
        lastWorkout = savedWorkout.lastWorkout
    }
    
    func errors(_ program: Program) -> [String] {
        var problems: [String] = []
        
        for n in Swift.Set(exercises) {
            if exercises.count({$0 == n}) > 1 {
                problems += ["workout \(name) exercise (\(n)) appears more than once"]
            }
        }
        
        for n in Swift.Set(optional) {
            if optional.count({$0 == n}) > 1 {
                problems += ["workout \(name) optional (\(n)) appears more than once"]
            }
        }
        
        for n in Swift.Set(optional) {
            if !exercises.contains(n) {
                problems += ["workout \(name) optional (\(n)) isn't in exercises"]
            }
        }
        
        //        for n in Set(exercises) {
        //            if program.findExercise(n) == nil {
        //                problems += ["workout \(name) exercises (\(n)) isn't in the program"]
        //            }
        //        }
        
        return problems
    }

    // Returns true if this is the first exercise completed today.
    func completed(_ exercise: Exercise) -> Bool {
        let today = Date()
        let calendar = Calendar.current
        if let last = lastWorkout, calendar.isDate(last, inSameDayAs: today) {
            lastWorkout = today
            return false
        } else {
            lastWorkout = today
            return true
        }
    }
    
    var name: String         // "Heavy Day"
    var exercises: [String]
    
    /// Names from exercises that default to inactive.
    var optional: [String]
    
    /// True for workouts that are typically performed on a certain day, eg the push day for a
    /// push/pull program. False for stuff like a mobility or cardio workout that can be
    /// performed at any time.
    var scheduled: Bool

    private var lastWorkout: Date?
}
