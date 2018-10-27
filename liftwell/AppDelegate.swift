//  Created by Jesse Jones on 10/1/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import UIKit
import UserNotifications
import os.log

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    override init() {
        super.init()

        let path = getPath(fileName: "program_name")
        if let name = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? String {
            program = loadProgram(name)
        }

        if program == nil {
            os_log("failed to load program from %@", type: .info, path)
            program = Mine2() // TODO: use a better default
        }
        
        loadResults()
        
        //        let warmups = Warmups(withBar: 0, firstPercent: 0.5, lastPercent: 0.9, reps: [5, 3, 1])
        //        let plan = AMRAPPlan("default plan", warmups, workSets: 3, workReps: 5)
        //        let plan = CycleRepsPlan("default plan", warmups, numSets: 3, minReps: 4, maxReps: 8)
        //        let plan = VariableRepsPlan("default plan", numSets: 3, minReps: 4, maxReps: 8)
        //        runWeighted(plan)
        
        //        let plan = FiveThreeOneBeginnerPlan("default plan", withBar: 0)
        //        runWeighted(plan, numWorkouts: 20, defaultWeight: 3)
        
        //        let cycles = [
        //            Cycle(withBar: 2, firstPercent: 0.5, warmups: [5, 3, 1, 1, 1], sets: 3, reps: 5, at: 1.0),
        //            Cycle(withBar: 2, firstPercent: 0.5, warmups: [5, 3, 1, 1, 1], sets: 3, reps: 3, at: 1.05),
        //            Cycle(withBar: 2, firstPercent: 0.5, warmups: [5, 3, 1, 1, 1], sets: 3, reps: 1, at: 1.1)
        //        ]
        //        let plan = MastersBasicCyclePlan("default plan", cycles)
        //        runWeighted(plan, numWorkouts: 15, defaultWeight: 2)
        
//        for p in programs {
//            let problems = p.errors()
//            for q in problems {
//                os_log("%@", type: .error, q)
//            }
//            self.assert(problems.isEmpty, "\(p.name) has errors")
//        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            self.notificationsAreEnabled = granted
        }

        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        saveState()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        saveState()
    }
    
    func saveState() {
        saveProgram()
        saveResults()
    }
    
    func saveResults() {
        let path = getPath(fileName: "results")
        let store = Store()
        store.addObjArray("cyclic-results", CyclicRepsSubtype.results)
        store.addObjArray("max-reps-results", MaxRepsSubType.results)
        store.addObjArray("reps-results", RepsSubType.results)
        store.addObjArray("timed-results", TimedSubType.results)
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .secondsSince1970
        do {
            let data = try encoder.encode(store)
            saveObject(data as AnyObject, path)
        } catch {
            os_log("Error encoding program %@: %@", type: .error, program.name, error.localizedDescription)
        }
    }
    
    func scheduleTimerNotification(_ fireDate: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Finished resting."
        content.body = ""
        content.sound = UNNotificationSound.default
        
        let time = fireDate.timeIntervalSinceNow
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time, repeats: false)
        let request = UNNotificationRequest(identifier: "FinishedResting", content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: nil)
    }
    
    func _assert(_ predicate: Bool, _ message: String) {
        if !predicate {
            var controller = self.window?.rootViewController
            while let next = controller?.presentedViewController {
                controller = next
            }
            
            if controller != nil {
                let alert = UIAlertController(title: "Assertion failed", message: message, preferredStyle: .actionSheet)
                
                let action = UIAlertAction(title: "OK", style: .default, handler: {(_) in Swift.assert(false, message)})
                alert.addAction(action)
                
                controller!.present(alert, animated: true, completion:nil)
            } else {
                Swift.assert(false, message)
            }
        }
    }

    
    private func getPath(fileName: String) -> String {
        let dirs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let dir = dirs.first!
        let name = sanitizeFileName(fileName)
        let url = dir.appendingPathComponent("\(name).archive")
        return url.path
    }
    
    private func sanitizeFileName(_ name: String) -> String {
        var result = ""
        
        for ch in name {
            switch ch {
            // All we really should have to re-map is "/" but other characters can be annoying
            // in file names so we'll zap those too. List is from:
            // https://en.wikipedia.org/wiki/Filename#Reserved_characters_and_words
            case "/", "\\", "?", "%", "*", ":", "|", "\"", "<", ">", ".", " ":
                result += "_"
            default:
                result.append(ch)
            }
        }
        
        return result
    }

    private func saveObject(_ object: AnyObject, _ path: String) {
        if NSKeyedArchiver.archiveRootObject(object, toFile: path) {
            //print("saved \(name) to \(path)")
        } else {
            os_log("failed to save to %@", type: .error, path)
        }
    }
    
    private func saveProgram() {
        var path = getPath(fileName: "program_name")
        saveObject(program.name as AnyObject, path)
        
        path = getPath(fileName: "program_" + program.name)
        let store = Store()
        program.save(store)
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .secondsSince1970
        
        do {
            let data = try encoder.encode(store)
            saveObject(data as AnyObject, path)
        } catch {
            os_log("Error encoding program %@: %@", type: .error, program.name, error.localizedDescription)
        }
    }

    private func loadProgram(_ name: String) -> Program? {
        let path = getPath(fileName: "program_" + name)
        if let data = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? Data {
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                let store = try decoder.decode(Store.self, from: data)
                let savedProgram = Program(from: store)
//                if let builtin = programs.first(where: {$0.name == savedProgram.name}) {
//                    os_log("syncing %@", type: .info, builtin.name)
//                    builtin.sync(savedProgram)
//                    return builtin
//                } else {
                    return savedProgram
//                }
            } catch {
                os_log("failed to decode program from %@: %@", type: .error, path, error.localizedDescription)
            }
        } else {
            os_log("failed to unarchive program from %@", type: .error, path)
        }
        return nil
    }
    
    private func loadResults() {
        let path = getPath(fileName: "results")
        if let data = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? Data {
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                let store = try decoder.decode(Store.self, from: data)
                
                CyclicRepsSubtype.results = store.getObjArray("cyclic-results")
                MaxRepsSubType.results = store.getObjArray("max-reps-results")
                RepsSubType.results = store.getObjArray("reps-results")
                TimedSubType.results = store.getObjArray("timed-results")
                
            } catch {
                os_log("failed to decode results from %@: %@", type: .error, path, error.localizedDescription)
            }
        } else {
            os_log("failed to unarchive program from %@", type: .error, path)
        }
    }
    
    var window: UIWindow?
    var program: Program!
    var notificationsAreEnabled = false
}

func assert(_ predicate: Bool, _ message: String) {
    let app = UIApplication.shared.delegate as! AppDelegate
    app._assert(predicate, message)
}
