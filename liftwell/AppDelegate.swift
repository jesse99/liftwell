//  Created by Jesse Jones on 10/1/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import UIKit
import UserNotifications
import os.log

var currentProgram: Program! = nil

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
            program = PhraksGreyskull()
            currentProgram = program
        }
        
        let defaults = UserDefaults.standard
        totalWorkouts = defaults.integer(forKey: "totalWorkouts")
        bodyWeight = defaults.integer(forKey: "bodyWeight")
        if totalWorkouts < program.numWorkouts {    // this is here so that my program has the right totalWorkouts
            totalWorkouts = program.numWorkouts
        }
        
        loadResults()
        loadAchievements()

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
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            self.notificationsAreEnabled = granted
        }

        let oldProgram = currentProgram
        for p in programs {
            currentProgram = p
            let problems = p.errors()
            for q in problems {
                os_log("%@", type: .error, q)
            }
            _assert(problems.isEmpty, "\(p.name) has errors")
        }
        currentProgram = oldProgram

        return true
    }
    
    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        // If there is more than one workout then,
        if program.workouts.count > 1 {
            // only restore if we think the user is probably still on the same workout.
            return shouldRestoreCurrentWorkout()
        }
        return true
    }
    
    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
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
    
    func findNewAwards(_ exercise: Exercise) -> [String] {
        var awards: [String] = []
        
        for achievement in achievements {
            let newAwards = achievement.checkForNewAwards(exercise)
            awards.append(contentsOf: newAwards.map {$0.title})
        }
        
        return awards
    }
    
    func processAwards(_ exercise: Exercise, _ awards: [String], _ view: UIViewController, _ complete: @escaping () -> Void) {
        if !awards.isEmpty {
            let title = awards.count == 1 ? "You have earned a new achievement!" : "You have earned \(awards.count) new achievements!"
            let alert = UIAlertController(title: title, message: awards.joined(separator: "\n"), preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default, handler: {_ in self.updateAwards(exercise); complete()})
            alert.addAction(action)
            
            view.present(alert, animated: true, completion:nil)
        } else {
            updateAwards(exercise)
            complete()
        }
    }
    
    private func updateAwards(_ exercise: Exercise) {
        for achievement in achievements {
            achievement.updateAwards(exercise)
        }
    }
    
    func changeProgram(_ program: Program) {
        for achievement in achievements {
            achievement.save(self)
        }

        if let newProgram = loadProgram(program.name) {
            self.program = newProgram
        } else {
            self.program = program
        }
        currentProgram = self.program
        
        loadAchievements()
    }
    
    func saveState() {
        saveProgram()
        saveResults()
        
        for achievement in achievements {
            achievement.save(self)
        }

        let defaults = UserDefaults.standard
        defaults.set(totalWorkouts, forKey: "totalWorkouts")
        defaults.set(bodyWeight, forKey: "bodyWeight")
        defaults.synchronize()
    }

    func dateWorkoutWasCompleted(_ workout: Workout) -> (Date, Bool, Bool)? {
        func dateWorkoutWasLastCompleted() -> Date? {
            var date: Date? = nil
            
            for name in workout.exercises {
                if let exercise = program.findExercise(name), !workout.optional.contains(name) {
                    if let (completed, _) = exercise.dateCompleted(workout) {
                        if date == nil || completed.compare(date!) == .orderedDescending {
                            date = completed
                        }
                    }
                }
            }
            return date
        }
        
        let date: Date? = dateWorkoutWasLastCompleted()
        
        var partial = false
        var skipped = 0
        var notSkipped = 0
        if let latest = date {
            let calendar = Calendar.current
            for name in workout.exercises {
                if let exercise = program.findExercise(name), !workout.optional.contains(name) {
                    if let (completed, skip) = exercise.dateCompleted(workout) {
                        if !calendar.isDate(completed, inSameDayAs: latest) {   // this won't be exactly right if anyone is crazy enough to do workouts at midnight
                            partial = true
                        }
                        if skip {
                            skipped += 1
                        } else {
                            notSkipped += 1
                        }
                    } else {
                        partial = true
                    }
                }
            }
        }
        
        return date !=  nil ? (date!, partial || (skipped > 0 && skipped != notSkipped), skipped > 0) : nil
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
            
            if controller != nil && UIApplication.shared.applicationState == .active {
                let alert = UIAlertController(title: "Assertion failed", message: message, preferredStyle: .actionSheet)
                
                let action = UIAlertAction(title: "OK", style: .default, handler: {(_) in Swift.assert(false, message)})
                alert.addAction(action)
                
                controller!.present(alert, animated: true, completion:nil)
            } else {
                Swift.assert(false, message)
            }
        }
    }
    
    private func shouldRestoreCurrentWorkout() -> Bool {
        let now = Date.init()
        
        for workout in program.workouts {
            if let candidate = dateWorkoutWasCompleted(workout) {
                let hours = now.hoursSinceDate(candidate.0)
                if hours < 4 {
                    return true
                }
            }
        }
        
        return false
    }

    func getPath(fileName: String) -> String {
        let dirs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let dir = dirs.first!
        let name = sanitizeFileName(fileName)
        let url = dir.appendingPathComponent("\(name).archive")
        return url.path
    }

    func saveObject(_ object: AnyObject, _ path: String) {
        if NSKeyedArchiver.archiveRootObject(object, toFile: path) {
            //print("saved \(name) to \(path)")
        } else {
            os_log("failed to save to %@", type: .error, path)
        }
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
                if let builtin = findBuiltIn(savedProgram.name) {
                    // We use the built-in version so that updates to the exe actually take effect.
                    currentProgram = builtin
                    builtin.sync(savedProgram)
                    return builtin
                } else {
                    currentProgram = savedProgram
                    return savedProgram
                }
            } catch {
                os_log("failed to decode program from %@: %@", type: .error, path, error.localizedDescription)
            }
        } else {
            os_log("failed to unarchive program from %@", type: .error, path)
        }
        return nil
    }
        
    private func findBuiltIn(_ name: String) -> Program? {
        return programs.first(where: {$0.name == name}) 
    }
    
    private func loadAchievements() {
        achievements.removeAll()
        achievements.append(BodyPercentAchievement(self))
        achievements.append(LiftTotalAchievement(self))
        achievements.append(OneRepMaxAchievement(self))
        achievements.append(WorkoutDaysAchievement(self))
    }

    private func loadResults() {
        let path = getPath(fileName: "results")
        if let data = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? Data {
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                let store = try decoder.decode(Store.self, from: data)
                
                AMRAPSubType.results = getStrDict(store, "amrap-results")
                AMRAP1RMSubType.results = getStrDict(store, "amrap-1rm-results")
                CyclicRepsSubType.results = getStrDict(store, "cyclic-results")
                DerivedSubType.results = getStrDict(store, "derived-results")
                EMOMSubType.results = getStrDict(store, "emom-results")
                MaxRepsSubType.results = getStrDict(store, "max-reps-results")
                Percent1RMSubType.results = getStrDict(store, "percent-1rm-results")
                RepsApparatusSubType.results = getStrDict(store, "reps-results")
                RepsBodySubType.results = getStrDict(store, "reps-body-results")
                TimedSubType.results = getStrDict(store, "timed-results")
                T1RepsSubType.results = getStrDict(store, "t1d-results")
                T1LPRepsSubType.results = getStrDict(store, "t1e-results")
                T2RepsSubType.results = getStrDict(store, "t2b-results")
                T3RepsSubType.results = getStrDict(store, "t3b-results")
                
            } catch {
                os_log("failed to decode results from %@: %@", type: .error, path, error.localizedDescription)
            }
        } else {
            os_log("failed to unarchive program from %@", type: .error, path)
        }
    }

    func saveResults() {
        let path = getPath(fileName: "results")
        let store = Store()
        addStrDict(store, "amrap-results", AMRAPSubType.results)
        addStrDict(store, "amrap-1rm-results", AMRAP1RMSubType.results)
        addStrDict(store, "cyclic-results", CyclicRepsSubType.results)
        addStrDict(store, "derived-results", DerivedSubType.results)
        addStrDict(store, "emom-results", EMOMSubType.results)
        addStrDict(store, "max-reps-results", MaxRepsSubType.results)
        addStrDict(store, "percent-1rm-results", Percent1RMSubType.results)
        addStrDict(store, "reps-results", RepsApparatusSubType.results)
        addStrDict(store, "reps-body-results", RepsBodySubType.results)
        addStrDict(store, "timed-results", TimedSubType.results)
        addStrDict(store, "t1d-results", T1RepsSubType.results)
        addStrDict(store, "t1e-results", T1LPRepsSubType.results)
        addStrDict(store, "t2b-results", T2RepsSubType.results)
        addStrDict(store, "t3b-results", T3RepsSubType.results)

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .secondsSince1970
        do {
            let data = try encoder.encode(store)
            saveObject(data as AnyObject, path)
        } catch {
            os_log("Error encoding program %@: %@", type: .error, program.name, error.localizedDescription)
        }
    }
    
    let programs = [Arnold1(), Arnold2(), BestButt14(), BestButt58(), BestButt912(), BodyWeight(), Bootyful3a(), Bootyful3b(), Bootyful3c(), Bootyful14a(), Bootyful14b(), Bootyful14c(), BoringButBig(), BWFMinimalist(), CAP3(), DanJohnA8(), DanJohnB8(), DanJohnC8(), DanJohnF8(), DBCircuit(), DB_PPL(), FiveThreeOneBeginner(), GlutealGoddess1(), GlutealGoddess2(), GlutealGoddess3(), GorgeousGlutes1(), GorgeousGlutes2(), GorgeousGlutes3(), GZCL(), GZCLP3(), GZCLP4(), JackShit(), MastersBarbell(), MastersDB(), Metallicadpa(), Monolith(), Move1(), Move2(), Move3(), Move4(), nSuns4(), NoExcuses(), nSuns5(), PerryComplex(), PHAT(), PhraksGreyskull(), PHUL(), StackComplex(), Stopgap()]

    var window: UIWindow?
    var program: Program!
    var notificationsAreEnabled = false
    
    var totalWorkouts: Int = 0                  // number of workouts independent of which program is in use
    var bodyWeight: Int = 0
    
    var achievements: [Achievement] = []
}

func assert(_ predicate: Bool, _ message: String) {
    let app = UIApplication.shared.delegate as! AppDelegate
    app._assert(predicate, message)
}
