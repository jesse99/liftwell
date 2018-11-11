//  Created by Jesse Jones on 11/10/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation
import UIKit
import os.log

fileprivate let MinDays = 5

class WorkoutDaysAchievement: Achievement {
    init(_ app: AppDelegate) {
        let path = app.getPath(fileName: "WorkoutDaysAchievement")
        if let data = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? Data {
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                
                let store = try decoder.decode(Store.self, from: data)
                self.completed = store.getObjArray("completed")
                nextTarget = store.getInt("nextTarget")
            } catch {
                os_log("failed to decode WorkoutDaysAchievement from %@: %@", type: .error, path, error.localizedDescription)
                self.completed = []
                nextTarget = MinDays
            }
        } else {
            os_log("failed to unarchive WorkoutDaysAchievement from %@", type: .error, path)
            self.completed = []
            nextTarget = MinDays
        }
    }
    
    func save(_ app: AppDelegate) {
        let path = app.getPath(fileName: "WorkoutDaysAchievement")
        let store = Store()
        store.addObjArray("completed", completed)
        store.addInt("nextTarget", nextTarget)
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .secondsSince1970
        do {
            let data = try encoder.encode(store)
            app.saveObject(data as AnyObject, path)
        } catch {
            os_log("Error encoding WorkoutDaysAchievement: %@", type: .error, error.localizedDescription)
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
            //                os_log("   setting nextTarget to %.0f (had awards)", type: .error, newTarget)
        }
    }
    
    func upcomingAwards() -> [Award] {
        var completions: [Award] = []
        
        let app = UIApplication.shared.delegate as! AppDelegate
        let result = Award(
            key: "zzzWorked out days",
            title: "Worked out \(nextTarget) days",
            details: app.totalWorkouts == 1 ? "Currently at 1 day" : "Currently at \(app.totalWorkouts) days",
            date: nil)
        completions.append(result)
        
        return completions
    }
    
    private func getNewAwards(_ exercise: Exercise) -> ([Award], Int) {
        var new: [Award] = []
        var newTarget = 0
        
        let app = UIApplication.shared.delegate as! AppDelegate
        //                os_log("weight=%.0f reps=%d 1RM=%.0f nextTarget=%.0f", type: .error, exercise.getWeight() ?? 0.0, exercise.getReps() ?? 0, get1RM(exercise.getWeight() ?? 0.0, exercise.getReps() ?? 0) ?? 0.0, nextTarget)
        if app.totalWorkouts >= nextTarget {
            let result = Award(
                key: "Worked out days",
                title: "Worked out \(nextTarget) days",
                details: "",
                date: Date())
            new.append(result)
            newTarget = findNext(app.totalWorkouts)
            //                    os_log("   adding award '%@', newTarget=%.0f", type: .error, result.title, newTarget)
        }
        
        return (new, newTarget)
    }
    
    private func findNext(_ count: Int) -> Int {
        if count < MinDays {
            return MinDays
        } else if count < 10 {
            return 10
        } else if count < 25 {
            return 25
        } else if count < 50 {
            return 50
        } else {
            return 50*((count / 50) + 1)
        }
    }
    
    private var completed: [Award]
    private var nextTarget: Int
}
