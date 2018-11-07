//  Created by Jesse Jones on 10/6/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import AVFoundation // for kSystemSoundID_Vibrate
import Foundation
import UIKit           // for UIColor
import os.log

/// Base class for Subtypes that use an apparatus.
class ApparatusSubtype {
    init(reps: Int, restTime: Int) {
        self.weight = 0
        self.reps = reps
        self.restTime = restTime
    }
    
    required init(from store: Store) {
        weight = store.getDbl("weight")
        reps = store.getInt("reps")
        restTime = store.getInt("restTime")

        self.currentWorkout = store.getStr("currentWorkout")
        self.activities = store.getObjArray("activities")
        self.numWarmups = store.getInt("numWarmups")
        self.index = store.getInt("index")
    }
    
    func save(_ store: Store) {
        store.addDbl("weight", weight)
        store.addInt("reps", reps)
        store.addInt("restTime", restTime)

        store.addStr("currentWorkout", currentWorkout)
        store.addObjArray("activities", activities) // TODO: generate
        store.addInt("numWarmups", numWarmups)
        store.addInt("index", index)
    }
    
    func sync(_ program: Program, _ savedSubtype: ApparatusSubtype, sameSets: Bool) {
        weight = savedSubtype.weight
        reps = savedSubtype.reps
        restTime = savedSubtype.restTime
        
        if sameSets && program.findWorkout(savedSubtype.currentWorkout) != nil {
            currentWorkout = savedSubtype.currentWorkout
            index = savedSubtype.index
        }
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
            let (minReps, maxReps) = getBaseRepRange()
            let variableReps = minReps != maxReps
            
            let label4 = variableReps ? "4 reps" : advanceWeightLabel(exercise, weight, by: 4)
            let label3 = variableReps ? "3 reps" : advanceWeightLabel(exercise, weight, by: 3)
            let label2 = variableReps ? "2 reps" : advanceWeightLabel(exercise, weight, by: 2)
            let label1 = variableReps ? "1 rep" : advanceWeightLabel(exercise, weight, by: 1)
            let dlabel1 = variableReps ? "1 rep" : advanceWeightLabel(exercise, weight, by: -1)
            let dlabel2 = variableReps ? "2 reps" : advanceWeightLabel(exercise, weight, by: -2)
            let dlabel3 = variableReps ? "3 reps" : advanceWeightLabel(exercise, weight, by: -3)

            let advance4 = UIAlertAction(title: "Advance by \(label4)", style: .default) {_ in self.doAdvance(type.apparatus, 4); completion()}
            let advance3 = UIAlertAction(title: "Advance by \(label3)", style: .default) {_ in self.doAdvance(type.apparatus, 3); completion()}
            let advance2 = UIAlertAction(title: "Advance by \(label2)", style: .default) {_ in self.doAdvance(type.apparatus, 2); completion()}
            let advance = UIAlertAction(title: "Advance by \(label1)", style: .default) {_ in self.doAdvance(type.apparatus, 1); completion()}
            let maintain = UIAlertAction(title: "Maintain", style: .default) {_ in completion()}
            let deload = UIAlertAction(title: "Deload by \(dlabel1)", style: .default) {_ in self.doAdvance(type.apparatus, -1); completion()}
            let deload2 = UIAlertAction(title: "Deload by \(dlabel2)", style: .default) {_ in self.doAdvance(type.apparatus, -2); completion()}
            let deload3 = UIAlertAction(title: "Deload by \(dlabel3)", style: .default) {_ in self.doAdvance(type.apparatus, -3); completion()}
            
            switch tag {
            case .easy:
                alert.addAction(advance4)
                alert.addAction(advance3)
                alert.addAction(advance2)
                alert.addAction(advance)
                alert.addAction(maintain)
                alert.preferredAction = advance2
                
            case .normal:
                alert.addAction(advance2)
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
                alert.addAction(deload3)
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
        for _ in 0..<abs(amount) {
            if reps + delta > max {
                let w = Weight(weight, apparatus)
                reps = min
                weight = w.nextWeight()
            } else if reps + delta < min {
                let w = Weight(weight, apparatus)
                reps = max
                weight = w.prevWeight()
            } else {
                reps += delta
            }
        }
    }
    
    var weight: Double      // starts out at 0.0
    var reps: Int           // this only applies when minReps < maxReps, also this can be less than minReps
    var restTime: Int

    fileprivate var activities: [Activity] = []
    fileprivate var numWarmups: Int = 0
    fileprivate var currentWorkout = ""
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

    init(cycles: [Sets], reps: Int, restSecs: Int) {
        self.cycleIndex = 0
        self.cycles = cycles
        
        super.init(reps: reps, restTime: restSecs)
    }
    
    required init(from store: Store) {
        cycleIndex = store.getInt("cycleIndex")

        cycles = []
        let count = store.getInt("cyclesCount")
        for i in 0..<count {
            let cycle: Sets = store.getObj("cycle\(i)")
            cycles.append(cycle)
        }
        
        super.init(from: store)
    }
    
    override func save(_ store: Store) {
        store.addInt("cycleIndex", cycleIndex)

        store.addInt("cyclesCount", cycles.count)
        for (i, cycle) in cycles.enumerated() {
            store.addObj("cycle\(i)", cycle)
        }
        
        super.save(store)
    }
    
    func sync(_ program: Program, _ savedExercise: Exercise) {
        switch savedExercise.type {
        case .body(_):
            os_log("saved %@ subtype wasn't weights", savedExercise.name)
        case .weights(let saved):
            switch saved.subtype {
            case .cyclic(let savedSubtype):
                cycleIndex = savedSubtype.cycleIndex
                super.sync(program, savedSubtype, sameSets: cycles.count == savedSubtype.cycles.count)
            default:
                os_log("saved %@ subtype wasn't cyclic", savedExercise.name)
            }
        }
    }
    
    func errors() -> [String] {
        var problems: [String] = []
        for sets in cycles {
            problems += sets.errors()
        }
        return problems
    }

    // ---- ExerciseInfo ----------------------------------------------------------------------
    func start(_ workout: Workout, _ exercise: Exercise) -> Exercise? {
        if weight == 0 {
            let newExercise = exercise.clone()
            switch newExercise.type {
            case .weights(let type):
                let newSubtype = FindWeightSubType(reps: getBaseRepRange().1, restSecs: restTime)
                type.subtype = .find(newSubtype)
            default:
                break
            }
        }
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
        switch exercise.type {
        case .body(_): (numWarmups, activities) = cycles[cycleIndex].activities(weight, minimum: reps)
        case .weights(let type): (numWarmups, activities) = cycles[cycleIndex].activities(weight, type.apparatus, minimum: reps)
        }
    }
    
    func sublabel(_ exercise: Exercise) -> String {
        switch exercise.type {
        case .body(_): return cycles[cycleIndex].sublabel(nil, weight, reps)
        case .weights(let type): return cycles[cycleIndex].sublabel(type.apparatus, weight, reps)
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
    
    func restSecs() -> RestTime {
        // note that autoStart is only used after index is incremented
        return RestTime(autoStart: cycles[cycleIndex].sets[index > 0 ? index-1 : 0].rest, secs: restTime)
    }
    
    override func finalize(_ exercise: Exercise, _ tag: ResultTag, _ view: UIViewController, _ completion: @escaping () -> Void) {
        let result = Result(tag, weight: weight, cycleIndex: cycleIndex, reps: reps)
        
        var myResults = Self.results[exercise.formalName] ?? []
        myResults.append(result)
        Self.results[exercise.formalName] = myResults
        
        super.finalize(exercise, tag, view, completion)
    }
    
    fileprivate override func getBaseRepRange() -> (Int, Int) {
        return cycles[cycleIndex].repRange(minimum: nil)
    }
    
    var cycleIndex: Int

    var cycles: [Sets]
    static var results: [String: [Result]] = [:]
}

/// Used when weight is zero for a subtype with an apparatus.
class FindWeightSubType: ExerciseInfo {
    private typealias `Self` = FindWeightSubType
    
    init(reps: Int, restSecs: Int) {
        self.reps = reps
        self.restTime = restSecs
        self.weight = 0
        self.set = .notStarted
    }
    
    required init(from store: Store) {
        self.reps = store.getInt("reps")
        self.restTime = store.getInt("restTime")
        self.weight = store.getDbl("weight")

        let index = store.getInt("index")
        if index > 0 {
            self.set = .started(index)
        } else if index == 0 {
            self.set = .notStarted
        } else {
            self.set = .finished(-index)
        }
    }
    
    func save(_ store: Store) {
        store.addInt("reps", reps)
        store.addInt("restTime", restTime)
        store.addDbl("weight", weight)
        
        switch set {
        case .notStarted: store.addInt("index", 0)
        case .started(let index): store.addInt("index", index)
        case .finished(let index): store.addInt("index", -index)
        }
    }
    
    func sync(_ program: Program, _ savedExercise: Exercise) {
    }
    
    func errors() -> [String] {
        return []
    }
    
    // ---- ExerciseInfo ----------------------------------------------------------------------
    var state: ExerciseState {
        get {
            switch set {
            case .notStarted: return .waiting
            case .started(let index): return index == 1 ? .started : .underway
            case .finished(_): return .finishNoPrompt
            }
        }
    }
    
    func start(_ workout: Workout, _ exercise: Exercise) -> Exercise? {
        set = .started(1)
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
    }
    
    func on(_ workout: Workout) -> Bool {
        return currentWorkout == workout.name
    }
    
    func label(_ exercise: Exercise) -> String {
        return exercise.name
    }
    
    func sublabel(_ exercise: Exercise) -> String {
        return "no weight"
    }
    
    func prevLabel(_ exercise: Exercise) -> (String, UIColor) {
        return ("", UIColor.black)
    }
    
    func historyLabel(_ exercise: Exercise) -> String {
        return ""
    }
    
    func current(_ exercise: Exercise) -> Activity {
        let (index, finished) = getState()
        switch exercise.type {
        case .body(_):
            assert(false)
            abort()
        case .weights(let type):
            let currentWeight = Weight(weight, type.apparatus).closest()
            return Activity(
                title: "Set \(index)",
                subtitle: "",
                amount: "\(reps) @ \(currentWeight.text)",
                details: currentWeight.plates,
                buttonName: finished ? "Done" : "Next",
                showStartButton: true,
                color: nil)
        }
    }
    
    func restSecs() -> RestTime {
        return RestTime(autoStart: false, secs: restTime)
    }
    
    func restSound() -> UInt32 {
        return kSystemSoundID_Vibrate
    }
    
    func completions(_ exercise: Exercise) -> [Completion] {
        let (index, _) = getState()

        let label8 = advanceWeightLabel(exercise, weight, by: 8)
        let label4 = advanceWeightLabel(exercise, weight, by: 4)
        let label3 = advanceWeightLabel(exercise, weight, by: 3)
        let label2 = advanceWeightLabel(exercise, weight, by: 2)
        let label1 = advanceWeightLabel(exercise, weight, by: 1)
        return [Completion(title: "Advance by \(label8)", info: "", callback: {self.doAdvance(exercise, index, 8)}),
                Completion(title: "Advance by \(label4)", info: "", callback: {self.doAdvance(exercise, index, 4)}),
                Completion(title: "Advance by \(label3)", info: "", callback: {self.doAdvance(exercise, index, 3)}),
                Completion(title: "Advance by \(label2)", info: "", callback: {self.doAdvance(exercise, index, 2)}),
                Completion(title: "Advance by \(label1)", info: "", callback: {self.doAdvance(exercise, index, 1)}),
                Completion(title: "Done", info: "", callback: {self.set = .finished(index)})]
    }
    
    func finalize(_ exercise: Exercise, _ tag: ResultTag, _ view: UIViewController, _ completion: @escaping () -> Void) {
        let app = UIApplication.shared.delegate as! AppDelegate
        if let original = app.program.findExercise(exercise.name) {
            switch original.type {
            case .weights(let type):    // this is the only one with an apparatus
                switch type.subtype {
                case .cyclic(let subtype): subtype.weight = weight
                case .find(_): assert(false)
                case .reps(let subtype): subtype.weight = weight
                case .timed(let subtype): subtype.weight = weight
                }
            default:
                assert(false)
            }
        } else {
            assert(false)
        }
        completion()
    }
    
    func reset() {
        set = .started(1)
        weight = 0
    }
    
    private func doAdvance(_ exercise: Exercise, _ index: Int, _ amount: Int) {
        switch exercise.type {
        case .body(_):
            assert(false)
            abort()
        case .weights(let type):
            for _ in 0..<amount {
                weight = Weight(weight, type.apparatus).nextWeight()
            }
            set = .started(index + 1)
        }
    }
    
    private func getState() -> (Int, Bool) {
        switch set {
        case .notStarted: return (1, false)
        case .started(let index): return (index, false)
        case .finished(let index): return (index, true)
        }
    }
    
    private enum Set {
        case notStarted
        case started(Int)
        case finished(Int)
    }

    var weight: Double
    var reps: Int
    var restTime: Int
    private var set: Set
    private var currentWorkout = ""
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
    
    init(numSets: Int, goalReps: Int, restSecs: Int, restAtEnd: Bool) {
        self.weight = 0.0
        self.currentReps = 5*numSets
        self.restTime = restSecs

        self.numSets = numSets
        self.goalReps = goalReps
        self.restAtEnd = restAtEnd
    }
    
    required init(from store: Store) {
        weight = store.getDbl("weight")
        currentReps = store.getInt("currentReps")
        restTime = store.getInt("restTime")

        self.numSets = store.getInt("numSets")
        self.goalReps = store.getInt("goalReps")
        self.restAtEnd = store.getBool("restAtEnd")
        self.completed = store.getIntArray("completed")

        self.currentWorkout = store.getStr("currentWorkout")
        self.setIndex = store.getInt("setIndex")
    }
    
    func save(_ store: Store) {
        store.addDbl("weight", weight)
        store.addInt("currentReps", currentReps)
        store.addInt("restTime", restTime)

        store.addInt("numSets", numSets)
        store.addInt("goalReps", goalReps)
        store.addBool("restAtEnd", restAtEnd)
        store.addIntArray("completed", completed)

        store.addStr("currentWorkout", currentWorkout)
        store.addInt("setIndex", setIndex)
    }
    
    func sync(_ program: Program, _ savedExercise: Exercise) {
        switch savedExercise.type {
        case .body(let saved):
            switch saved.subtype {
            case .maxReps(let savedSubtype):
                weight = savedSubtype.weight
                currentReps = savedSubtype.currentReps
                restTime = savedSubtype.restTime
                if numSets == savedSubtype.numSets && program.findWorkout(savedSubtype.currentWorkout) != nil {
                    completed = savedSubtype.completed
                    currentWorkout = savedSubtype.currentWorkout
                    setIndex = savedSubtype.setIndex
                }

            default: os_log("saved %@ subtype wasn't maxReps", savedExercise.name)
            }
        case .weights(_):
            os_log("saved %@ subtype wasn't body", savedExercise.name)
        }
    }
    
    func errors() -> [String] {
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
    
    func clone() -> ExerciseInfo {
        let store = Store()
        store.addObj("self", self)
        let result: Self = store.getObj("self")
        return result
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
            return "\(currentReps) reps"
        } else {
            return "\(currentReps) reps @ \(w)"
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
        var expected = completed.count < numSets ? (currentReps - currentTotal)/(numSets - completed.count) : 0
        if currentTotal + (numSets - completed.count)*expected < currentReps {
            expected += 1
        }
        let st = (setIndex+1 <= numSets ? "\(expected > 0 ? expected : 1)+ " : "") + "(\(currentReps)) reps"

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
        return RestTime(autoStart: completed.count < numSets || restAtEnd, secs: restTime)
    }
    
    func restSound() -> UInt32 {
        return kSystemSoundID_Vibrate
    }
    
    func completions(_ exercise: Exercise) -> [Completion] {
        let currentTotal = completed.reduce(0, {$0 + $1})
        let expected = (currentReps - currentTotal)/(numSets - completed.count)
        
        var result: [Completion] = []
        for count in max(expected - 4, 0)...(expected+4) {
            if count <= expected {
                if count == 1 {
                    result.append(Completion(title: "1 rep", info: "", callback: {() -> Void in self.doCompleted(count)}))
                } else {
                    result.append(Completion(title: "\(count) reps", info: "", callback: {() -> Void in self.doCompleted(count)}))
                }
            } else {
                if currentTotal + count <= currentReps {
                    result.append(Completion(title: "\(count) reps", info: "", callback: {() -> Void in self.doCompleted(count)}))
                } else {
                    result.append(Completion(title: "\(count) reps (extra)", info: "", callback: {() -> Void in self.doCompleted(count)}))
                }
            }
        }
        
        return result
    }
    
    func finalize(_ exercise: Exercise, _ tag: ResultTag, _ view: UIViewController, _ completion: @escaping () -> Void) {
        let result = Result(tag, weight: weight, currentReps: currentReps, completed: completed)

        var myResults = Self.results[exercise.formalName] ?? []
        myResults.append(result)
        Self.results[exercise.formalName] = myResults

        let sum = completed.reduce(0, {$0 + $1})
        if sum > currentReps {
            switch tag {
            case .easy, .normal:
                currentReps = sum
                completion()

            case .hard:
                let advance = UIAlertAction(title: "Advance", style: .default) {_ in self.currentReps = sum; completion()}
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
        completed.append(count)
        setIndex += 1
    }
    
    private func weightStr(_ exercise: Exercise) -> String {
        if weight > 0.0 {
            switch exercise.type {
            case .body(_): return Weight.friendlyUnitsStr(weight)
            case .weights(let type):
                let w = Weight(weight, type.apparatus).closest()
                return w.text
            }
        } else {
            return ""
        }
    }

    var numSets: Int
    var goalReps: Int       // typically user would then switch to a harder version of the exercise or add weights
    var restAtEnd: Bool

    static var results: [String: [Result]] = [:]

    var weight: Double      // starts out at 0.0
    var currentReps: Int
    var restTime: Int

    var completed: [Int] = []
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
        super.init(reps: reps, restTime: restSecs)
    }
    
    required init(from store: Store) {
        self.sets = store.getObj("sets")
        super.init(from: store)
    }
    
    override func save(_ store: Store) {
        store.addObj("sets", sets)
        super.save(store)
    }
    
    func sync(_ program: Program, _ savedExercise: Exercise) {
        let exeExecercise = program.findExercise(savedExercise.name)
        let (_, exeActivities) = getActivities(exeExecercise ?? savedExercise)

        let (_, savedActivities) = getActivities(savedExercise)
        let same = exeActivities.count == savedActivities.count

        switch savedExercise.type {
        case .body(let saved):
            switch saved.subtype {
            case .reps(let savedSubtype): super.sync(program, savedSubtype, sameSets: same)
            default: os_log("saved %@ subtype wasn't Reps", savedExercise.name)
            }
        case .weights(let saved):
            switch saved.subtype {
            case .reps(let savedSubtype): super.sync(program, savedSubtype, sameSets: same)
            default: os_log("saved %@ subtype wasn't Reps", savedExercise.name)
            }
        }
    }
    
    func errors() -> [String] {
        return sets.errors()
    }
    
    // ---- ExerciseInfo ----------------------------------------------------------------------
    func start(_ workout: Workout, _ exercise: Exercise) -> Exercise? {
        if weight == 0 {
            let newExercise = exercise.clone()
            switch newExercise.type {
            case .weights(let type):
                let newSubtype = FindWeightSubType(reps: getBaseRepRange().1, restSecs: restTime)
                type.subtype = .find(newSubtype)
                return newExercise
            default:
                break
            }
        }
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
        (numWarmups, activities) = getActivities(exercise)
    }
    
    func sublabel(_ exercise: Exercise) -> String {
        switch exercise.type {
        case .body(_): return sets.sublabel(nil, weight, reps)
        case .weights(let type): return sets.sublabel(type.apparatus, weight, reps)
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
    
    func restSecs() -> RestTime {
        // note that autoStart is only used after index is incremented
        return RestTime(autoStart: sets.sets[index > 0 ? index-1 : 0].rest, secs: restTime)
    }
    
    override func finalize(_ exercise: Exercise, _ tag: ResultTag, _ view: UIViewController, _ completion: @escaping () -> Void) {
        let result = Result(tag, weight: weight, reps: reps)
        
        var myResults = Self.results[exercise.formalName] ?? []
        myResults.append(result)
        Self.results[exercise.formalName] = myResults

        super.finalize(exercise, tag, view, completion )
    }
    
    fileprivate override func getBaseRepRange() -> (Int, Int) {
        return sets.repRange(minimum: nil)
    }
    
    private func getActivities(_ exercise: Exercise) -> (Int, [Activity]) {
        switch exercise.type {
        case .body(_): return sets.activities(weight, minimum: reps)
        case .weights(let type): return sets.activities(weight, type.apparatus, minimum: reps)
        }
    }

    var sets: Sets
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
            return [Completion(title: "", info: "", callback: {self.index += 1})]
        } else {
            return [Completion(title: "", info: "", callback: {self.index = self.activities.count})]
        }
    }
    
    func finalize(_ exercise: Exercise, _ tag: ResultTag, _ view: UIViewController, _ completion: @escaping () -> Void) {
        let result = Result(tag, weight: weight, currentTime: currentTime)
        
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

fileprivate func advanceWeightLabel(_ exercise: Exercise, _ weight: Double, by: Int) -> String {
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
