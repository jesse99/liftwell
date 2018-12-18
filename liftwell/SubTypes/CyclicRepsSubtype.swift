//  Created by Jesse Jones on 10/6/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import AVFoundation // for kSystemSoundID_Vibrate
import Foundation
import UIKit           // for UIColor
import os.log

/// Sets/reps/percents vary from week to week.
class CyclicRepsSubtype: BaseCyclicRepsSubtype {
    private typealias `Self` = CyclicRepsSubtype
    
    /// trainingMaxPercent is a percent of 1RM
    init(_ cycles: [Sets], restSecs: Int, trainingMaxPercent: Double? = nil, promptIndex: Int = 0) {
        self.promptIndex = promptIndex
        super.init(cycles, restSecs: restSecs, trainingMaxPercent: trainingMaxPercent)
    }
    
    required init(from store: Store) {
        self.promptIndex = store.getInt("promptIndex", ifMissing: 0)
        super.init(from: store)
    }
    
    override func save(_ store: Store) {
        store.addInt("promptIndex", promptIndex)
        super.save(store)
    }
    
    override func clone() -> ExerciseInfo {
        let store = Store()
        store.addObj("self", self)
        let result: Self = store.getObj("self")
        return result
    }
    
    override func fixedDifficulty() -> ResultTag? {
        return promptIndex < cycles.count ? .normal : nil
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
        
        cycleIndex = (cycleIndex + 1) % cycles.count
        if cycleIndex == promptIndex {
            // Prompt user for advancement
            super.presentFinalize(exercise, tag, view, completion)
        } else {
            completion()
        }
    }
    
    override func doGetResults(_ exercise: Exercise) -> [CyclicResult]? {
        return Self.results[exercise.formalName]
    }
    
    var promptIndex: Int
    static var results: [String: [CyclicResult]] = [:]
}
