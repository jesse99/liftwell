//  Created by Jesse Jones on 10/6/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import AVFoundation // for kSystemSoundID_Vibrate
import Foundation
import UIKit           // for UIColor
import os.log

/// Base class for Subtypes that use an apparatus.
class ApparatusSubtype {
    class BaseSetting: Storable {
        init(reps: Int, restTime: Int) {
            self.weight = 100.0     // TODO: start at 0.0
            self.reps = reps
            self.restTime = restTime
        }
        
        required init(from store: Store) {
            weight = store.getDbl("weight")
            reps = store.getInt("reps")
            restTime = store.getInt("restTime")
        }
        
        func save(_ store: Store) {
            store.addDbl("weight", weight)
            store.addInt("reps", reps)
            store.addInt("restTime", restTime)
        }
        
        var weight: Double      // starts out at 0.0
        var reps: Int           // this only applies when minReps < maxReps, also this can be less than minReps
        var restTime: Int
    }
    
    init() {
    }
    
    required init(from store: Store) {
        self.currentWorkout = store.getStr("currentWorkout")
        self.activities = store.getObjArray("activities")
        self.numWarmups = store.getInt("numWarmups")
        self.index = store.getInt("index")
    }
    
    func save(_ store: Store) {
        store.addStr("currentWorkout", currentWorkout)
        store.addObjArray("activities", activities) // TODO: generate
        store.addInt("numWarmups", numWarmups)
        store.addInt("index", index)
    }
    
    func historyLabel(_ history: [(Int, Double)]) -> String {
        var labels: [String] = []
        
        for (reps, weight) in history {
            if reps == 1 {
                labels.append("1 @ \(Weight.friendlyUnitsStr(weight))")
            } else {
                labels.append("\(reps) @ \(Weight.friendlyUnitsStr(weight))")
            }
        }
        
        return makeHistoryFromLabels(labels)
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
    
    func on(_ workout: Workout) -> Bool {
        return currentWorkout == workout.name
    }
    
    func label(_ exercise: Exercise) -> String {
        return exercise.name
    }
    
    func current(_ exercise: Exercise) -> Activity {
        return index < activities.count ? activities[index] : activities.last!
    }
    
    func restSecs() -> RestTime {
        return RestTime(autoStart: index > numWarmups, secs: getSetting().restTime)
    }
    
    func restSound() -> UInt32 {
        return kSystemSoundID_Vibrate
    }
    
    func completions(_ exercise: Exercise) -> [Completion] {
        if index+1 < activities.count {
            return [Completion(title: "", info: "", callback: {self.index += 1})]
        } else {
            return [Completion(title: "", info: "", callback: {self.index = self.activities.count})]
        }
    }
    
    func finalize(_ exercise: Exercise, _ tag: ResultTag, _ view: UIViewController, _ completion: @escaping () -> Void) {
        switch exercise.type {
        case .body(_): completion()
        case .weights(let type):
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
            
            let advance2 = UIAlertAction(title: "Advance x2", style: .default) {_ in self.doAdvance(type.setting.apparatus, 2); completion()}
            let advance = UIAlertAction(title: "Advance", style: .default) {_ in self.doAdvance(type.setting.apparatus, 1); completion()}
            let maintain = UIAlertAction(title: "Maintain", style: .default) {_ in completion()}
            let deload = UIAlertAction(title: "Deload", style: .default) {_ in self.doAdvance(type.setting.apparatus, -1); completion()}
            let deload2 = UIAlertAction(title: "Deload x2", style: .default) {_ in self.doAdvance(type.setting.apparatus, -2); completion()}
            
            switch tag {
            case .easy:
                alert.addAction(advance2)
                alert.addAction(advance)
                alert.addAction(maintain)
                alert.preferredAction = advance2
                
            case .normal:
                alert.addAction(advance)
                alert.addAction(maintain)
                alert.preferredAction = advance
                
            case .hard:
                alert.addAction(advance)
                alert.addAction(maintain)
                alert.addAction(deload)
                alert.preferredAction = maintain
                
            case .failed:
                alert.addAction(advance)
                alert.addAction(maintain)
                alert.addAction(deload)
                alert.addAction(deload2)
                alert.preferredAction = deload
            }
            
            view.present(alert, animated: true, completion: nil)
        }
    }
    
    func reset() {
        index = 0
    }
    
    fileprivate func getBaseRepRange() -> (Int, Int) {
        assert(false)   // subclasses implement this
        return (0, 0)
    }
    
    private func doAdvance(_ apparatus: Apparatus, _ amount: Int) {
        let (min, max) = getBaseRepRange()
        let delta = amount.signum()
        let setting = getSetting()
        for _ in 0..<abs(amount) {
            if setting.reps + delta > max {
                let w = Weight(setting.weight, apparatus)
                setting.reps = min
                setting.weight = w.nextWeight()
            } else if setting.reps + delta < min {
                let w = Weight(setting.weight, apparatus)
                setting.reps = max
                setting.weight = w.prevWeight()
            } else {
                setting.reps += delta
            }
        }
    }
    
    fileprivate func getSetting() -> BaseSetting {
        assert(false)   // subclasses implement this
        abort()
    }
    
    fileprivate var currentWorkout = ""
    fileprivate var activities: [Activity] = []
    fileprivate var numWarmups: Int = 0
    fileprivate var index: Int = 0
}

class CyclicRepsSubtype: ApparatusSubtype, ExerciseInfo {
    private typealias `Self` = CyclicRepsSubtype

