//  Created by Jesse Jones on 10/6/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import AVFoundation // for kSystemSoundID_Vibrate
import Foundation
import UIKit           // for UIColor
import os.log

/// Simple scheme where number of sets is fixed.
class RepsSubType: BaseRepsSubType {
    private typealias `Self` = RepsSubType
    
    override init(_ sets: Sets, restSecs: Int, trainingMaxPercent: Double? = nil) {
        super.init(sets, restSecs: restSecs, trainingMaxPercent: trainingMaxPercent)
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
        
        super.finalize(exercise, tag, view, completion )
    }

    override func doGetResults(_ exercise: Exercise) -> [RepsResult]? {
        return Self.results[exercise.formalName]
    }

    static var results: [String: [RepsResult]] = [:]
}

