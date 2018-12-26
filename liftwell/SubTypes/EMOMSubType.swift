//  Created by Jesse Jones on 12/25/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import AVFoundation // for kSystemSoundID_Vibrate
import Foundation
import UIKit           // for UIColor
import os.log

/// From CAP3: repeat sets Every Minute On the Minute until can't do the requested reps.
class EMOMSubType: BaseCyclicRepsSubType {
    private typealias `Self` = EMOMSubType
    
    class Result: CyclicResult {
        init(baseWeight: Double, liftedWeight: Double, cycleIndex: Int, reps: Int) {
            super.init(.normal, baseWeight: baseWeight, liftedWeight: liftedWeight, cycleIndex: cycleIndex, reps: reps)
        }
        
        required init(from store: Store) {
            requested = store.getIntArray("requested")
            actual = store.getIntArray("actual")
            super.init(from: store)
        }
        
        override func save(_ store: Store) {
            store.addIntArray("requested", requested)
            store.addIntArray("actual", actual)
            super.save(store)
        }
        
        var requested: [Int] = []    // these are for the AMRAP sets
        var actual: [Int] = []
    }
    
    /// trainingMaxPercent is a percent of 1RM
    init(_ cycles: [Sets], restSecs: Int, trainingMaxPercent: Double = 0.9) {
        result = nil
        super.init(cycles, restSecs: restSecs, trainingMaxPercent: trainingMaxPercent)
    }
    
    required init(from store: Store) {
        if store.hasKey("result") {
            result = store.getObj("result")
        } else {
            result = nil
        }
        super.init(from: store)
    }
    
    override func save(_ store: Store) {
        if let result = result {
            store.addObj("result", result)
        }
        super.save(store)
    }

    override func clone() -> ExerciseInfo {
        let store = Store()
        store.addObj("self", self)
        let result: Self = store.getObj("self")
        return result
    }
    
    override func start(_ workout: Workout, _ exercise: Exercise) -> (Exercise, String)? {
        let info = super.start(workout, exercise)
        if info == nil {
            let baseWeight = aweight.getBaseWorkingWeight()
            var liftedWeight = baseWeight
            var reps = 0
            if let last = cycles[cycleIndex].worksets.last {
                if case .weights(let type) = exercise.type {
                    let w = Weight(baseWeight*last.percent, type.apparatus).closest()
                    liftedWeight = w.weight
                    reps = last.minReps
                }
            }
            
            result = Result(baseWeight: baseWeight, liftedWeight: liftedWeight, cycleIndex: cycleIndex, reps: reps)
        }
        return info
    }
    
    override func updated(_ exercise: Exercise) {
        super.updated(exercise)
        
        if isMRS() {
            let cycle = cycles[cycleIndex]
            for i in 0..<cycle.worksets.count {
                if i+1 < cycle.worksets.count {
                    activities[cycle.warmups.count + i].title = "Workset \(i+1)"
                } else {
                    activities[cycle.warmups.count + i].title = "MRS 1"
                }
            }
            
            if var last = activities.last {
                last.buttonName = "Next"
                _ = activities.popLast()
                activities.append(last)
            }
        }
    }

    override func sublabel(_ exercise: Exercise) -> String {
        if isMRS() {
            return super.sublabel(exercise) + " MRS"
        } else {
            return super.sublabel(exercise)
        }
    }
    
    override func historyLabel(_ exercise: Exercise) -> String {
        func historyLabel(_ history: [(Int, Double, Int)]) -> String {
            var labels: [String] = []
            
            for (reps, weight, numSets) in history {
                if numSets == 1 {
                    labels.append("1 set @ \(Weight.friendlyUnitsStr(weight))")
                } else if numSets > 1 {
                    labels.append("\(numSets) sets @ \(Weight.friendlyUnitsStr(weight))")
                } else if reps == 1 {
                    labels.append("1 @ \(Weight.friendlyUnitsStr(weight))")
                } else {
                    labels.append("\(reps) @ \(Weight.friendlyUnitsStr(weight))")
                }
            }
            
            return makeHistoryFromLabels(labels)
        }

        if let myResults = Self.results[exercise.formalName] {
            let history = myResults.map {($0.reps, $0.liftedWeight, $0.actual.count)}
            return historyLabel(history)
        }
        return ""
    }
    
    override func restSecs() -> RestTime {
        let cycle = cycles[cycleIndex]
        if index < cycle.warmups.count + cycle.worksets.count {
            return RestTime(autoStart: cycle.set(index > 0 ? index-1 : 0).rest, secs: restTime)
        
        } else {            // for MRS sets
            if let result = result, let lastActual = result.actual.last, let lastRequested = result.requested.last {
                return RestTime(autoStart: lastActual >= lastRequested, secs: restTime)

            } else {
                return RestTime(autoStart: true, secs: restTime)
            }
        }
    }
    
    override func completions(_ exercise: Exercise) -> [Completion] {
        if isMRS() {
            if index+1 < activities.count {
                return [Completion(title: "", info: "", callback: self.doNext)]
            } else {
                return [Completion(title: "", info: "", callback: self.doMRS)]
            }
        } else {
            return super.completions(exercise)
        }
    }
    
