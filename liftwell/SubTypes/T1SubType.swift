//  Created by Jesse Jones on 11/22/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import AVFoundation // for kSystemSoundID_Vibrate
import Foundation
import UIKit           // for UIColor
import os.log

/// GZCLP scheme where weight is added to each cycle until the user fails at which point the next
/// cycle is used. When cycles run out they are reset to the first cycle and a new Training Max
/// is chosen.
class T1RepsSubtype: BaseCyclicRepsSubtype {
    private typealias `Self` = T1RepsSubtype
    
    class Result: CyclicResult {
        init(_ tag: ResultTag, weight: Double, cycleIndex: Int, _ sets: String, goalReps: Int, actualReps: Int) {
            self.sets = sets
            self.goalReps = goalReps
            super.init(tag, weight: weight, cycleIndex: cycleIndex, reps: actualReps)
        }
        
        required init(from store: Store) {
            self.sets = store.getStr("sets")
            self.goalReps = store.getInt("goalReps")
            super.init(from: store)
        }
        
        override func save(_ store: Store) {
            store.addStr("sets", sets)
            store.addInt("goalReps", goalReps)
            super.save(store)
        }
        
        var sets: String        // "5x3"
        var goalReps: Int       // for the AMRAP set (as is base.reps)
    }
    
    // GZCLP says to set the training max to 85% of the 5RM which is 87% of 1RM
    // and 0.85 * 0.87 == 0.74 which is what we use for the percent of 1RM.
    init(_ cycles: [Sets], restSecs: Int, trainingMaxPercent: Double = 0.74) {
        super.init(cycles, restSecs: restSecs, trainingMaxPercent: trainingMaxPercent)
    }
    
    required init(from store: Store) {
        super.init(from: store)
    }
    
    override func errors() -> [String] {
        var problems: [String] = super.errors()
        for sets in cycles {
            if let last = sets.worksets.last, !last.amrap {
                problems.append("Last set in each cycle should be AMRAP.")
            }
        }
        return problems
    }
    
    // ---- ExerciseInfo ----------------------------------------------------------------------
    override func prevLabel(_ exercise: Exercise) -> (String, UIColor) {
        // History will include the AMRAP reps and the tag is inferred from that so don't think we want anything here.
        return ("", UIColor.black)
    }
    
    override func historyLabel(_ exercise: Exercise) -> String {
        if let myResults = Self.results[exercise.formalName] {
            var labels: [String] = []
            
            for result in myResults {
                let delta = result.reps - result.goalReps
                if delta > 0 {
                    labels.append("\(result.sets)(+\(delta)) @ \(Weight.friendlyUnitsStr(result.weight))")
                } else {
                    labels.append("\(result.sets)(\(delta)) @ \(Weight.friendlyUnitsStr(result.weight))")
                }
            }
            
            return makeHistoryFromLabels(labels)
        }
        return ""
    }
    
    override func finalize(_ exercise: Exercise, _ view: UIViewController, _ completion: @escaping () -> Void) {
        let weight: Double
        switch exercise.type {
        case .body(_): weight = aweight.getWorkingWeight()
        case .weights(let type):
            let w = Weight(aweight.getWorkingWeight(), type.apparatus).closest()
            weight = w.weight
        }

        let worksets = cycles[cycleIndex].worksets
        let requestedReps = worksets.last?.maxReps ?? 0
        let label = "\(worksets.count)x\(requestedReps)"
        let result = Result(amrapTag!, weight: weight, cycleIndex: cycleIndex, label, goalReps: requestedReps, actualReps: amrapReps!)
        
        var myResults = Self.results[exercise.formalName] ?? []
        myResults.append(result)
        Self.results[exercise.formalName] = myResults
        
        if amrapReps! >= requestedReps {
            switch exercise.type {
            case .body(_): break
            case .weights(let type):
                var weight = aweight.getWorkingWeight()
                let w = Weight(weight, type.apparatus)
                weight = w.nextWeight()
                setWorkingWeight(weight)
            }
            completion()
            
        } else if cycleIndex+1 >= cycles.count {
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
    }
    
    override func doGetResults(_ formalName: String) -> [CyclicResult]? {
        return Self.results[formalName]
    }
    
    static var results: [String: [Result]] = [:]
}
