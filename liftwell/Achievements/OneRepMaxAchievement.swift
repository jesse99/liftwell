import Foundation
import UIKit
import os.log

class OneRepMaxAchievement: Achievement {
    init(_ app: AppDelegate) {
        let path = app.getPath(fileName: "OneRepMaxAchievement2")
        if let data = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? Data {
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                
                let store = try decoder.decode(Store.self, from: data)
                self.completed = store.getObjArray("completed")
                let names = store.getStrArray("nextNames")
                let targets = store.getDblArray("nextTargets")
                nextTargets = [:]
                for i in 0..<names.count {
                    nextTargets[names[i]] = targets[i]
                }
            } catch {
                os_log("failed to decode OneRepMaxAchievement from %@: %@", type: .error, path, error.localizedDescription)
                self.completed = []
                nextTargets = [:]
            }
        } else {
            os_log("failed to unarchive OneRepMaxAchievement from %@", type: .error, path)
            self.completed = []
            nextTargets = [:]
        }
    }
    
    func save(_ app: AppDelegate) {
        let path = app.getPath(fileName: "OneRepMaxAchievement2")
        let store = Store()
        store.addObjArray("completed", completed)
        store.addStrArray("nextNames", Array(nextTargets.keys))
        store.addDblArray("nextTargets", Array(nextTargets.values))
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .secondsSince1970
        do {
            let data = try encoder.encode(store)
            app.saveObject(data as AnyObject, path)
        } catch {
            os_log("Error encoding OneRepMaxAchievement: %@", type: .error, error.localizedDescription)
        }
    }
    
    func oldAwards() -> [Award] {
        let app = UIApplication.shared.delegate as! AppDelegate
        return completed.filter({award in
            for exercise in app.program.exercises {
                if let formalName = award.formalName, formalName == exercise.formalName {
                    if app.program.isInUse(exercise) && exercise.main {
                        return true
                    }
                }
            }
            return false
        })
    }
    
    func checkForNewAwards(_ exercise: Exercise) -> [Award] {
        let (awards, _) = getNewAwards(exercise)
        return awards
    }
    
    func updateAwards(_ exercise: Exercise) {
        let app = UIApplication.shared.delegate as! AppDelegate
        if app.program.isInUse(exercise) && exercise.main {
            let (awards, newTarget) = getNewAwards(exercise)
            let nextTarget = nextTargets[exercise.formalName] ?? 0.0
            if !awards.isEmpty {
                completed.append(contentsOf: awards)
                nextTargets[exercise.formalName] = newTarget
                os_log("   setting nextTarget to %.0f (had awards)", type: .error, newTarget)
            } else if nextTarget == 0.0 {
                nextTargets[exercise.formalName] = newTarget
                os_log("   setting nextTarget to %.0f (no award)", type: .error, newTarget)
            }
        }
    }
    
    func upcomingAwards() -> [Award] {
        var completions: [Award] = []
        
        let app = UIApplication.shared.delegate as! AppDelegate
        for exercise in app.program.exercises {
            if app.program.isInUse(exercise) && exercise.main {
                if let weight = exercise.getLastWeight(), weight > 0.0, let reps = exercise.getLastReps(), let max = get1RM(weight, reps), max > 0.0 {
                    let nextTarget = nextTargets[exercise.formalName] ?? advanceTarget(max)
                    let result = Award(
                        key: exercise.formalName + " ccc",
                        title: "\(exercise.formalName) 1RM @ \(Weight.friendlyUnitsStr(nextTarget))",
                        details: "Current 1RM is \(Weight.friendlyUnitsStr(max))",
                        formalName: exercise.formalName,
                        date: nil)
                    completions.append(result)
                }
            }
        }
        
        return completions
    }
    
    private func getNewAwards(_ exercise: Exercise) -> ([Award], Double) {
        var new: [Award] = []
        var newTarget = 0.0
        
        let app = UIApplication.shared.delegate as! AppDelegate
        if app.program.isInUse(exercise) && exercise.main {
            let nextTarget = nextTargets[exercise.formalName] ?? 0.0
            if nextTarget > 0.0 {
                //os_log("weight=%.0f reps=%d 1RM=%.0f nextTarget=%.0f", type: .error, exercise.getLastWeight() ?? 0.0, exercise.getLastReps() ?? 0, get1RM(exercise.getLastWeight() ?? 0.0, exercise.getLastReps() ?? 0) ?? 0.0, nextTarget)
                if let weight = exercise.getLastWeight(), weight > 0.0, let reps = exercise.getLastReps(), let max = get1RM(weight, reps), max >= nextTarget {
                    let result = Award(
                        key: exercise.formalName + " ccc",
                        title: "\(exercise.formalName) 1RM @ \(Weight.friendlyUnitsStr(nextTarget))",
                        details: "1RM was \(Weight.friendlyUnitsStr(max))",
                        formalName: exercise.formalName,
                        date: Date())
                    new.append(result)
                    newTarget = advanceTarget(max)
                    os_log("   adding award '%@', newTarget=%.0f", type: .error, result.title, newTarget)
                }
                
            } else if nextTarget == 0.0 {
                                os_log("weight=%.0f reps=%d 1RM=%.0f", type: .error, exercise.getLastWeight() ?? 0.0, exercise.getLastReps() ?? 0, get1RM(exercise.getLastWeight() ?? 0.0, exercise.getLastReps() ?? 0) ?? 0.0)
                if let weight = exercise.getLastWeight(), weight > 0.0, let reps = exercise.getLastReps(), let max = get1RM(weight, reps), max > 0.0 {
                    newTarget = advanceTarget(max)
                    os_log("   newTarget=%.0f", type: .error, newTarget)
                }
            }
        }
        
        return (new, newTarget)
    }
    
    private func advanceTarget(_ weight: Double) -> Double {
        let delta = findDelta(weight)
        let target = delta*((weight + delta - 1)/delta).rounded(.up)
        return target
    }
    
    private func findDelta(_ weight: Double) -> Double {
        var delta = 0.1 * weight
        delta = 5*(delta/5).rounded(.up)  // TODO: have to revist this for metric units
        return delta
    }

    private var completed: [Award]
    private var nextTargets: [String: Double]
}

// Table is based on Baechle TR, Earle RW, Wathen D (2000). Essentials of Strength Training and Conditioning
// by way of https://exrx.net/Calculators/OneRepMax.
func get1RM(_ weight: Double, _ reps: Int) -> Double? {
    //  reps                    1   2   3   4   5   6   7   8   9  10  11  12  13  14  15
    let percents: [Double] = [100, 95, 93, 90, 87, 85, 83, 80, 77, 75, 72, 67, 66, 66, 65]
    if reps > 0 && reps - 1 < percents.count {
        let percent = percents[reps - 1]/100.0
        let max = weight*(2.0 - percent)
        return max.rounded(.toNearestOrEven)
    }
    return nil
}
