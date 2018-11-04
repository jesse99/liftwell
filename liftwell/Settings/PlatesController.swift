//  Created by Jesse Jones on 10/31/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation
import UIKit

class PlatesController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    typealias Completion = (Apparatus) -> Void

    func initialize(_ apparatus: Apparatus, _ completion: @escaping Completion, _ breadcrumb: String, _ unwind: String) {
        self.apparatus = apparatus
        self.completion = completion
        self.unwind = unwind
        
        self.available = availablePlates()
        switch apparatus {
        case .singlePlates(plates: let weights):
            self.breadcrumb = "\(breadcrumb) • Single Plates"
            self.used = weights
            self.single = true
        case .pairedPlates(plates: let weights):
            self.breadcrumb = "\(breadcrumb) • Paired Plates"
            self.used = weights
            self.single = false
        default:
            assert(false, "expected single or paired plates")
            abort()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        breadcrumbLabel.text = breadcrumb
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.performSegue(withIdentifier: unwind, sender: self)
    }
    
    @IBAction func donePressed(_ sender: Any) {
        if single {
            completion(.singlePlates(plates: used))
        } else {
            completion(.pairedPlates(plates: used))
        }
        self.performSegue(withIdentifier: unwind, sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return available.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt path: IndexPath) -> UITableViewCell {
        let index = (path as NSIndexPath).item
        let weight = available[index]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SinglePlatesCellID")!
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
    
    @IBOutlet private var breadcrumbLabel: UILabel!
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var doneButton: UIBarButtonItem!
    
    private var apparatus: Apparatus!
    private var completion: Completion!
    private var unwind = ""
    
    private var available: [Double]!
    private var used: [Double]!
    private var breadcrumb = ""
    private var single = false
}

