//  Created by Jesse Jones on 10/6/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import AVFoundation // for kSystemSoundID_Vibrate
import Foundation
import UIKit           // for UIColor
import os.log

/// Exercise is performed for a specified duration.
class TimedSubType: ExerciseInfo {
    private typealias `Self` = TimedSubType
    
    class Result: BaseResult, Storable {
        init(_ tag: ResultTag, weight: Double, currentTime: Int) {
            self.weight = weight
            self.currentTime = currentTime
            super.init(tag)
        }
        
        required init(from store: Store) {
            self.weight = store.getDbl("weight")
            self.currentTime = store.getInt("currentTime")
            super.init(from: store)
        }
        
        override func save(_ store: Store) {
            store.addDbl("weight", weight)
            store.addInt("currentTime", currentTime)
            super.save(store)
        }
        
        var weight: Double
        var currentTime: Int
    }
    
    init(numSets: Int, currentTime: Int, targetTime: Int?) {
        self.weight = 0.0
        self.currentTime = currentTime
        
        self.numSets = numSets
        self.targetTime = targetTime
    }
    
    required init(from store: Store) {
        weight = store.getDbl("weight")
        currentTime = store.getInt("currentTime")
        
        self.numSets = store.getInt("numSets")
        let t = store.getInt("targetTime")
        self.targetTime = t > 0 ? t : nil
        
        self.currentWorkout = store.getStr("currentWorkout")
        self.activities = store.getObjArray("activities")
        self.index = store.getInt("index")
    }
    
    func save(_ store: Store) {
        store.addDbl("weight", weight)
        store.addInt("currentTime", currentTime)
        
        store.addInt("numSets", numSets)
        store.addInt("targetTime", targetTime ?? 0)
        
        store.addStr("currentWorkout", currentWorkout)
        store.addObjArray("activities", activities)
        store.addInt("index", index)
    }
    
    func sync(_ program: Program, _ savedExercise: Exercise) {
        switch savedExercise.type {
        case .body(let saved):
            switch saved.subtype {
            case .timed(let savedSubtype):
                weight = savedSubtype.weight
                currentTime = savedSubtype.currentTime
                if activities.count == savedSubtype.activities.count && program.findWorkout(savedSubtype.currentWorkout) != nil {
                    currentWorkout = savedSubtype.currentWorkout
                    index = savedSubtype.index
                }
            default: os_log("saved %@ subtype wasn't timed", savedExercise.name)
            }
        case .weights(let saved):
            switch saved.subtype {
            case .timed(let savedSubtype): weight = savedSubtype.weight; currentTime = savedSubtype.currentTime
            default: os_log("saved %@ subtype wasn't timed", savedExercise.name)
            }
        }
    }
    
    func errors() -> [String] {
        var problems: [String] = []
        if numSets <= 0 {
            problems += ["subtype.numSets should be greater than zero."]
        }
        return problems
    }
    
    // ---- ExerciseInfo ----------------------------------------------------------------------
    var state: ExerciseState {
        get {
            if activities.isEmpty {
                return .waiting
            } else if activities.count == 0 {
                return .error("There is nothing to do")
            } else if index == 0 {
                return .started
            } else if index == activities.count {
                return .finished
            } else {
                return .underway
            }
        }
    }
    
    func start(_ workout: Workout, _ exercise: Exercise) -> Exercise? {
        index = 0
        currentWorkout = workout.name
        updated(exercise)
        return nil
    }
    
    func clone() -> ExerciseInfo {
        let store = Store()
        store.addObj("self", self)
        let result: Self = store.getObj("self")
        return result
    }
    
    func updated(_ exercise: Exercise) {
        var subtitle = ""
        if let target = targetTime {
            subtitle = "Target is \(secsToStr(target))"
        }
        
        var w = ""
        var d = ""
        if weight > 0 {
            switch exercise.type {
            case .body(_): w = Weight.friendlyUnitsStr(weight)
            case .weights(let type):
                let c = Weight(weight, type.apparatus).closest()
                w = c.text
                d = c.plates
            }
        }
        
        activities = []
        for i in 0..<numSets {
            activities.append(Activity(
                title: "Set \(i+1) of \(numSets)",
                subtitle: subtitle,
                amount: w,
                details: d,
                buttonName: "Start",
                showStartButton: true,
                color: nil))
        }
    }
    
    func on(_ workout: Workout) -> Bool {
        return currentWorkout == workout.name
    }
    
    func label(_ exercise: Exercise) -> String {
        return exercise.name
    }
    
    func sublabel(_ exercise: Exercise) -> String {
        return secsToStr(currentTime)
    }
    