    class Result: BaseResult, Storable {
        init(_ tag: ResultTag, weight: Double, cycleIndex: Int, reps: Int) {
            self.weight = weight
            self.cycleIndex = cycleIndex
            self.reps = reps
            super.init(tag)
        }
        
        required init(from store: Store) {
            self.weight = store.getDbl("weight")
            self.cycleIndex = store.getInt("cycleIndex")
            self.reps = store.getInt("reps")
            super.init(from: store)
        }

        override func save(_ store: Store) {
            store.addDbl("weight", weight)
            store.addInt("cycleIndex", cycleIndex)
            store.addInt("reps", reps)
            super.save(store)
        }

        var weight: Double
        var cycleIndex: Int
        var reps: Int
    }

    class Setting: BaseSetting {
        override init(reps: Int, restTime: Int) {
            self.cycleIndex = 0
            super.init(reps: reps, restTime: restTime)
        }
        
        required init(from store: Store) {
            cycleIndex = store.getInt("cycleIndex")
            super.init(from: store)
        }
        
        override func save(_ store: Store) {
            super.save(store)
            store.addInt("cycleIndex", cycleIndex)
        }
        
        var cycleIndex: Int
    }
    
    init(cycles: [Sets], reps: Int, restSecs: Int) {
        self.cycles = cycles
        self.defaultSetting = CyclicRepsSubtype.Setting(reps: reps, restTime: restSecs)
        self.setting = defaultSetting
        
        super.init()
    }
    
    required init(from store: Store) {
        cycles = []
        let count = store.getInt("cyclesCount")
        for i in 0..<count {
            let cycle: Sets = store.getObj("cycle\(i)")
            cycles.append(cycle)
        }
        self.defaultSetting = store.getObj("defaultSetting")
        self.setting = defaultSetting
        
        super.init(from: store)
    }
    
    override func save(_ store: Store) {
        store.addInt("cyclesCount", cycles.count)
        for (i, cycle) in cycles.enumerated() {
            store.addObj("cycle\(i)", cycle)
        }
        store.addObj("defaultSetting", defaultSetting)
        
        super.save(store)
    }
    
    public func errors() -> [String] {
        var problems: [String] = []
        for sets in cycles {
            problems += sets.errors()
        }
        return problems
    }

    // ---- ExerciseInfo ----------------------------------------------------------------------
    func start(_ workout: Workout, _ exercise: Exercise) -> Exercise? {
        index = 0
        currentWorkout = workout.name
        updated(exercise)
        return nil
    }
    
