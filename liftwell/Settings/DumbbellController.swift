//  Created by Jesse Jones on 10/28/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation
import UIKit

class DumbbellController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    typealias Completion = (Apparatus) -> Void

    func initialize(_ apparatus: Apparatus, _ completion: @escaping Completion, _ breadcrumb: String, _ unwind: String) {
        self.apparatus = apparatus
        self.completion = completion
        self.breadcrumb = "\(breadcrumb) • Dumbbell"
        self.unwind = unwind
        
        self.available = availableDumbbells()
        switch apparatus {
        case .dumbbells(weights: let weights, magnets: _):
            self.used = weights
        default:
            assert(false, "expected a dumbbell")
            abort()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        breadcrumbLabel.text = breadcrumb
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func unwindToDumbbell(_ segue: UIStoryboardSegue) {
    }
    
    @IBAction func donePressed(_ sender: Any) {
        switch apparatus! {
        case .dumbbells(weights: _, magnets: let oldMagnets):
            apparatus = .dumbbells(weights: used, magnets: oldMagnets)
            completion(apparatus)
        default:
            assert(false, "DumbbellController was called without a dumbbell")
            abort()
        }
        
        self.performSegue(withIdentifier: unwind, sender: self)
    }
    
    @IBAction func magnetsPressed(_ sender: Any) {
        var usedMagnets: [Double]
        switch apparatus! {
        case .dumbbells(weights: _, magnets: let magnets):
            usedMagnets = magnets
        default:
            assert(false, "DumbbellController was called without a dumbbell")
            abort()
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "WeightsControllerID") as! WeightsController
        view.initialize(
            available: defaultMagnets(),
            used: usedMagnets,
            emptyOK: true,
            self.updateMagnets,
            breadcrumbLabel.text! + " • Magnets",
            "unwindToDumbbellID")
        present(view, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return available.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt path: IndexPath) -> UITableViewCell {
        let index = (path as NSIndexPath).item
        let weight = available[index]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DumbbellCellID")!
        cell.textLabel!.text = Weight.friendlyStr(weight)
        cell.accessoryType = used.contains(weight) ? .checkmark : .none
        cell.backgroundColor = tableView.backgroundColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt path: IndexPath) {
        let index = (path as NSIndexPath).item
        let weight = available[index]
        
        if let i = used.index(of: weight) {
            used.remove(at: i)
        } else {
            used.append(weight)
            used.sort()
        }
        
        tableView.reloadRows(at: [path], with: .fade)
        doneButton.isEnabled = !used.isEmpty
    }
    
    private func updateMagnets(_ newMagnets: [Double]) {
        switch apparatus! {
        case .dumbbells(weights: let oldWeights, magnets: _):
            apparatus = .dumbbells(weights: oldWeights, magnets: newMagnets)
        default:
            assert(false, "DumbbellController was called without a dumbbell")
            abort()
        }
    }
    
    @IBOutlet private var breadcrumbLabel: UILabel!
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var doneButton: UIBarButtonItem!
    
    private var apparatus: Apparatus!
    private var completion: Completion!
    private var available: [Double]!
    private var used: [Double]!
    private var unwind = ""
    private var breadcrumb = ""
}
