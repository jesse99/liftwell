//  Created by Jesse Jones on 10/31/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation
import UIKit

class WorkoutOptionsController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.reloadData()
        
        //        tableView.backgroundColor = targetColor(.background)
        //        view.backgroundColor = tableView.backgroundColor
    }
    
    func initialize(_ workout: Workout, _ breadcrumb: String) {
        self.workout = workout
        self.newOptional = Array(workout.optional)
        self.breadcrumb = "\(breadcrumb) • Options"
        
        progressionLabels = [:]
        let app = UIApplication.shared.delegate as! AppDelegate
        for name in workout.exercises {
            if let exercise = app.program.findExercise(name), exercise.prevExercise == nil, exercise.nextExercise != nil {
                initProgression(name)
            }
        }
    }
    
    private func initProgression(_ first: String) {
        var progression: [String] = []
        
        var name: String? = first
        let app = UIApplication.shared.delegate as! AppDelegate
        while name != nil {
            if let exercise = app.program.findExercise(name!) {
                progression.append(name!)
                name = exercise.nextExercise
            } else {
                break
            }
        }
        
        for (index, name) in progression.enumerated() {
            progressionLabels[name] = "\(index+1) of \(progression.count)"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        dismissTooltip()
        tableView.reloadData()
    }
    
    //    func onBackColorChanged()
    //    {
    //        view.backgroundColor = targetColor(.background)
    //        tableView.backgroundColor = view.backgroundColor
    //        view.setNeedsDisplay()
    //    }
    
    @IBAction func donePressed(_ sender: Any) {
        workout.optional = newOptional
        
        let app = UIApplication.shared.delegate as! AppDelegate
        app.saveState()
        
        self.performSegue(withIdentifier: "unwindToWorkoutID", sender: self)
    }
    
    @IBAction func cancelPressed(_ sender: AnyObject) {
        performSegue(withIdentifier: "unwindToWorkoutID", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workout.exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt path: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutOptionsCellID")!
        cell.backgroundColor = tableView.backgroundColor
        
        let index = path.item
        let name = workout.exercises[index]
        let (color, suffix) = getLabel(name)
        
        cell.textLabel!.text = "\(name)\(suffix)"
        cell.textLabel!.setColor(color)
        
        return cell
    }
    
    private func getLabel(_ name: String) -> (UIColor, String) {
        let app = UIApplication.shared.delegate as! AppDelegate
        if newOptional.contains(name) {
            if let exercise = app.program.findExercise(name), exercise.main {
                if let progress = progressionLabels[name] {
                    return (UIColor.gray, " (\(progress))")
                } else {
                    return (UIColor.gray, " (main, inactive)")
                }
            } else {
                if let progress = progressionLabels[name] {
                    return (UIColor.gray, " (\(progress))")
                } else {
                    return (UIColor.gray, " (inactive)")
                }
            }
        } else {
            if let exercise = app.program.findExercise(name), exercise.main {
                if let progress = progressionLabels[name] {
                    return (UIColor.black, " (main, \(progress))")
                } else {
                    return (UIColor.black, " (main)")
                }
            } else {
                return (UIColor.black, "")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt path: IndexPath) {
        let index = path.item
        let name = workout.exercises[index]
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        var action: UIAlertAction
        if newOptional.contains(name) {
            action = UIAlertAction(title: "Activate", style: .default) {_ in
                if let i = self.newOptional.index(of: name) {
                    self.deactivatePrev(name)
                    self.deactivateNext(name)
                    self.newOptional.remove(at: i)
                    tableView.reloadData()
                }
            }
            alert.addAction(action)
        } else {
            action = UIAlertAction(title: "Deactivate", style: .default) {_ in
                self.newOptional.append(name)
                tableView.reloadData()
            }
            alert.addAction(action)
        }
        
        action = UIAlertAction(title: "Cancel", style: .cancel) {_ in }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func deactivatePrev(_ current: String) {
        let app = UIApplication.shared.delegate as! AppDelegate
        
        var name: String? = current
        while let n = name, let exercise = app.program.findExercise(n) {
            name = exercise.prevExercise
            if let n = name, app.program.findExercise(n) != nil {
                if !newOptional.contains(n) {
                    newOptional.append(n)
                }
            }
        }
    }

    private func deactivateNext(_ current: String) {
        let app = UIApplication.shared.delegate as! AppDelegate
        
        var name: String? = current
        while let n = name, let exercise = app.program.findExercise(n) {
            name = exercise.nextExercise
            if let n = name, app.program.findExercise(n) != nil {
                if !newOptional.contains(n) {
                    newOptional.append(n)
                }
            }
        }
    }
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var breadcrumbLabel: UILabel!
    
    private var workout: Workout!
    private var newOptional: [String] = []
    private var breadcrumb = ""
    private var progressionLabels: [String: String] = [:]        // "2 of 5"
}


