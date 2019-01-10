//  Created by Jesse Jones on 11/22/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import AVFoundation // for kSystemSoundID_Vibrate
import Foundation
import UIKit           // for UIColor
import os.log

/// GZCL scheme where weight added according to how well the user did on the AMRAP set.
class T1RepsSubType: BaseCyclicRepsSubType {
    private typealias `Self` = T1RepsSubType
    
    init(_ cycles: [Sets], restSecs: Int) {
        super.init(cycles, restSecs: restSecs)
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
    
    override func errors(_ exercise: Exercise) -> [String] {
        var problems: [String] = super.errors(exercise)
        var found = false
        for sets in cycles {
            for set in sets.worksets {
                if set.amrap {
                    found = true
                }
            }
        }
        if !found {
            problems.append("At least one workset should be AMRAP.")
        }
        return problems
    }
    
    // ---- ExerciseInfo ----------------------------------------------------------------------
    override func start(_ workout: Workout, _ exercise: Exercise) -> (Exercise, String)? {
        if let (newExercise, oldLabel) = super.start(workout, exercise) {
            if let myResults = Self.results[exercise.formalName], !myResults.isEmpty {
                return (newExercise, "Reset 3RM")
            } else {
                return (newExercise, oldLabel)
            }

        } else {
            return nil
        }
    }
    
//    override func prevLabel(_ exercise: Exercise) -> (String, UIColor) {
//        // History will include the AMRAP reps and the tag is inferred from that so don't think we want anything here.
//        return ("", UIColor.black)
//    }
    
//    override func historyLabel(_ exercise: Exercise) -> String {
//        if let myResults = Self.results[exercise.formalName] {
//            var labels: [String] = []
//
//            for result in myResults {
//                let delta = result.reps - result.goalReps
//                if delta > 0 {
//                    labels.append("\(result.sets)(+\(delta)) @ \(Weight.friendlyUnitsStr(result.liftedWeight))")
//                } else {
//                    labels.append("\(result.sets)(\(delta)) @ \(Weight.friendlyUnitsStr(result.liftedWeight))")
//                }
//            }
//
//            return makeHistoryFromLabels(labels)
//        }
//        return ""
//    }
    
    override func doFinalize(_ exercise: Exercise, _ tag: ResultTag, _ reps: Int, _ view: UIViewController, _ completion: @escaping () -> Void) {
        let baseWeight = aweight.getBaseWorkingWeight()
        var liftedWeight = baseWeight
        if let last = cycles[cycleIndex].worksets.last {
            if case .weights(let type) = exercise.type {
                let w = Weight(baseWeight*last.percent, type.apparatus).closest()
                liftedWeight = w.weight
            }
        }

        let worksets = cycles[cycleIndex].worksets
        let requestedReps = worksets.last?.maxReps ?? 0
//        let label = "\(worksets.count)x\(requestedReps)"
        
        let result: CyclicResult
        if let reps = amrapReps, let tag = amrapTag {
            result = CyclicResult(tag, baseWeight: baseWeight, liftedWeight: liftedWeight, cycleIndex: cycleIndex, reps: reps)
        } else {
            result = CyclicResult(tag, baseWeight: baseWeight, liftedWeight: liftedWeight, cycleIndex: cycleIndex, reps: reps)
        }
        
        var myResults = Self.results[exercise.formalName] ?? []
        myResults.append(result)
        Self.results[exercise.formalName] = myResults
        
        cycleIndex = (cycleIndex + 1) % cycles.count
        if let reps = amrapReps {
            maybeAdvance(exercise, requestedReps, reps, view, completion)
        } else {
            completion()
        }
    }
    
    private func maybeAdvance(_ exercise: Exercise, _ requestedReps: Int, _ actualReps: Int, _ view: UIViewController, _ completion: @escaping () -> Void) {
        let weight = getBaseWorkingWeight()
        
        if let apparatus = exercise.getApparatus() {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
            
            let by = actualReps - requestedReps
            if by == 1 {
                let label = advanceWeightLabel(exercise, weight, by: 1)
                let action = UIAlertAction(title: "Advance by \(label)", style: .default) {_ in self.doAdvance(exercise, apparatus, 1); completion()}
                alert.addAction(action)
                alert.preferredAction = action
            
            } else if by == 2 {
                var label = advanceWeightLabel(exercise, weight, by: 2)
                var action = UIAlertAction(title: "Advance by \(label)", style: .default) {_ in self.doAdvance(exercise, apparatus, 2); completion()}
                alert.addAction(action)
                alert.preferredAction = action
                
                label = advanceWeightLabel(exercise, weight, by: 1)
                action = UIAlertAction(title: "Advance by \(label)", style: .default) {_ in self.doAdvance(exercise, apparatus, 1); completion()}
                alert.addAction(action)
            
            } else if by >= 3 {
                var label = advanceWeightLabel(exercise, weight, by: 3)
                var action = UIAlertAction(title: "Advance by \(label)", style: .default) {_ in self.doAdvance(exercise, apparatus, 3); completion()}
                alert.addAction(action)
                alert.preferredAction = action
                
                label = advanceWeightLabel(exercise, weight, by: 2)
                action = UIAlertAction(title: "Advance by \(label)", style: .default) {_ in self.doAdvance(exercise, apparatus, 2); completion()}
                alert.addAction(action)
                
                label = advanceWeightLabel(exercise, weight, by: 1)
                action = UIAlertAction(title: "Advance by \(label)", style: .default) {_ in self.doAdvance(exercise, apparatus, 1); completion()}
                alert.addAction(action)
            }
            
            if by >= 1 {
                let maintain = UIAlertAction(title: "Maintain", style: .default) {_ in completion()}
                alert.addAction(maintain)
                
                view.present(alert, animated: true, completion: nil)
            } else {
                completion()
            }
        }
    }
    
    private func doAdvance(_ exercise: Exercise, _ apparatus: Apparatus, _ amount: Int) {
        var weight = doGetAdvanceWeight(exercise)
        
        let delta = amount.signum()
        for _ in 0..<abs(amount) {
            let w = Weight(weight, apparatus)
            if delta > 0 {
                weight = w.nextWeight()
            } else {
                weight = w.prevWeight()
            }
        }
        
        setWorkingWeight(weight)
    }

    override func doCreateFindWeights(_ exercise: Exercise, prevWeight: Double?) -> FindWeightSubType {
        var subtitle = ""
        if let myResults = Self.results[exercise.formalName], let last = myResults.last, last.liftedWeight > 0.0 {
            var threeMax = 0.0
            switch exercise.type {
            case .body(_):
                assert(false)
            case .weights(let type):
                if let oneMax = get1RM(last.liftedWeight, last.reps) {
                    threeMax = oneMax * 0.93
                    
                    let w = Weight(threeMax, type.apparatus).closest()
                    subtitle = "3RM was \(w.text)"
                }
            }
        }
        return FindWeightSubType(reps: 3, restSecs: restTime, prevWeight: prevWeight, subtitle: subtitle)
    }
    
    override func doGetResults(_ exercise: Exercise) -> [CyclicResult]? {
        return Self.results[exercise.formalName]
    }
    
    static var results: [String: [CyclicResult]] = [:]
}