    func updated(_ exercise: Exercise) {
        switch exercise.type {
        case .body(_): (numWarmups, activities) = cycles[setting.cycleIndex].activities(setting.weight, minimum: setting.reps)
        case .weights(let type): (numWarmups, activities) = cycles[setting.cycleIndex].activities(setting.weight, type.setting.apparatus, minimum: setting.reps)
        }
    }
    
    func sublabel(_ exercise: Exercise) -> String {
        switch exercise.type {
        case .body(_): return cycles[setting.cycleIndex].sublabel(nil, setting.weight, setting.reps)
        case .weights(let type): return cycles[setting.cycleIndex].sublabel(type.setting.apparatus, setting.weight, setting.reps)
        }
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
            let history = myResults.map {($0.reps, $0.weight)}
            return historyLabel(history)
        }
        return ""
    }
    
    override func finalize(_ exercise: Exercise, _ tag: ResultTag, _ view: UIViewController, _ completion: @escaping () -> Void) {
        let result = Result(tag, weight: setting.weight, cycleIndex: setting.cycleIndex, reps: setting.reps)
        
        var myResults = Self.results[exercise.formalName] ?? []
        myResults.append(result)
        Self.results[exercise.formalName] = myResults
        
        super.finalize(exercise, tag, view, completion)
    }
    
    fileprivate override func getBaseRepRange() -> (Int, Int) {
        return cycles[setting.cycleIndex].repRange(minimum: nil)
    }
    
    fileprivate override func getSetting() -> BaseSetting {
        return setting
    }

    var cycles: [Sets]
    var setting: Setting
    private var defaultSetting: Setting
    static var results: [String: [Result]] = [:]
}

/// As many reps as possible for each set.
class MaxRepsSubType: ExerciseInfo {
    private typealias `Self` = MaxRepsSubType
    
    class Result: BaseResult, Storable {
        init(_ tag: ResultTag, weight: Double, currentReps: Int, completed: [Int]) {
            self.weight = weight
            self.currentReps = currentReps
            self.completed = completed
            super.init(tag)
        }
        
        required init(from store: Store) {
            self.weight = store.getDbl("weight")
            self.currentReps = store.getInt("currentReps")
            self.completed = store.getIntArray("completed")
            super.init(from: store)
        }
        
        override func save(_ store: Store) {
            store.addDbl("weight", weight)
            store.addInt("currentReps", currentReps)
            store.addIntArray("completed", completed)
            super.save(store)
        }
        
        var weight: Double
        var currentReps: Int
        var completed: [Int] = []
    }
    
    class Setting: Storable {
        init(currentReps: Int, restSecs: Int) {
            self.weight = 0.0
            self.currentReps = currentReps
            self.restTime = restSecs
        }
        
        required init(from store: Store) {
            weight = store.getDbl("weight")
            currentReps = store.getInt("currentReps")
            restTime = store.getInt("restTime")
        }
        
        func save(_ store: Store) {
            store.addDbl("weight", weight)
            store.addInt("currentReps", currentReps)
            store.addInt("restTime", restTime)
        }
        
        var weight: Double      // starts out at 0.0
        var currentReps: Int
        var restTime: Int
    }
    
    init(numSets: Int, goalReps: Int, restSecs: Int, restAtEnd: Bool) {
        self.numSets = numSets
        self.goalReps = goalReps
        self.restAtEnd = restAtEnd
        
        self.defaultSetting = Setting(currentReps: 5*numSets, restSecs: restSecs)
        self.setting = defaultSetting
    }
    
    required init(from store: Store) {
        self.numSets = store.getInt("numSets")
        self.goalReps = store.getInt("goalReps")
        self.restAtEnd = store.getBool("restAtEnd")
        self.completed = store.getIntArray("completed")

        self.currentWorkout = store.getStr("currentWorkout")
        self.setIndex = store.getInt("setIndex")
        
        self.defaultSetting = store.getObj("defaultSetting")
        self.setting = defaultSetting
    }
    
    func save(_ store: Store) {
        store.addInt("numSets", numSets)
        store.addInt("goalReps", goalReps)
        store.addBool("restAtEnd", restAtEnd)
        store.addIntArray("completed", completed)

        store.addStr("currentWorkout", currentWorkout)
        store.addInt("setIndex", setIndex)
        
        store.addObj("defaultSetting", defaultSetting)
    }
    
