//  Created by Jesse Jones on 11/24/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation
import UIKit

/// GZCLP scheme with fixed sets and reps but where the last set is AMRAP. Weight goes up when can
/// do 25 reps on the AMRAP set.
class T3RepsSubType: BaseRepsSubType {
    private typealias `Self` = T3RepsSubType
    
    override init(_ sets: Sets, restSecs: Int, trainingMaxPercent: Double? = nil) {
        super.init(sets, restSecs: restSecs, trainingMaxPercent: trainingMaxPercent)
    }
    
    required init(from store: Store) {
        super.init(from: store)
    }
    
    override func errors() -> [String] {
        var problems: [String] = super.errors()
        if let last = sets.worksets.last, !last.amrap {
            problems.append("Last set should be AMRAP.")
        }
        return problems
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
        
        if amrapReps! >= 25 {
            switch exercise.type {
            case .body(_): break
            case .weights(let type):
                var weight = aweight.getWorkingWeight()
                let w = Weight(weight, type.apparatus)
                weight = w.nextWeight()
                setWorkingWeight(weight)
            }
            completion()
        } else {
            completion()
        }
    }

    override func doGetResults(_ formalName: String) -> [RepsResult]? {
        return Self.results[formalName]
    }
    
    static var results: [String: [RepsResult]] = [:]
}

