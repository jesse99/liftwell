//  Created by Jesse Jones on 11/22/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import AVFoundation // for kSystemSoundID_Vibrate
import Foundation
import UIKit           // for UIColor
import os.log

/// GZCLP scheme where weight is added to each cycle until the user fails at which point the next
/// cycle is used. When cycles run out weight is added according to what was used in the first cycle.
class T2RepsSubType: BaseCyclicRepsSubtype {
    private typealias `Self` = T2RepsSubType
    
    // GZCLP says to set the training max to 85% of the 5RM which is 87% of 1RM
    // and 0.85 * 0.87 == 0.74 which is what we use for the percent of 1RM.
    init(_ cycles: [Sets], restSecs: Int, trainingMaxPercent: Double = 0.74) {
        super.init(cycles, restSecs: restSecs, trainingMaxPercent: trainingMaxPercent)
    }
    
    required init(from store: Store) {
        super.init(from: store)
    }
    
    // ---- ExerciseInfo ----------------------------------------------------------------------
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
        
        if case .failed = tag {
            if cycleIndex+1 >= cycles.count {
                cycleIndex = 0
                setWorkingWeight(0.0)
                completion()
            
                let worksets = cycles[0].worksets
                let reps = worksets.last?.maxReps ?? 0
                let alert = UIAlertController(title: "Resetting Training Max to zero to find a new \(reps)RM.", message: "Wait 2-3 days before finding the new max.", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: {_ in completion()})
                alert.addAction(action)
                view.present(alert, animated: true, completion:nil)
            
            } else {
                cycleIndex = (cycleIndex + 1) % cycles.count
                completion()
            }

        } else {
            switch exercise.type {
            case .body(_): break
            case .weights(let type):
                var weight = aweight.getWorkingWeight()
                let w = Weight(weight, type.apparatus)
                weight = w.nextWeight()
                setWorkingWeight(weight)
            }
            completion()
        }
        
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