    public func errors() -> [String] {
        var problems: [String] = []
        if goalReps <= 0 {
            problems += ["subtype.goalReps should be greater than zero."]
        }
        return problems
    }
    
    // ---- ExerciseInfo ----------------------------------------------------------------------
    var state: ExerciseState {
        get {
            if numSets == 0 {
                return .error("There is nothing to do")
            } else if setIndex == 0 {
                return .started
            } else if setIndex == numSets {
                return .finished
            } else {
                return .underway
            }
        }
    }
    
    func start(_ workout: Workout, _ exercise: Exercise) -> Exercise? {
        setIndex = 0
        completed = []
        currentWorkout = workout.name
        return nil
    }
    
    func updated(_ exercise: Exercise) {
    }

    func on(_ workout: Workout) -> Bool {
        return currentWorkout == workout.name
    }
    
    func label(_ exercise: Exercise) -> String {
        return exercise.name
    }
    
    func sublabel(_ exercise: Exercise) -> String {
        let w = weightStr(exercise)
        if w.isEmpty {
            return "\(setting.currentReps) reps"
        } else {
            return "\(setting.currentReps) reps @ \(w)"
        }
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
        func makeLabel(_ result: Result) -> String {
            let reps = result.completed.map {"\($0)"}
            let sum = result.completed.reduce(0, {$0 + $1})
            var label = reps.joined(separator: ", ")
            if result.weight > 0.0 {
                label += " @ \(Weight.friendlyUnitsStr(result.weight))"
            }
            label += " (\(sum))"
            return label
        }
        
        var label = ""
        
        if let myResults = Self.results[exercise.formalName] {
            let count = myResults.count
            if count >= 1 {
                label = makeLabel(myResults[count - 1])
            }
            if count >= 2 {
                label += " and " + makeLabel(myResults[count - 2])
            }
            if count >= 3 {
                label += " and " + makeLabel(myResults[count - 3])
            }
        }
        
        return label
    }
    
    func current(_ exercise: Exercise) -> Activity {
        let currentTotal = completed.reduce(0, {$0 + $1})
        let expected = completed.count < numSets ? (setting.currentReps - currentTotal)/(numSets - completed.count) : 0
        let st = (setIndex+1 <= numSets ? "\(expected > 0 ? expected : 1)+ " : "") + "(\(setting.currentReps)) reps"

        let tt = setIndex+1 <= numSets ? "Set \(setIndex+1) of \(numSets)" : "Set \(numSets) of \(numSets)"
        
        let wt = weightStr(exercise)
        let r = completed.map({"\($0)"})
        let dt = (!completed.isEmpty ? r.joined(separator: ", ") + "" : "") + " (\(currentTotal)) reps"
        return Activity(
            title: tt,
            subtitle: st,
            amount: wt,
            details: currentTotal > 0 ? dt : "",
            buttonName: setIndex+1 > numSets ? "Done" : "Next",
            showStartButton: true,
            color: nil)
    }
    
    func restSecs() -> RestTime {
        return RestTime(autoStart: true, secs: setting.restTime)
    }
    
    func restSound() -> UInt32 {
        return kSystemSoundID_Vibrate
    }
    
    func completions(_ exercise: Exercise) -> [Completion] {
        let currentTotal = completed.reduce(0, {$0 + $1})
        let expected = (setting.currentReps - currentTotal)/(numSets - completed.count)
        
        var result: [Completion] = []
        for count in max(expected - 4, 0)...(expected+4) {
            if count <= expected {
                if count == 1 {
                    result.append(Completion(title: "1 rep", info: "", callback: {() -> Void in self.doCompleted(count)}))
                } else {
                    result.append(Completion(title: "\(count) reps", info: "", callback: {() -> Void in self.doCompleted(count)}))
                }
            } else {
                if currentTotal + count <= setting.currentReps {
                    result.append(Completion(title: "\(count) reps", info: "", callback: {() -> Void in self.doCompleted(count)}))
                } else {
                    result.append(Completion(title: "\(count) reps (extra)", info: "", callback: {() -> Void in self.doCompleted(count)}))
                }
            }
        }
        
        return result
    }
    
