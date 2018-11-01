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
        
        if newOptional.contains(name) {
            cell.textLabel!.text = "\(name) (inactive)"
            cell.textLabel!.setColor(UIColor.gray)
        } else {
            cell.textLabel!.text = name
            cell.textLabel!.setColor(UIColor.black)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt path: IndexPath) {
        let index = path.item
        let name = workout.exercises[index]
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        var action: UIAlertAction
        if newOptional.contains(name) {
            action = UIAlertAction(title: "Activate", style: .default) {_ in
                if let i = self.newOptional.index(of: name) {
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
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var breadcrumbLabel: UILabel!
    
    private var workout: Workout!
    private var newOptional: [String] = []
    private var breadcrumb = ""
}


