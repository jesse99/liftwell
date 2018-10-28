//  Created by Jesse Jones on 10/28/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import UIKit
import Foundation
import os.log

struct TimedOptions {
    var time: Int
    var weight: Double
    var apparatus: Apparatus? = nil
}

class TimedOptionController: UIViewController {
    typealias Completion = (TimedOptions) -> Void
    
    func initialize(_ options: TimedOptions, completion: @escaping Completion, _ breadcrumb: String) {
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
        timeTextbox.text = secsToStr(options.time)
        weightTextbox.text = Weight.friendlyStr(options.weight)
        
        if options.apparatus != nil {
            adjustButton.isHidden = false
            apparatusButton.isEnabled = true
        } else {
            adjustButton.isHidden = true
            apparatusButton.isEnabled = false
        }
    }
    
    @IBAction func viewTapped(_ sender: Any) {
        timeTextbox.resignFirstResponder()
        weightTextbox.resignFirstResponder()
    }
    
    @IBAction func unwindToTimedOptions(_ segue:UIStoryboardSegue) {
    }
    
    @IBAction func donePressed(_ sender: Any) {
        if let text = timeTextbox.text, let value = strToSecs(text) {
            options.time = value
        }
        options.weight = Double(weightTextbox.text!)! // TODO: use something like toWeight
        completion(options)
        
        self.performSegue(withIdentifier: "unwindToExerciseID", sender: self)
    }
    
    @IBAction func apparatusPressed(_ sender: Any) {
        if let apparatus = options.apparatus {
            if case .dumbbells(_, _) = apparatus {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let view = storyboard.instantiateViewController(withIdentifier: "DumbbellControllerID") as! DumbbellController
                view.initialize(apparatus, self.updateApparatus, breadcrumb, "unwindToTimedOptionsID")
                present(view, animated: true, completion: nil)
            }
        }
    }
    
    private func updateApparatus(_ apparatus: Apparatus) {
        options.apparatus = apparatus
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
    @IBOutlet var timeTextbox: UITextField!
    @IBOutlet var weightTextbox: UITextField!
    @IBOutlet var adjustButton: UIButton!
    @IBOutlet var apparatusButton: UIBarButtonItem!

    private var options: TimedOptions!
    private var completion: Completion!
    private var breadcrumb: String!
}
