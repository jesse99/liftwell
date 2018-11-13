//  Created by Jesse Jones on 11/11/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation
import UIKit
import os.log

class LiftTotalAchievement: Achievement {
    init(_ app: AppDelegate) {
        let path = app.getPath(fileName: "LiftTotalAchievement-" + app.program.name)
        if let data = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? Data {
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                
                let store = try decoder.decode(Store.self, from: data)
                self.completed = store.getObjArray("completed")
                nextTarget = store.getDbl("nextTarget")
            } catch {
                os_log("failed to decode LiftTotalAchievement from %@: %@", type: .error, path, error.localizedDescription)
                self.completed = []
                nextTarget = 0.0
            }
        } else {
            os_log("failed to unarchive LiftTotalAchievement from %@", type: .error, path)
            self.completed = []
            nextTarget = 0.0
        }
    }
    
    func save(_ app: AppDelegate) {
        let path = app.getPath(fileName: "LiftTotalAchievement-" + app.program.name)
        let store = Store()
        store.addObjArray("completed", completed)
        store.addDbl("nextTarget", nextTarget)
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .secondsSince1970
        do {
            let data = try encoder.encode(store)
            app.saveObject(data as AnyObject, path)
        } catch {
            os_log("Error encoding LiftTotalAchievement: %@", type: .error, error.localizedDescription)
        }
    }
    
    func oldAwards() -> [Award] {
        return completed
    }
    
    func checkForNewAwards(_ exercise: Exercise) -> [Award] {
        let (awards, _) = getNewAwards(exercise)
        return awards
    }
    
    func updateAwards(_ exercise: Exercise) {
        let (awards, newTarget) = getNewAwards(exercise)
        if !awards.isEmpty {
            completed.append(contentsOf: awards)
            nextTarget = newTarget
            os_log("   setting nextTarget to %.0f (had awards)", type: .error, newTarget)
        } else if nextTarget == 0.0 {
            nextTarget = newTarget
            os_log("   setting nextTarget to %.0f (no award)", type: .error, newTarget)
        }
    }
    
    func upcomingAwards() -> [Award] {
        var completions: [Award] = []
        
        let total = findCurrentToal()
        if nextTarget > 0.0 {
            let result = Award(
                key: "AAA lift totals",
                title: "Main lifts 1RM total @ \(Weight.friendlyUnitsStr(nextTarget))",
                details: "Total was \(Weight.friendlyUnitsStr(total))",
                formalName: nil,
                date: nil)
            completions.append(result)
        }
        
        return completions
    }
    
    private func getNewAwards(_ exercise: Exercise) -> ([Award], Double) {
        var new: [Award] = []
        var newTarget = 0.0
        let total = findCurrentToal()
        
        if nextTarget > 0.0 {
            os_log("total=%.0f nextTarget=%.0f", type: .error, total, nextTarget)
            if total >= nextTarget {
                while total >= advanceTarget(nextTarget) {
                    nextTarget = advanceTarget(nextTarget)
                }
                let result = Award(
                    key: "AAA lift totals",
                    title: "Main lifts 1RM total @ \(Weight.friendlyUnitsStr(nextTarget))",
                    details: "Total was \(Weight.friendlyUnitsStr(total))",
                    formalName: nil,
                    date: Date())
                new.append(result)
                newTarget = advanceTarget(total)
                os_log("   adding award '%@', newTarget=%.0f", type: .error, result.title, newTarget)
            }
            
        } else if nextTarget == 0.0 {
            os_log("total=%.0f", type: .error, total)
            if total > 0.0 {
                newTarget = advanceTarget(total)
                os_log("   newTarget=%.0f", type: .error, newTarget)
            }
        }
        
        return (new, newTarget)
    }
    
    private func advanceTarget(_ weight: Double) -> Double {
        let target = 100*((weight / 100).rounded(.down) + 1)
        return target
    }
    
    private func findCurrentToal() -> Double {
        var total = 0.0
        let app = UIApplication.shared.delegate as! AppDelegate
        for exercise in app.program.exercises {
            if app.program.isInUse(exercise) && exercise.main {
                if let weight = exercise.getWeight(), weight > 0.0, let reps = exercise.getReps(), let max = get1RM(weight, reps) {
                    total += max
                }
            }
        }
        return total
    }

    private var completed: [Award]
    private var nextTarget: Double
}
