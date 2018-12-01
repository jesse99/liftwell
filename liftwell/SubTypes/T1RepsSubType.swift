//  Created by Jesse Jones on 11/22/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import AVFoundation // for kSystemSoundID_Vibrate
import Foundation
import UIKit           // for UIColor
import os.log

/// GZCLP scheme where weight is added to each cycle until the user fails at which point the next
/// cycle is used. When cycles run out they are reset to the first cycle and a new Training Max
/// is chosen.
class T1RepsSubType: BaseCyclicRepsSubtype {
    private typealias `Self` = T1RepsSubType
    
    class Result: CyclicResult {
        init(_ tag: ResultTag, baseWeight: Double, liftedWeight: Double, cycleIndex: Int, _ sets: String, goalReps: Int, actualReps: Int, percent: Double, oneMax: Double) {
            self.sets = sets
            self.goalReps = goalReps
            self.percent = percent
            self.oneMax = oneMax
            super.init(tag, baseWeight: baseWeight, liftedWeight: liftedWeight, cycleIndex: cycleIndex, reps: actualReps)
        }
        
        required init(from store: Store) {
            self.sets = store.getStr("sets")
            self.goalReps = store.getInt("goalReps")
            self.percent = store.getDbl("percent")
            self.oneMax = store.getDbl("oneMax")
            super.init(from: store)
        }
        
        override func save(_ store: Store) {
            store.addStr("sets", sets)
            store.addInt("goalReps", goalReps)
            store.addDbl("percent", percent)
            store.addDbl("oneMax", oneMax)
            super.save(store)
        }
        
        var sets: String        // "5x3"
        var goalReps: Int       // for the AMRAP set (as is base.reps)
        var percent: Double
        var oneMax: Double
    }
    
    // GZCLP says to set the training max to 85% of the 5RM. SO we have:
    // TM = 0.85 * 5RM
    // TM = percent * 1RM
    // 1RM = 5RM * (2 - 0.87)
    //
    // TM = percent * (5RM * (2 - 0.87))
    // 0.85 * 5RM = percent * (5RM * (2 - 0.87))
    // percent = (0.85 * 5RM)/(5RM * (2 - 0.87))
    // percent = 0.85/(2 - 0.87)
    // percent = 0.752
    init(_ cycles: [Sets], restSecs: Int, trainingMaxPercent: Double = 0.752) {
        super.init(cycles, restSecs: restSecs, trainingMaxPercent: trainingMaxPercent)
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
            if let last = sets.worksets.last, !last.amrap {
                problems.append("Last set in each cycle should be AMRAP.")
            }
        }
        return problems
    }
    
    // ---- ExerciseInfo ----------------------------------------------------------------------
    override func start(_ workout: Workout, _ exercise: Exercise) -> (Exercise, String)? {
        if let (newExercise, oldLabel) = super.start(workout, exercise) {
            if let myResults = Self.results[exercise.formalName], !myResults.isEmpty {
                return (newExercise, "Reset 5RM")
            } else {
                return (newExercise, oldLabel)
            }

        } else {
            return nil
        }
    }
    
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
                    labels.append("\(result.sets)(+\(delta)) @ \(Weight.friendlyUnitsStr(result.liftedWeight))")
                } else {
                    labels.append("\(result.sets)(\(delta)) @ \(Weight.friendlyUnitsStr(result.liftedWeight))")
                }
            }
            
            return makeHistoryFromLabels(labels)
        }
        return ""
    }
    
    override func finalize(_ exercise: Exercise, _ view: UIViewController, _ completion: @escaping () -> Void) {
        let baseWeight = aweight.getBaseWorkingWeight()
        var liftedWeight = baseWeight
        if let last = cycles[cycleIndex].worksets.last {
            if case .weights(let type) = exercise.type {
                let w = Weight(baseWeight*last.percent, type.apparatus).closest()
                liftedWeight = w.weight
            }
        }
        
        let percent: Double
        let oneMax: Double
        switch aweight {
        case .weight(_):
            assert(false)
            percent = 0.0
            oneMax = 0.0
        case .trainingMax(percent: let p, oneRepMax: let max):
            percent = p
            oneMax = max
        }

        let worksets = cycles[cycleIndex].worksets
        let requestedReps = worksets.last?.maxReps ?? 0
        let label = "\(worksets.count)x\(requestedReps)"
        let result = Result(amrapTag!, baseWeight: baseWeight, liftedWeight: liftedWeight, cycleIndex: cycleIndex, label, goalReps: requestedReps, actualReps: amrapReps!, percent: percent, oneMax: oneMax)
        
        var myResults = Self.results[exercise.formalName] ?? []
        myResults.append(result)
        Self.results[exercise.formalName] = myResults
        
        if amrapReps! >= requestedReps {
            switch exercise.type {
            case .body(_): break
            case .weights(let type):
                var weight = aweight.getBaseWorkingWeight()
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
            let reps = worksets.last?.maxReps ?? 0  // TODO: this alert isn't working, maybe we're already in an alert?
            let alert = UIAlertController(title: "Resetting Training Max to zero to find a new \(reps)RM.", message: "Wait 2-3 days before finding the new max.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: {_ in completion()})
            alert.addAction(action)
            
            if var topController = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                topController.present(alert, animated: true, completion:nil)
            } else {
                completion()
            }
            //view.present(alert, animated: true, completion:nil)
            
        } else {
            cycleIndex = (cycleIndex + 1) % cycles.count
            completion()
        }
    }
    
    // TM = 0.85 * 5RM
    // TM = percent * 1RM
    //
    // 0.85 * 5RM = percent * 1RM
    // 5RM = (percent * 1RM)/0.85
    override func doCreateFindWeights(_ exercise: Exercise) -> FindWeightSubType {
        var subtitle = ""
        if let myResults = Self.results[exercise.formalName], let last = myResults.last, last.oneMax > 0.0 {
            let fiveMax = (last.percent * last.oneMax)/0.85
            switch exercise.type {
            case .body(_):
                assert(false)
            case .weights(let type):
                let w = Weight(fiveMax, type.apparatus).closest()
                subtitle = "5RM was \(w.text)"
            }
        }
        return FindWeightSubType(reps: 5, restSecs: restTime, subtitle: subtitle)
    }
    
    override func doGetResults(_ exercise: Exercise) -> [CyclicResult]? {
        return Self.results[exercise.formalName]
    }
    
    static var results: [String: [Result]] = [:]
}
