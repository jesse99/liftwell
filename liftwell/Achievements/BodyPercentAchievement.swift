//  Created by Jesse Jones on 11/10/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation
import UIKit
import os.log

fileprivate let Step = 0.10

class BodyPercentAchievement: Achievement {
    init(_ app: AppDelegate) {
        let path = app.getPath(fileName: "BodyPercentAchievement2")
        if let data = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? Data {
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                
                let store = try decoder.decode(Store.self, from: data)
                self.completed = store.getObjArray("completed")
                let names = store.getStrArray("nextNames")
                let percents = store.getDblArray("nextPercents")
                nextPercents = [:]
                for i in 0..<names.count {
                    nextPercents[names[i]] = percents[i]
                }
            } catch {
                os_log("failed to decode BodyPercentAchievement from %@: %@", type: .error, path, error.localizedDescription)
                self.completed = []
                nextPercents = [:]
            }
        } else {
            os_log("failed to unarchive BodyPercentAchievement from %@", type: .error, path)
            self.completed = []
            nextPercents = [:]
        }
    }
    
    func save(_ app: AppDelegate) {
        let path = app.getPath(fileName: "BodyPercentAchievement2")
        let store = Store()
        store.addObjArray("completed", completed)
        store.addStrArray("nextNames", Array(nextPercents.keys))
        store.addDblArray("nextPercents", Array(nextPercents.values))
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .secondsSince1970
        do {
            let data = try encoder.encode(store)
            app.saveObject(data as AnyObject, path)
        } catch {
            os_log("Error encoding BodyPercentAchievement: %@", type: .error, error.localizedDescription)
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
            let (awards, newPercent) = getNewAwards(exercise)
            let nextPercent = nextPercents[exercise.formalName] ?? 0.0
            if !awards.isEmpty {
                completed.append(contentsOf: awards)
                nextPercents[exercise.formalName] = newPercent
//                os_log("   setting nextPercent to %.2f (had awards)", type: .error, newPercent)
            } else if nextPercent == 0.0 {
                nextPercents[exercise.formalName] = newPercent
//                os_log("   setting nextPercent to %.2f (no awards)", type: .error, newPercent)
            }
        }
    }
    
    func upcomingAwards() -> [Award] {
        var completions: [Award] = []
        
        let app = UIApplication.shared.delegate as! AppDelegate
        for exercise in app.program.exercises {
            if app.program.isInUse(exercise) && exercise.main && app.bodyWeight > 0 {
                if let weight = exercise.getLastWeight(), weight > 0.0 {
                    var nextPercent = nextPercents[exercise.formalName] ?? 0.0
                    let currentPercent = weight/Double(app.bodyWeight)
                    while currentPercent + Step/10 > nextPercent {
                        nextPercent = advanceTarget(nextPercent)
                    }
                    let result = Award(
                        key: exercise.formalName + " aaa",
                        title: "\(exercise.formalName) @ body weight x \(Int(nextPercent*100))%",
                        details: "Current is \(Int(100*currentPercent))% of body weight",
                        formalName: exercise.formalName,
                        date: nil)
                    completions.append(result)
                }
            } else if app.bodyWeight == 0 {
                let percent = advanceTarget(0.0)
                let result = Award(
                    key: exercise.formalName + " aaa",
                    title: "Main lifts @ \(Int(percent*100))% of body weight",
                    details: "Use options to set body weight",
                    formalName: nil,
                    date: nil)
                completions.append(result)
                break
            }
        }
        
        return completions
    }
    
    private func getNewAwards(_ exercise: Exercise) -> ([Award], Double) {
        var new: [Award] = []
        var newPercent = 0.0
        
        let app = UIApplication.shared.delegate as! AppDelegate
        if app.program.isInUse(exercise) && exercise.main && app.bodyWeight > 0 {
            let nextPercent = nextPercents[exercise.formalName] ?? 0.0
            let nextTarget = Double(app.bodyWeight) * nextPercent
//            os_log("nextPercent=%.2f nextTarget=%.2f", type: .error, nextPercent, nextTarget)
            if let weight = exercise.getLastWeight() {
                if nextTarget > 0.0 && weight >= nextTarget {
                    let result = Award(
                        key: exercise.formalName + " aaa",
                        title: "\(exercise.formalName) @ body weight x \(Int(nextPercent*100))%",
                        details: "Was at \(Int(100*weight/Double(app.bodyWeight)))% of body weight",
                        formalName: exercise.formalName,
                        date: Date())
                    new.append(result)
                    newPercent = advanceTarget(nextPercent)
//                    os_log("   adding award '%@', weight=%.2f", type: .error, result.title, weight)
                }

                newPercent = nextPercent
                let currentPercent = weight/Double(app.bodyWeight)
                while currentPercent + Step/10 > newPercent {
                    newPercent = advanceTarget(newPercent)
                }
            }
        }
        
        return (new, newPercent)
    }
    
    private func advanceTarget(_ percent: Double) -> Double {
        return percent + Step
    }
    
    private var completed: [Award]
    private var nextPercents: [String: Double]
}
