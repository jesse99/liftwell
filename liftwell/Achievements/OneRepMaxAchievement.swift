import Foundation
import UIKit
import os.log

class OneRepMaxAchievement: Achievement {
    init(_ app: AppDelegate) {
        let path = app.getPath(fileName: "OneRepMaxAchievement")
        if let data = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? Data {
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                
                let store = try decoder.decode(Store.self, from: data)
                self.completed = store.getObjArray("completed")
                self.prevTarget = store.getDbl("prevTarget")
            } catch {
                os_log("failed to decode OneRepMaxAchievement from %@: %@", type: .error, path, error.localizedDescription)
                self.completed = []
                self.prevTarget = 0.0
            }
        } else {
            os_log("failed to unarchive OneRepMaxAchievement from %@", type: .error, path)
            self.completed = []
            self.prevTarget = 0.0
        }
    }
    
    func save(_ app: AppDelegate) {
        let path = app.getPath(fileName: "OneRepMaxAchievement")
        let store = Store()
        store.addObjArray("completed", completed)
        store.addDbl("prevTarget", prevTarget)
        
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
        return completed
    }
    
    func checkForNewAwards(_ exercise: Exercise) -> ([Award], Double) {
        var new: [Award] = []
        var currentTarget = 0.0
        
        if prevTarget > 0.0 {
            let target = nextTarget(prevTarget)
//            os_log("weight=%.0f reps=%d 1RM=%.0f prevTarget=%.0f target=%.0f", type: .error, exercise.getWeight() ?? 0.0, exercise.getReps() ?? 0, get1RM(exercise.getWeight() ?? 0.0, exercise.getReps() ?? 0) ?? 0.0, prevTarget, target)
            if let weight = exercise.getWeight(), weight > 0.0, let reps = exercise.getReps(), let max = get1RM(weight, reps), max >= target {
                let result = Award(title: "\(exercise.formalName) 1RM @ \(Weight.friendlyUnitsStr(target))", details: "1RM was \(Weight.friendlyUnitsStr(max))", date: Date())
                new.append(result)
                currentTarget = nextTarget(max)
//                os_log("   adding award '%@', currentTarget = %.0f", type: .error, result.title, currentTarget)
            }

        } else if prevTarget == 0.0 {
//            os_log("weight=%.0f reps=%d 1RM=%.0f", type: .error, exercise.getWeight() ?? 0.0, exercise.getReps() ?? 0, get1RM(exercise.getWeight() ?? 0.0, exercise.getReps() ?? 0) ?? 0.0)
            if let weight = exercise.getWeight(), weight > 0.0, let reps = exercise.getReps(), let max = get1RM(weight, reps), max > 0.0 {
                currentTarget = nextTarget(max)
//                os_log("   currentTarget = %.0f", type: .error, currentTarget)
            }
        }

        return (new, currentTarget)
    }
    
    func updateAwards(_ exercise: Exercise) {
        let (awards, currentTarget) = checkForNewAwards(exercise)
        if !awards.isEmpty {
            completed.append(contentsOf: awards)
            prevTarget = currentTarget
//            os_log("   setting prevTarget to %.0f (had awards)", type: .error, currentTarget)
        } else if prevTarget == 0.0 {
            prevTarget = currentTarget
//            os_log("   setting prevTarget to %.0f", type: .error, currentTarget)
        }
    }
    
    func upcomingAwards() -> [Award] {
        var completions: [Award] = []
        
        let app = UIApplication.shared.delegate as! AppDelegate
        for exercise in app.program.exercises { // TODO: might want to exclude exercises that were made optional
            if exercise.main {
                if let weight = exercise.getWeight(), weight > 0.0, let reps = exercise.getReps(), let max = get1RM(weight, reps), max > 0.0 {
                    let target = nextTarget(max)
                    let result = Award(title: "\(exercise.formalName) 1RM @ \(Weight.friendlyUnitsStr(target))", details: "Current 1RM is \(Weight.friendlyUnitsStr(max))", date: nil)
                    completions.append(result)
                }
            }
        }
        
        return completions
    }
    
    private func nextTarget(_ weight: Double) -> Double {
        let delta = findDelta(weight)
        let target = delta*(weight/delta).rounded(.up)
        return target
    }
    
    private func findDelta(_ weight: Double) -> Double {
        var delta = 0.1 * weight
        delta = 5*(delta/5).rounded(.up)  // TODO: have to revist this for metric units
        return delta
    }
    
    // Table is based on Baechle TR, Earle RW, Wathen D (2000). Essentials of Strength Training and Conditioning
    // by way of https://exrx.net/Calculators/OneRepMax.
    private func get1RM(_ weight: Double, _ reps: Int) -> Double? {
        //  reps                    1   2   3   4   5   6   7   8   9  10  11  12  13  14  15
        let percents: [Double] = [100, 95, 93, 90, 87, 85, 83, 80, 77, 75, 72, 67, 66, 66, 65]
        if reps > 0 && reps - 1 < percents.count {
            let percent = percents[reps - 1]/100.0
            let max = weight*(2.0 - percent)
            return max.rounded(.toNearestOrEven)
        }
        return nil
    }

    private var completed: [Award]
    private var prevTarget: Double
}
