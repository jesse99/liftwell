//  Created by Jesse Jones on 12/24/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import AVFoundation // for kSystemSoundID_Vibrate
import Foundation
import UIKit           // for UIColor
import os.log

/// From CAP3: weight goes up if estimated 1RM increases or user was able to hit all reps at the end of the cycle.
class AMRAP1RMSubType: BaseCyclicRepsSubType {
    private typealias `Self` = AMRAP1RMSubType
    
    /// trainingMaxPercent is a percent of 1RM
    init(_ cycles: [Sets], restSecs: Int, trainingMaxPercent: Double = 0.9) {
        super.init(cycles, restSecs: restSecs, trainingMaxPercent: trainingMaxPercent)
    }
    
    required init(from store: Store) {
        super.init(from: store)
    }
    
    override func errors() -> [String] {
        var problems = super.errors()
        let count = cycles.count {self.advancingCycle($0)}
        if count == 0 { // 2 would be goofy but, strictly speaking, not wrong
            problems.append("There should be a cycle to advance weight (which should have one AMRAP work set).")
        }
        return problems
    }
    
    override func clone() -> ExerciseInfo {
        let store = Store()
        store.addObj("self", self)
        let result: Self = store.getObj("self")
        return result
    }
        
    override func doFinalize(_ exercise: Exercise, _ tag: ResultTag, _ reps: Int, _ view: UIViewController, _ completion: @escaping () -> Void) {
        let baseWeight = aweight.getBaseWorkingWeight()
        var liftedWeight = baseWeight
        if let last = cycles[cycleIndex].worksets.last {
            if case .weights(let type) = exercise.type {
                let w = Weight(baseWeight*last.percent, type.apparatus).closest()
                liftedWeight = w.weight
            }
        }
        
        let result = CyclicResult(tag, baseWeight: baseWeight, liftedWeight: liftedWeight, cycleIndex: cycleIndex, reps: reps)
        
        var myResults = Self.results[exercise.formalName] ?? []
        myResults.append(result)
        Self.results[exercise.formalName] = myResults
        
        let cycle = advancingCycle(cycles[cycleIndex]) ? cycles[cycleIndex] : nil
        cycleIndex = (cycleIndex + 1) % cycles.count
        if let cycle = cycle {
            presentFinalize(exercise, cycle, completion)
        } else {
            completion()
        }
    }
    
    private func presentFinalize(_ exercise: Exercise, _ cycle: Sets, _ completion: @escaping () -> Void) {
        if let results = Self.results[exercise.formalName], let result = results.last, let requestedReps = cycle.worksets.last?.maxReps {
            var updated = false
            
            // This 1RM formula is from https://drive.google.com/file/d/0B8EbfzFB0mBrYW5Sd3oxRzNRY2M/view. It's not as accurate as our
            // get1RM function but we use it to keep as close as possible to what CAP3 wants to use (and also because the formula works
            // (more or less) above 15 reps).
            if result.reps > requestedReps {
                let max = result.liftedWeight*((0.03333*Double(result.reps)) + 1)   // TODO: should we use this with other nSuns stuff?
                switch aweight {
                case .trainingMax(percent: let percent, oneRepMax: let oldMax):
                    if max > oldMax {
                        if let apparatus = exercise.getApparatus() {
                            let w = Weight(max, apparatus)
                            let weight = w.closest(above: oldMax).weight
                            aweight = .trainingMax(percent: percent, oneRepMax: weight)
                            updated = true
                        }
                    }
                default:
                    assert(false)
                }
            }
            
            if !updated {
                var weight = aweight.getBaseWorkingWeight()
                if result.reps >= requestedReps {
                    if let apparatus = exercise.getApparatus() {
                        let w = Weight(weight, apparatus)
                        weight = w.nextWeight()
                        setWorkingWeight(weight)
                    }
                    
                } else {
                    if let apparatus = exercise.getApparatus() {
                        let w = Weight(weight, apparatus)
                        weight = w.prevWeight()
                        setWorkingWeight(weight)
                    }
                }
            }
        }
        completion()
    }

    override func doGetResults(_ exercise: Exercise) -> [CyclicResult]? {
        return Self.results[exercise.formalName]
    }
    
    private func advancingCycle(_ cycle: Sets) -> Bool {
        return cycle.worksets.count == 1 && cycle.worksets.last!.amrap
    }
    
    static var results: [String: [CyclicResult]] = [:]
}
