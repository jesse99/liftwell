//  Created by Jesse Jones on 10/27/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import UIKit
import Foundation
import os.log

struct RepsOptions {
    var rest: Int
    var weight: Double
    var reps: Int? = nil
    var cycleIndex: Int? = nil
    var apparatus: Apparatus? = nil
}

class RepsOptionController: UIViewController {
    typealias Completion = (RepsOptions) -> Void
    
    func initialize(_ options: RepsOptions, completion: @escaping Completion, _ breadcrumb: String) {
        self.options = options
        self.completion = completion
        self.breadcrumb = "\(breadcrumb) • Options"
    }
    
    // TODO: encode state?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        breadcrumbLabel.text = breadcrumb
        restTextbox.text = secsToStr(options.rest)
        weightTextbox.text = Weight.friendlyStr(options.weight)
        
        if let reps = options.reps {
            repsLabel.isHidden = false
            repsTextbox.isHidden = false
            repsTextbox.text = "\(reps)"
        } else {
            repsLabel.isHidden = true
            repsTextbox.isHidden = true
        }

        if let cycle = options.cycleIndex {
            cycleLabel.isHidden = false
            cycleTextbox.isHidden = false
            cycleTextbox.text = "\(cycle)"
        } else {
            cycleLabel.isHidden = true
            cycleTextbox.isHidden = true
        }
        
        if options.apparatus != nil {
            adjustButton.isHidden = false
            apparatusButton.isEnabled = true

        } else {
            adjustButton.isHidden = true
            apparatusButton.isEnabled = false
        }
    }
    
    @IBAction func viewTapped(_ sender: Any) {
        restTextbox.resignFirstResponder()
        weightTextbox.resignFirstResponder()
        repsTextbox.resignFirstResponder()
        cycleTextbox.resignFirstResponder()
    }
    
    @IBAction func unwindToRepsOptions(_ segue:UIStoryboardSegue) {
    }

    @IBAction func donePressed(_ sender: Any) {
        if let text = restTextbox.text, let value = strToSecs(text) {
            options.rest = value
        }
        options.weight = Double(weightTextbox.text!)! // TODO: use something like toWeight
        if options.reps != nil {
            options.reps = Int(repsTextbox.text!)!
        }
        if options.cycleIndex != nil {
            options.cycleIndex = Int(cycleTextbox.text!)!
        }
        completion(options)

        self.performSegue(withIdentifier: "unwindToExerciseID", sender: self)
    }
    
    // TODO: look at VariableWeightController
    @IBAction func apparatusPressed(_ sender: Any) {
    }
    
    static func adjustWeight(_ view: UIViewController, _ adjust: @escaping (Double) -> Void) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        var action = UIAlertAction(title: "+ 20%", style: .default) {_ in
            adjust(0.2)
        }
        alert.addAction(action)
        
        action = UIAlertAction(title: "+ 15%", style: .default) {_ in
            adjust(0.15)
        }
        alert.addAction(action)
        
        action = UIAlertAction(title: "+ 10%", style: .default) {_ in
            adjust(0.1)
        }
        alert.addAction(action)
        
        action = UIAlertAction(title: "+ 5%", style: .default) {_ in
            adjust(0.05)
        }
        alert.addAction(action)
        
        action = UIAlertAction(title: "0%", style: .default) {_ in
            adjust(0.0)
        }
        alert.addAction(action)
        
        action = UIAlertAction(title: "- 5%", style: .default) {_ in
            adjust(-0.05)
        }
        alert.addAction(action)
        
        action = UIAlertAction(title: "- 10%", style: .default) {_ in
            adjust(-0.1)
        }
        alert.addAction(action)
        
        action = UIAlertAction(title: "- 15%", style: .default) {_ in
            adjust(-0.15)
        }
        alert.addAction(action)
        
        action = UIAlertAction(title: "- 20%", style: .default) {_ in
            adjust(-0.2)
        }
        alert.addAction(action)
        
        action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action)
        
        view.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func adjustPressed(_ sender: Any) {
        RepsOptionController.adjustWeight(self, self.adjustWeight)
    }
    
    private func adjustWeight(_ percent: Double) {
        if let apparatus = options.apparatus {
            let newWeight = options.weight + options.weight*percent
            let info = Weight.init(newWeight, apparatus).closest()
            weightTextbox.text = Weight.friendlyStr(info.weight)
        }
    }
    
    @IBOutlet var breadcrumbLabel: UILabel!
    @IBOutlet var restTextbox: UITextField!
    @IBOutlet var weightTextbox: UITextField!
    @IBOutlet var repsTextbox: UITextField!
    @IBOutlet var cycleTextbox: UITextField!
    @IBOutlet var adjustButton: UIButton!
    @IBOutlet var apparatusButton: UIBarButtonItem!
    
    @IBOutlet var repsLabel: UILabel!
    @IBOutlet var cycleLabel: UILabel!
    
    private var options: RepsOptions!
    private var completion: Completion!
    private var breadcrumb: String!
}