    func finalize(_ exercise: Exercise, _ tag: ResultTag, _ view: UIViewController, _ completion: @escaping () -> Void) {
        let result = Result(tag, weight: setting.weight, currentReps: setting.currentReps, completed: completed)

        var myResults = Self.results[exercise.formalName] ?? []
        myResults.append(result)
        Self.results[exercise.formalName] = myResults

        let sum = completed.reduce(0, {$0 + $1})
        if sum > setting.currentReps {
            switch tag {
            case .easy, .normal:
                setting.currentReps = sum
                completion()

            case .hard:
                let advance = UIAlertAction(title: "Advance", style: .default) {_ in self.setting.currentReps = sum; completion()}
                let maintain = UIAlertAction(title: "Maintain", style: .default) {_ in completion()}

                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
                alert.addAction(advance)
                alert.addAction(maintain)
                alert.preferredAction = maintain
                view.present(alert, animated: true, completion: nil)

            case .failed:
                completion()
            }
        } else {
            completion()
        }
    }
    
    func reset() {
        setIndex = 0
        completed = []
    }
    
    private func doCompleted(_ count: Int) {
        // TODO: update history (when finished)
        completed.append(count)
        setIndex += 1
    }
    
    private func weightStr(_ exercise: Exercise) -> String {
        if setting.weight > 0.0 {
            switch exercise.type {
            case .body(_): return Weight.friendlyUnitsStr(setting.weight)
            case .weights(let type):
                let w = Weight(setting.weight, type.setting.apparatus).closest()
                return w.text
            }
        } else {
            return ""
        }
    }

    var numSets: Int
    var goalReps: Int       // typically user would then switch to a harder version of the exercise or add weights
    var restAtEnd: Bool

    var completed: [Int] = []
    var setting: Setting
    private var defaultSetting: Setting
    static var results: [String: [Result]] = [:]

    private var currentWorkout = ""
    private var setIndex: Int = 0
}

/// Simple scheme where number of sets is fixed.
class RepsSubType: ApparatusSubtype, ExerciseInfo {
    private typealias `Self` = RepsSubType
    
    class Result: BaseResult, Storable {
        init(_ tag: ResultTag, weight: Double, reps: Int) {
            self.weight = weight
            self.reps = reps
            super.init(tag)
        }
        
        required init(from store: Store) {
            self.weight = store.getDbl("weight")
            self.reps = store.getInt("reps")
            super.init(from: store)
        }
        
        override func save(_ store: Store) {
            store.addDbl("weight", weight)
            store.addInt("reps", reps)
            super.save(store)
        }
        
        var weight: Double
        var reps: Int
    }
    
    init(sets: Sets, reps: Int, restSecs: Int) {
        self.sets = sets
        self.defaultSetting = BaseSetting(reps: reps, restTime: restSecs)
        self.setting = defaultSetting
        super.init()
    }
    
    required init(from store: Store) {
        self.sets = store.getObj("sets")
        self.defaultSetting = store.getObj("defaultSetting")
        self.setting = defaultSetting
        super.init(from: store)
    }
    
    override func save(_ store: Store) {
        store.addObj("sets", sets)
        store.addObj("defaultSetting", defaultSetting)
        super.save(store)
    }
    
    public func errors() -> [String] {
        return sets.errors()
    }
    
    // ---- ExerciseInfo ----------------------------------------------------------------------
    func start(_ workout: Workout, _ exercise: Exercise) -> Exercise? {
        index = 0
        currentWorkout = workout.name
        updated(exercise)
        return nil
    }
    
    func updated(_ exercise: Exercise) {
        switch exercise.type {
        case .body(_): (numWarmups, activities) = sets.activities(setting.weight, minimum: setting.reps)
        case .weights(let type): (numWarmups, activities) = sets.activities(setting.weight, type.setting.apparatus, minimum: setting.reps)
        }
    }
    