    private func doNext(_ view: UIViewController, _ completion: @escaping () -> Void) {
        if let set = getAmrap(index) {
            getAMRAPResult(view, set.minReps, {
                _ = $1  // we ignore the (inferred) amrap tag
                self.result!.requested.append(set.minReps)
                self.result!.actual.append($0)
                self.index += 1
                completion()
            })
            
        } else {
            index += 1
            completion()
        }
    }
    
    private func doMRS(_ view: UIViewController, _ completion: @escaping () -> Void) {
        if let set = getAmrap(index) {
            getAMRAPResult(view, set.minReps, {
                _ = $1  // we ignore the (inferred) amrap tag
                self.result!.requested.append(set.minReps)
                self.result!.actual.append($0)
                if $0 >= set.minReps {
                    self.addMRS()
                }
                self.index += 1
                completion()
            })

        } else {
            index += 1
            completion()
        }
    }
    
    private func addMRS() {
        var new = activities.last!.clone()
        new.title = "MRS \(activities.count - cycles[cycleIndex].worksets.count + 2)"
        new.buttonName = "Next"
        activities.append(new)
    }
    
    private func isMRS() -> Bool {
        let cycle = cycles[cycleIndex]
        let i = cycle.warmups.count + cycle.worksets.count - 1
        return getAmrap(i) != nil
    }
    
    private func getAmrap(_ index: Int) -> Set? {
        let cycle = cycles[cycleIndex]
        let i = index - cycle.warmups.count
        if i < cycle.worksets.count {
            return cycle.worksets[i].amrap ? cycle.worksets[i] : nil
        } else {
            return cycle.worksets.last  // for the MRS sets
        }
    }
    
    override func fixedDifficulty() -> ResultTag? {
        return .normal
    }
    
    override func doFinalize(_ exercise: Exercise, _ tag: ResultTag, _ reps: Int, _ view: UIViewController, _ completion: @escaping () -> Void) {
        var myResults = Self.results[exercise.formalName] ?? []
        myResults.append(result!)
        Self.results[exercise.formalName] = myResults
        result = nil
        
        //        let cycle = advancingCycle(cycles[cycleIndex]) ? cycles[cycleIndex] : nil // TODO: make sure that this works when not MRS
        cycleIndex = (cycleIndex + 1) % cycles.count
//        if let cycle = cycle {
//            presentFinalize(exercise, cycle, completion)
//        } else {
            completion()
//        }
    }
    
    // TODO: if new PR then adjust TM, maybe this should be on any of the AMRAP sets?
    // TODO: if no new PR but hit min reps then adjust TM
    // TODO: otherwise drop TM
    // TODO: make sure that thus works when exit and re-enter mindway (eg amrap results aren't lost)
    
//    private func presentFinalize(_ exercise: Exercise, _ cycle: Sets, _ completion: @escaping () -> Void) {
//        if let results = Self.results[exercise.formalName], let result = results.last, let requestedReps = cycle.worksets.last?.maxReps {
//            var updated = false
//
//            // This 1RM formula is from https://drive.google.com/file/d/0B8EbfzFB0mBrYW5Sd3oxRzNRY2M/view. It's not as accurate as our
//            // get1RM function but we use it to keep as close as possible to what CAP3 wants to use (and also because the formula works
//            // (more or less) above 15 reps).
//            if result.reps > requestedReps {
//                let max = result.liftedWeight*((0.03333*Double(result.reps)) + 1)   // TODO: should we use this with other nSuns stuff?
//                switch aweight {
//                case .trainingMax(percent: let percent, oneRepMax: let oldMax):
//                    if max > oldMax {
//                        switch exercise.type {
//                        case .body(_): break
//                        case .weights(let type):
//                            let w = Weight(max, type.apparatus)
//                            let weight = w.closest(above: oldMax).weight
//                            aweight = .trainingMax(percent: percent, oneRepMax: weight)
//                            updated = true
//                        }
//
//                    }
//                default:
//                    assert(false)
//                }
//            }
//
//            if !updated {
//                var weight = aweight.getBaseWorkingWeight()
//                if result.reps >= requestedReps {
//                    switch exercise.type {
//                    case .body(_): break
//                    case .weights(let type):
//                        let w = Weight(weight, type.apparatus)
//                        weight = w.nextWeight()
//                        setWorkingWeight(weight)
//                    }
//
//                } else {
//                    switch exercise.type {
//                    case .body(_): break
//                    case .weights(let type):
//                        let w = Weight(weight, type.apparatus)
//                        weight = w.prevWeight()
//                        setWorkingWeight(weight)
//                    }
//                }
//            }
//        }
//        completion()
//    }
    
    override func doGetResults(_ exercise: Exercise) -> [CyclicResult]? {
        return Self.results[exercise.formalName]
    }

    var result: Result?
    static var results: [String: [Result]] = [:]
}
