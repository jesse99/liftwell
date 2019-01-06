//  Created by Jesse Jones on 11/22/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import AVFoundation // for kSystemSoundID_Vibrate
import Foundation
import UIKit           // for UIColor
import os.log

/// GZCLP scheme where weight is added to each cycle until the user fails at which point the next
/// cycle is used. When cycles run out weight is added according to what was used in the first cycle.
class T2RepsSubType: BaseCyclicRepsSubType {
    private typealias `Self` = T2RepsSubType
    
    init(_ cycles: [Sets], restSecs: Int) {
        super.init(cycles, restSecs: restSecs, trainingMaxPercent: nil)
    }
    
    required init(from store: Store) {
        super.init(from: store)
    }
    
    override func clone() -> ExerciseInfo {
        let store = Store()
        store.addObj("self", self)
        let result: Self = store.getObj("self")
        return result
    }
    
    override func errors() -> [String] {
        var problems: [String] = super.errors()
        for sets in cycles {
            if let last = sets.worksets.last, last.amrap {
                problems.append("Last set in each cycle should NOT be AMRAP.")
            }
        }
        return problems
    }

    // ---- ExerciseInfo ----------------------------------------------------------------------
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
        
        if case .failed = tag {
            if cycleIndex+1 >= cycles.count {
                cycleIndex = 0
                super.presentFinalize(exercise, .veryEasy, view, completion)   // veryEasy because we advance based on what the user lifted at the start of the cycle

            } else {
                cycleIndex = (cycleIndex + 1) % cycles.count
                completion()
            }

        } else {
            if let weight = exercise.getNextWeight() {
                setWorkingWeight(weight)
            }
            completion()
        }
    }

    override func doGetAdvanceWeight(_ exercise: Exercise) -> Double {
        if let myResults = Self.results[exercise.formalName] {
            for result in myResults.reversed() {
                if result.cycleIndex == 0 {
                    return result.baseWeight
                }
            }
        }
        return 0.0
    }
    
    override func doGetResults(_ exercise: Exercise) -> [CyclicResult]? {
        return Self.results[exercise.formalName]
    }
    
    static var results: [String: [CyclicResult]] = [:]
}
