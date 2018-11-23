//  Created by Jesse Jones on 10/6/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import AVFoundation // for kSystemSoundID_Vibrate
import Foundation
import UIKit           // for UIColor
import os.log

public enum ApparatusWeight {
    case weight(Double)
    
    // Training Max is percent * oneRepMax.
    case trainingMax(percent: Double, oneRepMax: Double)
}

extension ApparatusWeight {
    func getWorkingWeight() -> Double {
        switch self {
        case .weight(let weight):
            return weight
        case .trainingMax(percent: let percent, oneRepMax: let max):
            return percent*max
        }
    }
}

/// Base class for Subtypes that use an apparatus.
class ApparatusSubtype {
    init(reps: Int?, restTime: Int, trainingMaxPercent: Double? = nil) {
        if let percent = trainingMaxPercent {
            self.aweight = .trainingMax(percent: percent, oneRepMax: 0.0)
        } else {
            self.aweight = .weight(0.0)
        }
        self.workingReps = reps
        self.restTime = restTime
    }
    
    required init(from store: Store) {
        if store.hasKey("percent") {
            let percent = store.getDbl("percent")
            let max = store.getDbl("max")
            self.aweight = .trainingMax(percent: percent, oneRepMax: max)
            
        } else {
            self.aweight = .weight(store.getDbl("weight"))
        }
        restTime = store.getInt("restTime")
        
        self.currentWorkout = store.getStr("currentWorkout")
        self.activities = store.getObjArray("activities")
        self.numWarmups = store.getInt("numWarmups")
        self.index = store.getInt("index")
        
        let reps = store.getInt("reps")
        let (min, max) = getBaseRepRange()
        if reps > 0 && min < max {
            workingReps = reps
        } else {
            workingReps = nil
        }
    }
    
    func save(_ store: Store) {
        switch aweight {
        case .weight(let weight):
            store.addDbl("weight", weight)
        case .trainingMax(percent: let percent, oneRepMax: let max):
            store.addDbl("percent", percent)
            store.addDbl("max", max)
        }
        store.addInt("reps", workingReps ?? 0)
        store.addInt("restTime", restTime)
        
        store.addStr("currentWorkout", currentWorkout)
        store.addObjArray("activities", activities) // TODO: generate
        store.addInt("numWarmups", numWarmups)
        store.addInt("index", index)
    }
    
    func sync(_ program: Program, _ savedSubtype: ApparatusSubtype, sameSets: Bool) {
        aweight = savedSubtype.aweight
        restTime = savedSubtype.restTime
        
        let (min, max) = getBaseRepRange()  // need to be sure and check this in case the program has changed
        if min < max {
            workingReps = savedSubtype.workingReps
        } else {
            workingReps = nil
        }
        
        if sameSets && program.findWorkout(savedSubtype.currentWorkout) != nil {
            currentWorkout = savedSubtype.currentWorkout
            index = savedSubtype.index
        }
    }
    
    func historyLabel1(_ history: [(Int, Double)]) -> String {
        var labels: [String] = []
        
        for (reps, weight) in history {
            if reps == 1 {
                labels.append("1 @ \(Weight.friendlyUnitsStr(weight))")
            } else {
                labels.append("\(reps) @ \(Weight.friendlyUnitsStr(weight))")
            }
        }
        
        return makeHistoryFromLabels(labels)
    }
    
    // ---- ExerciseInfo ----------------------------------------------------------------------
    var state: ExerciseState {
        get {
            if activities.isEmpty {
                return .waiting
            } else if activities.count == 0 {
                return .error("There is nothing to do")
            } else if index == 0 {
                return .started
            } else if index == activities.count {
                return .finished
            } else {
                return .underway
            }
        }
    }
    
    func on(_ workout: Workout) -> Bool {
        return currentWorkout == workout.name
    }
    
    func label(_ exercise: Exercise) -> String {
        return exercise.name
    }
    
    func current(_ exercise: Exercise) -> Activity {
        return index < activities.count ? activities[index] : activities.last!
    }
    
    func restSound() -> UInt32 {
        return kSystemSoundID_Vibrate
    }
    
    func completions(_ exercise: Exercise) -> [Completion] {
        if index+1 < activities.count {
            return [Completion(title: "", info: "", callback: {self.index += 1})]
        } else {
            return [Completion(title: "", info: "", callback: {self.index = self.activities.count})]
        }
    }
    
