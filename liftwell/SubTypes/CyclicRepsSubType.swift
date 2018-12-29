//  Created by Jesse Jones on 10/6/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import AVFoundation // for kSystemSoundID_Vibrate
import Foundation
import UIKit           // for UIColor
import os.log

enum AdvanceOn {
    case dont           // -1
    case always         // -2
    case lastCycle      // -3
    case onCycle(Int)   // 0,,<n
}

/// Sets/reps/percents vary from week to week.
class CyclicRepsSubType: BaseCyclicRepsSubType {
    private typealias `Self` = CyclicRepsSubType
    
    /// trainingMaxPercent is a percent of 1RM
    /// resetIndex is when to automatically reset weight to zero (so that a training max can be re-computed)
    init(_ cycles: [Sets], restSecs: Int, advance: AdvanceOn, trainingMaxPercent: Double? = nil, resetIndex: [Int] = []) {
        self.advance = advance
        self.resetIndexes = resetIndex
        super.init(cycles, restSecs: restSecs, trainingMaxPercent: trainingMaxPercent)
    }
    
    required init(from store: Store) {
        let i = store.getInt("promptIndex", ifMissing: 0)
        switch i {
        case -1: self.advance = .dont
        case -2: self.advance = .always
        case -3: self.advance = .lastCycle
        default: self.advance = .onCycle(i)
        }
        self.resetIndexes = store.getIntArray("resetIndexes", ifMissing: [])
        super.init(from: store)
    }
    
    override func save(_ store: Store) {
        switch advance {
        case .dont: store.addInt("promptIndex", -1)
        case .always: store.addInt("promptIndex", -2)
        case .lastCycle: store.addInt("promptIndex", -3)
        case .onCycle(let n): store.addInt("promptIndex", n)
        }
        store.addIntArray("resetIndexes", resetIndexes)
        super.save(store)
    }
    
    override func clone() -> ExerciseInfo {
        let store = Store()
        store.addObj("self", self)
        let result: Self = store.getObj("self")
        return result
    }
    
    override func fixedDifficulty() -> ResultTag? {
        return canAdvance(cycleIndex) ? nil : .normal
    }
    
    override func doFinalize(_ exercise: Exercise, _ tag: ResultTag, _ reps: Int, _ view: UIViewController, _ completion: @escaping () -> Void) {
        let baseWeight = aweight.getBaseWorkingWeight()
        var liftedWeight = baseWeight
        if let last = cycles[cycleIndex].worksets.last {
            if case .weights(let type) = exercise.type {
                let w = Weight(baseWeight*last.percent, type.apparatus).closest()
                liftedWeight = w.weight
            }
        }
        
        let result = CyclicResult(tag, baseWeight: baseWeight, liftedWeight: liftedWeight, cycleIndex: cycleIndex, reps: reps)
        
        var myResults = Self.results[exercise.formalName] ?? []
        myResults.append(result)
        Self.results[exercise.formalName] = myResults
        
        let oldIndex = cycleIndex
        cycleIndex = (cycleIndex + 1) % cycles.count
        if resetIndexes.contains(cycleIndex) {
            switch aweight {
            case .trainingMax(percent: let percent, oneRepMax: _):
                aweight = .trainingMax(percent: percent, oneRepMax: 0.0)
            case .weight(_):
                aweight = .weight(0.0)
            }
        }
        if canAdvance(oldIndex) {
            // Prompt user for advancement
            super.presentFinalize(exercise, tag, view, completion)
        } else {
            completion()
        }
    }
    
    private func canAdvance(_ index: Int) -> Bool {
        switch advance {
        case .dont: return false
        case .always: return true
        case .lastCycle: return index + 1 == cycles.count
        case .onCycle(let n): return index == n
        }
    }

    override func doGetResults(_ exercise: Exercise) -> [CyclicResult]? {
        return Self.results[exercise.formalName]
    }
    
    var advance: AdvanceOn
    var resetIndexes: [Int] = []
    static var results: [String: [CyclicResult]] = [:]
}