    func sublabel(_ exercise: Exercise) -> String {
        switch exercise.type {
        case .body(_): return sets.sublabel(nil, setting.weight, setting.reps)
        case .weights(let type): return sets.sublabel(type.setting.apparatus, setting.weight, setting.reps)
        }
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
            let history = myResults.map {($0.reps, $0.weight)}
            return historyLabel(history)
        }
        return ""
    }
    
    override func finalize(_ exercise: Exercise, _ tag: ResultTag, _ view: UIViewController, _ completion: @escaping () -> Void) {
        let result = Result(tag, weight: setting.weight, reps: setting.reps)
        
        var myResults = Self.results[exercise.formalName] ?? []
        myResults.append(result)
        Self.results[exercise.formalName] = myResults

        super.finalize(exercise, tag, view, completion )
    }
    
    fileprivate override func getBaseRepRange() -> (Int, Int) {
        return sets.repRange(minimum: nil)
    }
    
    fileprivate override func getSetting() -> BaseSetting {
        return setting
    }

    var sets: Sets
    var setting: BaseSetting
    private var defaultSetting: BaseSetting
    static var results: [String: [Result]] = [:]
}

// Exercise is performed for a specified duration.
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
    
    class Setting: Storable {
        init(currentTime: Int) {
            self.weight = 0.0
            self.currentTime = currentTime
        }
        
        required init(from store: Store) {
            weight = store.getDbl("weight")
            currentTime = store.getInt("currentTime")
        }
        
        func save(_ store: Store) {
            store.addDbl("weight", weight)
            store.addInt("currentTime", currentTime)
        }
        
        var weight: Double         // starts out at 0.0
        var currentTime: Int
    }
    
    init(numSets: Int, currentTime: Int, targetTime: Int?) {
        self.numSets = numSets
        self.targetTime = targetTime
        
        self.defaultSetting = Setting(currentTime: currentTime)
        self.setting = defaultSetting
    }
    
    required init(from store: Store) {
        self.numSets = store.getInt("numSets")
        let t = store.getInt("targetTime")
        self.targetTime = t > 0 ? t : nil
        
        self.currentWorkout = store.getStr("currentWorkout")
        self.activities = store.getObjArray("activities")
        self.index = store.getInt("index")
        
        self.defaultSetting = store.getObj("defaultSetting")
        self.setting = defaultSetting
    }
    
    func save(_ store: Store) {
        store.addInt("numSets", numSets)
        store.addInt("targetTime", targetTime ?? 0)
        
        store.addStr("currentWorkout", currentWorkout)
        store.addObjArray("activities", activities)
        store.addInt("index", index)
        
        store.addObj("defaultSetting", defaultSetting)
    }
    
    public func errors() -> [String] {
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
    
    func updated(_ exercise: Exercise) {
        var subtitle = ""
        if let target = targetTime {
            subtitle = "Target is \(secsToStr(target))"
        }
        
        var w = ""
        var d = ""
        if setting.weight > 0 {
            switch exercise.type {
            case .body(_): w = Weight.friendlyUnitsStr(setting.weight)
            case .weights(let type):
                let c = Weight(setting.weight, type.setting.apparatus).closest()
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
        return secsToStr(setting.currentTime)
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
        return RestTime(autoStart: true, secs: setting.currentTime)
    }
    
    func restSound() -> UInt32 {
        return 1007       // see http://iphonedevwiki.net/index.php/AudioServices
    }
    
    func completions(_ exercise: Exercise) -> [Completion] {
        if index+1 < activities.count {
            return [Completion(title: "", info: "", callback: {self.index += 1})]
        } else {
            return [Completion(title: "", info: "", callback: {self.index = self.activities.count})]
        }
    }
    
    func finalize(_ exercise: Exercise, _ tag: ResultTag, _ view: UIViewController, _ completion: @escaping () -> Void) {
        let result = Result(tag, weight: setting.weight, currentTime: setting.currentTime)
        
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
    
    var setting: Setting
    private var defaultSetting: Setting
    static var results: [String: [Result]] = [:]

    private var currentWorkout = ""
    private var activities: [Activity] = []
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

fileprivate func makeHistoryFromLabels(_ labels: [String]) -> String {
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