    func finalize(_ exercise: Exercise, _ tag: ResultTag, _ view: UIViewController, _ completion: @escaping () -> Void) {
        let weight = aweight.getWorkingWeight()
        
        switch exercise.type {
        case .body(_): completion()
        case .weights(let type):
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
            let (minReps, maxReps) = getBaseRepRange()
            let variableReps = minReps != maxReps
            
            let label4 = variableReps ? "4 reps" : advanceWeightLabel(exercise, weight, by: 4)
            let label3 = variableReps ? "3 reps" : advanceWeightLabel(exercise, weight, by: 3)
            let label2 = variableReps ? "2 reps" : advanceWeightLabel(exercise, weight, by: 2)
            let label1 = variableReps ? "1 rep" : advanceWeightLabel(exercise, weight, by: 1)
            let dlabel1 = variableReps ? "1 rep" : advanceWeightLabel(exercise, weight, by: -1)
            let dlabel2 = variableReps ? "2 reps" : advanceWeightLabel(exercise, weight, by: -2)
            let dlabel3 = variableReps ? "3 reps" : advanceWeightLabel(exercise, weight, by: -3)
            
            let advance4 = UIAlertAction(title: "Advance by \(label4)", style: .default) {_ in self.doAdvance(type.apparatus, 4); completion()}
            let advance3 = UIAlertAction(title: "Advance by \(label3)", style: .default) {_ in self.doAdvance(type.apparatus, 3); completion()}
            let advance2 = UIAlertAction(title: "Advance by \(label2)", style: .default) {_ in self.doAdvance(type.apparatus, 2); completion()}
            let advance = UIAlertAction(title: "Advance by \(label1)", style: .default) {_ in self.doAdvance(type.apparatus, 1); completion()}
            let maintain = UIAlertAction(title: "Maintain", style: .default) {_ in completion()}
            let deload = UIAlertAction(title: "Deload by \(dlabel1)", style: .default) {_ in self.doAdvance(type.apparatus, -1); completion()}
            let deload2 = UIAlertAction(title: "Deload by \(dlabel2)", style: .default) {_ in self.doAdvance(type.apparatus, -2); completion()}
            let deload3 = UIAlertAction(title: "Deload by \(dlabel3)", style: .default) {_ in self.doAdvance(type.apparatus, -3); completion()}
            
            switch tag {
            case .easy:
                alert.addAction(advance4)
                alert.addAction(advance3)
                alert.addAction(advance2)
                alert.addAction(advance)
                alert.addAction(maintain)
                alert.preferredAction = advance2
                
            case .normal:
                alert.addAction(advance2)
                alert.addAction(advance)
                alert.addAction(maintain)
                alert.preferredAction = advance
                
            case .hard:
                alert.addAction(advance)
                alert.addAction(maintain)
                alert.addAction(deload)
                alert.preferredAction = maintain
                
            case .failed:
                alert.addAction(advance)
                alert.addAction(maintain)
                alert.addAction(deload)
                alert.addAction(deload2)
                alert.addAction(deload3)
                alert.preferredAction = deload
            }
            
            view.present(alert, animated: true, completion: nil)
        }
    }
    
    func reset() {
        index = 0
    }
    
    func getBaseRepRange() -> (Int, Int) {
        assert(false)   // subclasses implement this
        return (0, 0)
    }
    
    private func doAdvance(_ apparatus: Apparatus, _ amount: Int) {
        var weight = aweight.getWorkingWeight()
        
        let delta = amount.signum()
        if var reps = workingReps {
            let (min, max) = getBaseRepRange()
            for _ in 0..<abs(amount) {
                if reps + delta > max {
                    let w = Weight(weight, apparatus)
                    reps = min
                    weight = w.nextWeight()
                } else if reps + delta < min {
                    let w = Weight(weight, apparatus)
                    reps = max
                    weight = w.prevWeight()
                } else {
                    reps += delta
                }
            }
            workingReps = reps
        } else {
            for _ in 0..<abs(amount) {
                let w = Weight(weight, apparatus)
                if delta > 0 {
                    weight = w.nextWeight()
                } else {
                    weight = w.prevWeight()
                }
            }
        }
        
        setWorkingWeight(weight)
    }
    
    func setWorkingWeight(_ weight: Double) {
        switch aweight {
        case .weight(_):
            aweight = .weight(weight)
        case .trainingMax(percent: let percent, oneRepMax: _):
            let (_, maxReps) = getBaseRepRange()
            let reps = workingReps ?? maxReps
            if let max = get1RM(weight, reps) {
                aweight = .trainingMax(percent: percent, oneRepMax: max)
            } else {
                aweight = .trainingMax(percent: percent, oneRepMax: 0.0)    // not clear what we should do here but at least this will be obviously wrong
            }
        }
    }
    
    var aweight: ApparatusWeight  // starts out at 0.0
    var workingReps: Int?         // set when minReps < maxReps, also this can be less than minReps
    var restTime: Int
    
    var activities: [Activity] = []
    var numWarmups: Int = 0
    var currentWorkout = ""
    var index: Int = 0
}
