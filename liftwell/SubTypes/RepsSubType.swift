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
    
    override func doFinalize(_ exercise: Exercise, _ tag: ResultTag, _ reps: Int, _ view: UIViewController, _ completion: @escaping () -> Void) {
        let weight: Double
        switch exercise.type {
        case .body(_): weight = aweight.getWorkingWeight()
        case .weights(let type):
            let w = Weight(aweight.getWorkingWeight(), type.apparatus).closest()
            weight = w.weight
        }
        
        let result = RepsResult(tag, weight: weight, reps: reps)
        
        var myResults = doGetResults(exercise.formalName) ?? []
        myResults.append(result)
        Self.results[exercise.formalName] = myResults
        
        super.finalize(exercise, tag, view, completion )
    }

    override func doGetResults(_ formalName: String) -> [RepsResult]? {
        return Self.results[formalName]
    }

    static var results: [String: [RepsResult]] = [:]
}

