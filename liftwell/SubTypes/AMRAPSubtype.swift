//  Created by Jesse Jones on 12/23/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import AVFoundation // for kSystemSoundID_Vibrate
import Foundation
import UIKit           // for UIColor
import os.log

/// Weight goes up according to how many reps were done in the AMRAP set.
class AMRAPSubType: BaseRepsApparatusSubType {
    private typealias `Self` = AMRAPSubType
    
    init(_ sets: Sets, advanceBy: [Int], restSecs: Int, trainingMaxPercent: Double? = nil) {
        self.advanceBy = advanceBy
        super.init(sets, restSecs: restSecs, trainingMaxPercent: trainingMaxPercent)
    }
    
    required init(from store: Store) {
        self.advanceBy = store.getIntArray("advanceBy")
        super.init(from: store)
    }
    
    override func save(_ store: Store) {
        store.addIntArray("advanceBy", advanceBy)
        super.save(store)
    }

    override func errors(_ exercise: Exercise) -> [String] {
        var problems: [String] = super.errors(exercise)
        let (_, _, amrap) = getBaseRepRange()
        if amrap == nil {
            problems.append("Last work set should be AMRAP.")
        }
        if advanceBy.isEmpty {
            problems.append("advanceBy should not be empty.")
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
        if let last = sets.worksets.last {
            if case .weights(let type) = exercise.type {
                let w = Weight(baseWeight*last.percent, type.apparatus).closest()
                liftedWeight = w.weight
            }
        }
        
        let result = RepsResult(tag, baseWeight: baseWeight, liftedWeight: liftedWeight, reps: reps)
        
        var myResults = doGetResults(exercise) ?? []
        myResults.append(result)
        Self.results[exercise.formalName] = myResults
        
        presentFinalize(exercise, tag, view, completion )
    }
    
    override func presentFinalize(_ exercise: Exercise, _ tag: ResultTag, _ view: UIViewController, _ completion: @escaping () -> Void) {
        let weight = getBaseWorkingWeight()
        
        switch exercise.type {
        case .body(_): assert(false); completion()
        case .weights(let type):
            if let reps = amrapReps {
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
                
                let by = reps < advanceBy.count ? advanceBy[reps] : (advanceBy.last ?? 0)
                if by > 0 {
                    for i in stride(from: by, through: 1, by: -1) {
                        let label = advanceWeightLabel(exercise, weight, by: i)
                        let action = UIAlertAction(title: "Advance by \(label)", style: .default) {_ in self.doAdvance(exercise, type.apparatus, i); completion()}
                        alert.addAction(action)
                        if i == by {
                            alert.preferredAction = action
                        }
                    }
                    let maintain = UIAlertAction(title: "Maintain", style: .default) {_ in completion()}
                    alert.addAction(maintain)
                    view.present(alert, animated: true, completion: nil)

                } else if by < 0 {
                    let maintain = UIAlertAction(title: "Maintain", style: .default) {_ in completion()}
                    alert.addAction(maintain)

                    let deloads = exercise.findDeloads(weight, 0.10).map {label, amount in UIAlertAction(title: "Deload by \(label)", style: .default) {_ in self.doAdvance(exercise, type.apparatus, amount); completion()}}
                    for deload in deloads {
                        alert.addAction(deload)
                    }
                    view.present(alert, animated: true, completion: nil)
                }
                
            } else {
                assert(false)
                completion()
            }
        }
    }
    
    override func doGetResults(_ exercise: Exercise) -> [RepsResult]? {
        return Self.results[exercise.formalName]
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

    var advanceBy: [Int]
    static var results: [String: [RepsResult]] = [:]
}

