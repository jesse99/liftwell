//  Created by Jesse Jones on 10/1/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import UIKit

class WorkoutsTabController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusLabel.numberOfLines = 0 // default is to only allow 1 line
        
        tableView.dataSource = self
        tableView.delegate = self
        
        //tableView.backgroundColor = targetColor(.background)
        statusLabel.backgroundColor = tableView.backgroundColor
        view.backgroundColor = tableView.backgroundColor
        view.setNeedsDisplay()
        
        let notify = NotificationCenter.default
        notify.addObserver(self, selector: #selector(WorkoutsTabController.enteringForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
    }
    
    override func applicationFinishedRestoringState() {
    }
    
    @objc func enteringForeground() {
        // Enough time may have passed that we need to redo our labels.
        //presults.updateCardio()   // TODO
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //dismissTooltip()  // TODO
        statusLabel.text = "Worked out 1000 times over six months."
        //        statusLabel.text = WorkoutsTabController.getWorkoutSummary()  // TODO: add a real workout summary
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //        var shown = false // TODO: tooltips
        //        if let bar = tabBarController, let items = bar.tabBar.items {
        //            shown = showTooltip(superview: nil, forItem: items[ProgramsTabIndex], "Select a program to follow.", .bottom, id: "select_program")
        //        }
        
        //        let text = "Workouts are normally meant to be done within a single day with a day or two of rest between workouts. The workout that should be done next is highlighted."
        //        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        //        if let missingIndex = findFirstMissingWorkout() {
        //            let path = IndexPath(row: missingIndex, section: 0)
        //            tableView.scrollToRow(at: path, at: .middle, animated: true)
        //
        //            if let cell = cell, !shown {
        //                shown = showTooltip(superview: view, forView: cell, text, .top, id: "completed_workout")
        //            }
        //        } else {
        //            if let oldestIndex = findOldestWorkout() {
        //                let path = IndexPath(row: oldestIndex, section: 0)
        //                tableView.scrollToRow(at: path, at: .middle, animated: true)
        //                if let cell = cell, !shown {
        //                    shown = showTooltip(superview: view, forView: cell, text, .top, id: "completed_workout")
        //                }
        //            }
        //        }
        
        //        let app = UIApplication.shared.delegate as! AppDelegate
        //        if !shown && presults.numWorkouts >= 3*4 && !app.product.purchased(ID: EditProgramProductID) {
        //            if let bar = tabBarController, let items = bar.tabBar.items {
        //                shown = showTooltip(superview: nil, forItem: items[ProgramsTabIndex], "You can change every facet of your program using edit. For example you can add or replace exercises or add new workouts for cardio or stretching.", .bottom, id: "can_edit")
        //            }
        //        }
        //
        //        if !shown && UserDefaults.standard.object(forKey: "pressed-review") == nil {
        //            let mesg = "Please consider writing an app review. Even just a few sentences would help to make the app more popular and better supported."
        //            if presults.numWorkouts >= 60 {
        //                if let bar = tabBarController, let items = bar.tabBar.items {
        //                    shown = showTooltip(superview: nil, forItem: items[MoreTabIndex], mesg, .bottom, id: "please_review_60")
        //                    supressTooltip(id: "please_review_30")
        //                    supressTooltip(id: "please_review_10")
        //                }
        //            } else if presults.numWorkouts >= 30 {
        //                if let bar = tabBarController, let items = bar.tabBar.items {
        //                    shown = showTooltip(superview: nil, forItem: items[MoreTabIndex], mesg, .bottom, id: "please_review_30")
        //                    supressTooltip(id: "please_review_10")
        //                }
        //            } else if presults.numWorkouts >= 10 {
        //                if let bar = tabBarController, let items = bar.tabBar.items {
        //                    shown = showTooltip(superview: nil, forItem: items[MoreTabIndex], mesg, .bottom, id: "please_review_10")
        //                }
        //            }
        //        }
    }
    
    @IBAction func unwindToWorkouts(_ segue:UIStoryboardSegue) {
        tableView.reloadData()
        statusLabel.text = "Worked out 1000 times over six months."
//        statusLabel.text = WorkoutsTabController.getWorkoutSummary()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let app = UIApplication.shared.delegate as! AppDelegate
        return app.program.workouts.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt path: IndexPath) {
        let index = path.item
        let app = UIApplication.shared.delegate as! AppDelegate
        let workout = app.program.workouts[index]

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "WorkoutID") as! WorkoutController
        view.initialize(workout, "Workouts")
        present(view, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt path: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutsCellID")!
        cell.backgroundColor = tableView.backgroundColor
        
        let index = path.item
        let app = UIApplication.shared.delegate as! AppDelegate
        let workout = app.program.workouts[index]
        cell.textLabel!.text = workout.name
        cell.detailTextLabel!.text = ""

        if !hasActiveExercise(workout) {
            cell.detailTextLabel!.text = "inactive"
            //        } else if allCardio(workout) { // TODO
            //            // Cardio is typically spread out through the week so we don't care
            //            // so much about when it was last performed.
            //            cell.detailTextLabel!.text = getCardioDetails(workout)
        } else {
            cell.detailTextLabel!.text = ""
        }

        let todays = findTodaysWorkouts()
        if todays.contains(index) {
            // Highlight any workouts the user is currently performing (can be multiple if he is switching between
            // something like mobility and a lifting workout).
            cell.detailTextLabel!.text = "in progress"
            let color = UIColor.red             // TODO: use targetColor
            cell.textLabel!.setColor(color)
            cell.detailTextLabel!.setColor(color)

        } else {
            // Otherwise highlight the first workout the user hasn't completed or the oldest completed workout.
            let selectedIndex = findFirstMissingWorkout() ?? findOldestWorkout() ?? app.program.workouts.count
            var color = selectedIndex == index && todays.isEmpty ? UIColor.red : UIColor.black

            let app = UIApplication.shared.delegate as! AppDelegate
            if let (date, partial, skipped) = app.dateWorkoutWasCompleted(workout) {
                let calendar = Calendar.current
                if skipped {
                    if partial {
                        cell.detailTextLabel!.text = "partially skipped \(date.daysName())"
                    } else {
                        cell.detailTextLabel!.text = "skipped \(date.daysName())"
                    }
                } else if calendar.isDate(date, inSameDayAs: Date()) && partial {
                    cell.detailTextLabel!.text = "in progress"
                } else if calendar.isDate(date, inSameDayAs: Date()) && !partial {
                    cell.detailTextLabel!.text = "finished today"
                    color = .lightGray
                } else if partial {
                    cell.detailTextLabel!.text = "partially completed \(date.daysName())"
                } else {
                    cell.detailTextLabel!.text = "completed \(date.daysName())"
                }

            } else {
                cell.detailTextLabel!.text = "not completed"
            }

            cell.textLabel!.setColor(color)
            cell.detailTextLabel!.setColor(color)
        }
        
        return cell
    }
    
    // Returns the workouts being executed atm (but not those that have finished executing).
    private func findTodaysWorkouts() -> [Int] {
//        func isUnderway(_ workout: Workout) -> Bool {
//            let app = UIApplication.shared.delegate as! AppDelegate
//            for name in workout.exercises {
//                if let exercise = app.program.findExercise(name), !workout.optional.contains(name) {
//                    let info = exercise.getInfo()
//                    if case .underway = info.state, info.on(workout) {
//                        return true
//                    }
//                }
//            }
//            return false
//        }

        func numCompleted(_ workout: Workout) -> Int {
            var count = 0
            let app = UIApplication.shared.delegate as! AppDelegate
            let calendar = Calendar.current
            for name in workout.exercises {
                if let exercise = app.program.findExercise(name), !workout.optional.contains(name) {
                    if let (completed, _) = exercise.dateCompleted(workout), calendar.isDate(completed, inSameDayAs: Date()) {
                        count += 1
                    }
                }
            }
            return count
        }

        var todays: [Int] = []
        let app = UIApplication.shared.delegate as! AppDelegate
        for (i, workout) in app.program.workouts.enumerated() {
            let completed = numCompleted(workout)
            if completed > 0 && completed < workout.exercises.count {
//            if isUnderway(workout) || (completed > 0 && completed < workout.exercises.count) {
                todays.append(i)
            }
        }
        return todays
    }
    
    private func findFirstMissingWorkout() -> Int? {
        let app = UIApplication.shared.delegate as! AppDelegate
        for (i, workout) in app.program.workouts.enumerated() {
            if workout.scheduled && workout.exercises.all({
                if let exercise = app.program.findExercise($0), !workout.optional.contains($0) {
                    if exercise.dateCompleted(workout) == nil {
                        return true
                    }
                }
                return false
            }) {
                return i
            }
        }
        return nil
    }

    private func findOldestWorkout() -> Int? {
        var date = Date()
        var index: Int? = nil

        let app = UIApplication.shared.delegate as! AppDelegate
        for (i, workout) in app.program.workouts.enumerated() {
            if workout.scheduled {
                if let (candidate, _, _) = app.dateWorkoutWasCompleted(workout) {
                    if candidate.compare(date) == .orderedAscending {
                        date = candidate
                        index = i
                    }
                }
            }
        }
        return index
    }

    private func hasActiveExercise(_ workout: Workout) -> Bool {
        for exerciseName in workout.exercises {
            if !workout.optional.contains(exerciseName) {
                return true
            }
        }

        return false
    }
    
    //    private func allCardio(_ workout: Workout) -> Bool {
    //        for exerciseName in workout.exercises {
    //            if let exercise = presults.program.exercises[exerciseName], exercise.type != .cardio {
    //                return false
    //            }
    //        }
    //
    //        return true
    //    }
    
    //    private func getCardioDetails(_ workout: Workout) -> String {
    //        var mins = 0
    //        for exerciseName in workout.exercises {
    //            let exercise = presults.program.exercises[exerciseName] as! CardioExercise
    //            mins += exercise.minsRemaining(exerciseName)
    //        }
    //        return CardioExercise.minsToStr(mins)
    //    }
    
    // Returns a string like: "You’ve been running the Ripptoe Masters program for 3 months, and have
    // worked out 84 days."