    func prevLabel(_ exercise: Exercise) -> (String, UIColor) {
        if let myResults = Self.results[exercise.formalName], let last = myResults.last {
            var count = 0
            for result in myResults.reversed() {
                if result.tag == last.tag {
                    count += 1
                } else {
                    break
                }
            }
            if count > 1 {
                return ("Previous was \(last.tag) x\(count)", UIColor.black)
            } else {
                return ("Previous was \(last.tag)", UIColor.black)
            }
        } else {
            return ("", UIColor.black)
        }
    }
    
    func historyLabel(_ exercise: Exercise) -> String {
        if let myResults = Self.results[exercise.formalName] {
            let labels = myResults.map {($0.weight > 0.0 ? secsToStr($0.currentTime) + " @ " + Weight.friendlyUnitsStr($0.weight) : secsToStr($0.currentTime))}
            return makeHistoryFromLabels(labels)
        }
        return ""
    }
    
    func current(_ exercise: Exercise) -> Activity {
        return index < activities.count ? activities[index] : activities.last!
    }
    
    func restSecs() -> RestTime {
        return RestTime(autoStart: true, secs: currentTime)
    }
    
    func restSound() -> UInt32 {
        return 1007       // see http://iphonedevwiki.net/index.php/AudioServices
    }
    
    func completions(_ exercise: Exercise) -> [Completion] {
        if index+1 < activities.count {
            return [Completion(title: "", info: "", callback: {_,completion in self.index += 1; completion()})]
        } else {
            return [Completion(title: "", info: "", callback: {_,completion in self.index = self.activities.count; completion()})]
        }
    }
    
    func finalize(_ exercise: Exercise, _ view: UIViewController, _ completion: @escaping () -> Void) {
        let result = Result(.normal, weight: weight, currentTime: currentTime)
        
        var myResults = Self.results[exercise.formalName] ?? []
        myResults.append(result)
        Self.results[exercise.formalName] = myResults
        
        completion()
    }
    
    func reset() {
        index = 0   // TODO: probably want some sort of modifiedOn field somewhere
    }
    
    var numSets: Int
    var targetTime: Int?
    
    static var results: [String: [Result]] = [:]
    
    var weight: Double         // starts out at 0.0
    var currentTime: Int
    
    private var activities: [Activity] = []
    private var currentWorkout = ""
    private var index: Int = 0
}

func addStrDict(_ store: Store, _ key: String, _ value: [String: [Storable]]) {
    store.addStrArray(key + "-keys", Array(value.keys))
    store.addIntArray(key + "-counts", Array(value.keys.map {value[$0]?.count ?? 0}))
    
    var entries: [Storable] = []
    let count = value.keys.reduce(0, {$0 + (value[$1]?.count ?? 0)})
    entries.reserveCapacity(count)
    
    for (_, items) in value {
        entries.append(contentsOf: items)
    }
    
    store.addObjArray(key + "-values", entries)
}

func getStrDict<T: Storable>(_ store: Store, _ key: String) -> [String: [T]] {
    let keys = store.getStrArray(key + "-keys")
    let counts = store.getIntArray(key + "-counts")
    let entries: [T] = store.getObjArray(key + "-values")
    var index = 0
    
    var results: [String: [T]] = [:]
    for (i, k) in keys.enumerated() {
        let count = counts[i]
        
        var items: [T] = []
        items.reserveCapacity(count)
        for _ in 0..<count {
            items.append(entries[index])
            index += 1
        }
        
        results[k] = items
    }
    
    return results
}

func makeHistoryFromLabels(_ labels: [String]) -> String {
    var entries: [String] = []
    var i = labels.count - 1
    while entries.count < 4 && i >= 0 {
        var count = 0
        while i-count >= 0 && labels[i-count] == labels[i] {
            count += 1
        }
        assert(count >= 1, "count is \(count) in makeHistoryFromLabels with \(labels)")
        
        if count == 1 {
            entries.append(labels[i])
        } else {
            entries.append(labels[i] + " x\(count)")
        }
        i -= count
    }
    
    return entries.joined(separator: ", ")
}

func advanceWeightLabel(_ exercise: Exercise, _ weight: Double, by: Int) -> String {
    switch exercise.type {
    case .body(_):
        assert(false)
        abort()
    case .weights(let type):
        let currentWeight = Weight(weight, type.apparatus).closest().weight
        
        var newWeight = currentWeight
        if by > 0 {
            for _ in 0..<by {
                newWeight = Weight(newWeight, type.apparatus).nextWeight()
            }
        } else {
            for _ in 0..<(-by) {
                newWeight = Weight(newWeight, type.apparatus).prevWeight()
            }
        }
        let delta = newWeight - currentWeight
        
        return Weight.friendlyUnitsStr(delta)
    }
}
