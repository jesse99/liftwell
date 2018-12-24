//  Created by Jesse Jones on 10/1/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation
import os.log

class Program: Storable {
    enum Tags {
        case beginner       // weight is expected to increase each workout
        case intermediate   // weight increases each week
        case advanced       // weight takes longer than a week to increase
        
        case strength
        case hypertrophy
        case conditioning
        
        case gym
        case barbell
        case dumbbell
        case minimal
        
        case threeDays
        case fourDays
        case fiveDays
        case sixDays
        
        case unisex
        case female
        
        case ageUnder40
        case age40s
        case age50s
    }
    
    init(_ name: String, _ workouts: [Workout], _ exercises: [Exercise], _ tags: [Tags], _ description: String, maxWorkouts: Int?, nextProgram: String?) {
        self.name = name
        self.workouts = workouts
        self.exercises = exercises
        self.tags = Swift.Set(tags)
        self.description = description
        self.customNotes = [:]
        self.maxWorkouts = maxWorkouts
        self.nextProgram = nextProgram
        self.numWorkouts = 0
        self.dateStarted = nil
    }
    
    convenience init(_ name: String, _ workouts: [Workout], _ exercises: [Exercise], _ tags: [Tags], _ description: String) {
        self.init(name, workouts, exercises, tags, description, maxWorkouts: nil, nextProgram: nil)
    }
    
    func errors() -> [String] {
        var problems: [String] = []
        
        for w in workouts {
            problems += w.errors(self)
        }
        
        for e in exercises {
            problems += e.errors(self)
            
//            if builtInNotes[e.formalName] == nil && customNotes[e.formalName] == nil {
//                problems += ["exercise \(e.name) formalName (\(e.formalName)) is missing from notes"]
//            }
        }
        
        if let n = maxWorkouts {
            if n < 0 {
                problems += ["program.maxWorkouts is less than 0"]
            } else if n == 0 && nextProgram != nil {
                problems += ["program.nextProgram is set but maxWorkouts is 0"]
            } else if n > 0 && nextProgram == nil {
                problems += ["program.maxWorkouts is set but nextProgram isn't"]
            }
        } else {
            if nextProgram != nil {
                problems += ["program.nextProgram is set but maxWorkouts isn't"]
            }
        }
        
        if tags.contains(.beginner) && tags.contains(.intermediate) {
            problems += ["program.tags has both beginner and intermediate"]
        }
        if tags.contains(.beginner) && tags.contains(.advanced) {
            problems += ["program.tags has both beginner and advanced"]
        }
        if tags.contains(.intermediate) && tags.contains(.advanced) {
            problems += ["program.tags has both intermediate and advanced"]
        }
        
        if tags.contains(.strength) && tags.contains(.hypertrophy) {
            problems += ["program.tags has both strength and hypertrophy"]
        }
        if tags.contains(.hypertrophy) && tags.contains(.conditioning) {
            problems += ["program.tags has both hypertrophy and conditioning"]
        }
        
        if tags.contains(.gym) && tags.contains(.barbell) {
            problems += ["program.tags has both gym and barbell"]
        }
        if tags.contains(.gym) && tags.contains(.dumbbell) {
            problems += ["program.tags has both gym and dumbbell"]
        }
        if tags.contains(.gym) && tags.contains(.minimal) {
            problems += ["program.tags has both gym and minimal"]
        }
        
        if tags.contains(.barbell) && tags.contains(.dumbbell) {
            problems += ["program.tags has both barbell and dumbbell"]
        }
        if tags.contains(.barbell) && tags.contains(.minimal) {
            problems += ["program.tags has both barbell and minimal"]
        }
        
        if tags.contains(.dumbbell) && tags.contains(.minimal) {
            problems += ["program.tags has both dumbbell and minimal"]
        }
        
        if tags.contains(.unisex) && tags.contains(.female) {
            problems += ["program.tags has both unisex and female"]
        }
        
        return problems
    }
    
    required init(from store: Store) {
        self.name = store.getStr("name")
        self.workouts = store.getObjArray("workouts")
        self.exercises = store.getObjArray("exercises")
        self.tags = Swift.Set(store.getObjArray("tags"))
        self.description = store.getStr("description")
        self.numWorkouts = store.getInt("numWorkouts")
        
        if store.hasKey("dateStarted") {
            self.dateStarted = store.getDate("dateStarted")
        } else {
            self.dateStarted = nil
        }
        
        self.customNotes = [:]
        let customNames = store.getStrArray("custom-names", ifMissing: [])
        let customText = store.getStrArray("custom-text", ifMissing: [])
        for (i, name) in customNames.enumerated() {
            customNotes[name] = customText[i]
        }
        
        if store.hasKey("maxWorkouts") {
            self.maxWorkouts = store.getInt("maxWorkouts")
        } else {
            self.maxWorkouts = nil
        }
        
        if store.hasKey("nextProgram") {
            self.nextProgram = store.getStr("nextProgram")
        } else {
            self.nextProgram = nil
        }
    }
    