//    static internal func getWorkoutSummary() -> String {
//        let app = UIApplication.shared.delegate as! AppDelegate
//
//        func numWorkouts() -> Int {
//            let scheduledWorkouts = app.program.workouts.filter {$0.scheduled}
//            let scheduledExercises = Set(scheduledWorkouts.flatMap {$0.exercises})
//
//            var dates: Set<Date> = []
//            for exercise in app.program.exercises {
//                if scheduledExercises.contains(exercise.name) {
//                    for result in exercise.plan.getHistory() {
//                        dates.insert(result.date.startOfDay())    // TODO: don't want the date if it's been more than a month(?) since the prior date
//                    }
//                }
//            }
//            return dates.count
//        }
//
//        // TODO: return an attributed string (program name in italics)
//        // TODO: or underline?
//        //        if results.numWorkouts > 0 {
//        //            let elapsed = results.dateStarted.longDurationName()
//        //            let count = results.numWorkouts == 1 ? "1 day" : "\(results.numWorkouts) days"
//        //            return "You’ve been running the \(results.program.name) program for \(elapsed) and have worked out \(count)."
//        //        } else {
//        //            return "You are running the \(results.program.name) program."
//        //        }
//        let count = numWorkouts()
//        var mesg = "You've done \(count) \(app.program.name) " + (count == 1 ? "workout." : "workouts.")
//        if let max = app.program.maxWorkouts, count >= max {
//            if let next = app.program.nextProgram {
//                mesg += " Consider switching to \(next)."
//            } else {
//                mesg += " You've done all the workouts the program calls for."
//            }
//        }
//        return mesg
//    }

    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var statusLabel: UILabel!
}

