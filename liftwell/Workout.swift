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
    }
    
    required init(from store: Store) {
        self.name = store.getStr("name")
        self.exercises = store.getStrArray("exercises")
        self.optional = store.getStrArray("optional")
        self.scheduled = store.getBool("scheduled", ifMissing: true)
    }
    
    func save(_ store: Store) {
        store.addStr("name", name)
        store.addStrArray("exercises", exercises)
        store.addStrArray("optional", optional)
        store.addBool("scheduled", scheduled)
    }
    
    var name: String         // "Heavy Day"
    var exercises: [String]
    
    /// Names from exercises that default to inactive.
    var optional: [String]
    
    /// True for workouts that are typically performed on a certain day, eg the push day for a
    /// push/pull program. False for stuff like a mobility or cardio workout that can be
    /// performed at any time.
    var scheduled: Bool
    
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
}
