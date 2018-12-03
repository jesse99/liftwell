//  Created by Jesse Jones on 12/2/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import AVFoundation // for kSystemSoundID_Vibrate
import Foundation
import UIKit           // for UIColor
import os.log

/// Like RepsApparatusSubType except that the weight is a percentage of another exercise
class PercentSubType: BaseRepsApparatusSubType {
    private typealias `Self` = PercentSubType
    
    init(_ sets: Sets, percent: Double, other: String, restSecs: Int) {
        self.percent = percent
        self.otherName = other
        super.init(sets, restSecs: restSecs, trainingMaxPercent: nil)
    }
    
    required init(from store: Store) {
        self.percent = store.getDbl("otherPercent")
        self.otherName = store.getStr("otherName")
        super.init(from: store)
    }
    
    override func save(_ store: Store) {
        store.addDbl("otherPercent", percent)
        store.addStr("otherName", otherName)
        super.save(store)
    }
    
    override func clone() -> ExerciseInfo {
        let store = Store()
        store.addObj("self", self)
        let result: Self = store.getObj("self")
        return result
    }
    
    override func errors() -> [String] {
        var errs: [String] = []
        
        let app = UIApplication.shared.delegate as! AppDelegate
        if let other = app.program.findExercise(otherName) {
            switch other.type {
            case .body(_):
                errs.append("Exercise \(otherName) doesn't use an apparatus.")
            case .weights(_):
                break
            }
        } else {
            errs.append("Couldn't find an exercise named \(otherName).")
        }
        errs.append(contentsOf: super.errors())
        return errs
    }
    
    override func prevLabel(_ exercise: Exercise) -> (String, UIColor) {
        if otherWeight() != nil {
            return super.prevLabel(exercise)
        } else {
            return ("Do '\(otherName)' first", UIColor.red)
        }
    }
    
    override func doFinalize(_ exercise: Exercise, _ tag: ResultTag, _ reps: Int, _ view: UIViewController, _ completion: @escaping () -> Void) {
        switch exercise.type {
        case .body(_):
            assert(false)
        case .weights(let type):
            let baseWeight = otherWeight() ?? 0.0
            let liftedWeight = sets.bweight(percent*baseWeight, type.apparatus, worksetBias())
            let result = RepsResult(tag, baseWeight: baseWeight, liftedWeight: liftedWeight.weight, reps: reps)
            
            var myResults = doGetResults(exercise) ?? []
            myResults.append(result)
            Self.results[exercise.formalName] = myResults
        }
        
        completion()
    }
    
    override func doGetResults(_ exercise: Exercise) -> [RepsResult]? {
        return Self.results[exercise.formalName]
    }
    
    override func getBaseWorkingWeight() -> Double {
        return percent*(otherWeight() ?? 0.0)
    }
    
    override func needToFindWeight() -> Bool {
        return false
    }
    
    override func worksetBias() -> Int {
        if percent < 1.0 {
            return -1
        } else if percent > 1.0 {
            return 1
        } else {
            return 0
        }
    }
    
    private func otherWeight() -> Double? {
        if let other = currentProgram.findExercise(otherName) {
            switch other.type {
            case .body(_):
                return 0.0
            case .weights(let type):
                switch type.subtype {
                case .cyclic(_):
                    if let results = CyclicRepsSubtype.results[other.formalName], let last = results.last {
                        return last.liftedWeight
                    }
                case .find(_):
                    assert(false)
                    return 0.0
                case .percent(_):
                    if let results = PercentSubType.results[other.formalName], let last = results.last {
                        return last.liftedWeight
                    }
                case .reps(_):
                    if let results = RepsApparatusSubType.results[other.formalName], let last = results.last {
                        return last.liftedWeight
                    }
                case .t1(_):
                    if let results = T1RepsSubType.results[other.formalName], let last = results.last {
                        return last.liftedWeight
                    }
                case .t2(_):
                    if let results = T2RepsSubType.results[other.formalName], let last = results.last {
                        return last.liftedWeight
                    }
                case .t3(_):
                    if let results = T3RepsSubType.results[other.formalName], let last = results.last {
                        return last.liftedWeight
                    }
                case .timed(_):
                    return 0.0
                }
            }
        }
        return nil
    }
    
    var percent: Double
    var otherName: String
    static var results: [String: [RepsResult]] = [:]
}