    func save(_ store: Store) {
        store.addStr("name", name)
        store.addObjArray("workouts", workouts)
        store.addObjArray("exercises", exercises)
        store.addObjArray("tags", Array(tags))
        store.addStr("description", description)
        store.addStrArray("custom-names", Array(customNotes.keys))
        store.addStrArray("custom-text", Array(customNotes.values))

        if let maxWorkouts = self.maxWorkouts {
            store.addInt("maxWorkouts", maxWorkouts)
        }
        if let nextProgram = self.nextProgram {
            store.addStr("nextProgram", nextProgram)
        }
        store.addInt("numWorkouts", numWorkouts)
        if let d = dateStarted {
            store.addDate("dateStarted", d)
        }
    }
    
    // This is called when a built-in program is loaded. What we do is use the built-in program but use the settings that
    // were saved.
    func sync(_ savedProgram: Program) {
        for workout in workouts {
            if let savedWorkout = savedProgram.findWorkout(workout.name) {
                workout.sync(savedWorkout)
            }
        }

        for exercise in exercises {
            if let savedExercise = savedProgram.findExercise(exercise.name) {
                exercise.sync(savedExercise)
                
                switch exercise.type {
                case .body(let type): type.sync(self, savedExercise)
                case .weights(let type): type.sync(self, savedExercise)
                }
            }
        }
        
        customNotes = savedProgram.customNotes
        dateStarted = savedProgram.dateStarted
        numWorkouts = savedProgram.numWorkouts
    }
    
    func findWorkout(_ name: String) -> Workout? {
        return workouts.first {$0.name == name}
    }
    
    func findExercise(_ name: String) -> Exercise? {
        return exercises.first {$0.name == name}
    }
    
    func isInUse(_ exercise: Exercise) -> Bool {
        for workout in workouts {
            if workout.exercises.contains(exercise.name) && !workout.optional.contains(exercise.name) {
                return true
            }
        }
        return false
    }
    
    func incrementWorkouts() {
        numWorkouts += 1
        if dateStarted == nil {
            dateStarted = Date()
        }
    }

//    func setExercise(_ exercise: Exercise) {
//        if let index = exercises.index(where: {$0.name == exercise.name}) {
//            exercises[index] = exercise
//        } else {
//            exercises.append(exercise)
//        }
//    }
    
    var name: String             // "Mad Cow"
    var workouts: [Workout]
    var exercises: [Exercise]
    var tags: Swift.Set<Tags>
    var description: String
    
    var maxWorkouts: Int?    // number of workouts that the user is expected to perform before switching to a new program
    var nextProgram: String? // if the program has a well defined successor than it should be listed here
    
    var customNotes: [String: String]       // formal name => markdown
    private(set) var dateStarted: Date?     // will change if the user is switching between programs, TODO: do that
    private(set) var numWorkouts: Int       // number of workouts user has done (not neccesarily completed workouts because that gets complicated)
}

extension Program.Tags: Storable {
    init(from store: Store) {
        let tname = store.getStr("tag")
        switch tname {
        case "beginner": self = .beginner
        case "intermediate": self = .intermediate
        case "advanced": self = .advanced
            
        case "strength": self = .strength
        case "hypertrophy": self = .hypertrophy
        case "conditioning": self = .conditioning
            
        case "threeDays": self = .threeDays
        case "fourDays": self = .fourDays
        case "fiveDays": self = .fiveDays
        case "sixDays": self = .sixDays
            
        case "gym": self = .gym
        case "barbell": self = .barbell
        case "dumbbell": self = .dumbbell
        case "minimal": self = .minimal
            
        case "unisex": self = .unisex
        case "female": self = .female
            
        case "ageUnder40": self = .ageUnder40
        case "age40s": self = .age40s
        case "age50s": self = .age50s
            
        default: assert(false, "loading program had unknown tag: \(tname)"); abort()
        }
    }
    
    func save(_ store: Store) {
        switch self {
        case .beginner: store.addStr("tag", "beginner")
        case .intermediate: store.addStr("tag", "intermediate")
        case .advanced: store.addStr("tag", "advanced")
            
        case .strength: store.addStr("tag", "strength")
        case .hypertrophy: store.addStr("tag", "hypertrophy")
        case .conditioning: store.addStr("tag", "conditioning")
            
        case .threeDays: store.addStr("tag", "threeDays")
        case .fourDays: store.addStr("tag", "fourDays")
        case .fiveDays: store.addStr("tag", "fiveDays")
        case .sixDays: store.addStr("tag", "sixDays")
            
        case .gym: store.addStr("tag", "gym")
        case .barbell: store.addStr("tag", "barbell")
        case .dumbbell: store.addStr("tag", "dumbbell")
        case .minimal: store.addStr("tag", "minimal")
            
        case .unisex: store.addStr("tag", "unisex")
        case .female: store.addStr("tag", "female")
            
        case .ageUnder40: store.addStr("tag", "ageUnder40")
        case .age40s: store.addStr("tag", "age40s")
        case .age50s: store.addStr("tag", "age50s")
        }
    }
}
