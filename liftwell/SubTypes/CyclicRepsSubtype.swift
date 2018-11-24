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
    override init(_ cycles: [Sets], restSecs: Int, trainingMaxPercent: Double? = nil) {
        super.init(cycles, restSecs: restSecs, trainingMaxPercent: trainingMaxPercent)
    }
    
    required init(from store: Store) {
        super.init(from: store)
    }
    
    override func doFinalize(_ exercise: Exercise, _ tag: ResultTag, _ reps: Int, _ view: UIViewController, _ completion: @escaping () -> Void) {
        let weight: Double
        switch exercise.type {
        case .body(_): weight = aweight.getWorkingWeight()
        case .weights(let type):
            let w = Weight(aweight.getWorkingWeight(), type.apparatus).closest()
            weight = w.weight
        }

        let result = CyclicResult(tag, weight: weight, cycleIndex: cycleIndex, reps: reps)
        
        var myResults = Self.results[exercise.formalName] ?? []
        myResults.append(result)
        Self.results[exercise.formalName] = myResults
        
        cycleIndex = (cycleIndex + 1) % cycles.count
        if cycleIndex == 0 {
            // Prompt user for advancement
            super.finalize(exercise, tag, view, completion)
        } else {
            completion()
        }
    }
    
    override func doGetResults(_ formalName: String) -> [CyclicResult]? {
        return Self.results[formalName]
    }
    
    static var results: [String: [CyclicResult]] = [:]
}
