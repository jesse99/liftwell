//  Created by Jesse Jones on 10/27/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import UIKit
import Foundation
import os.log

struct RepsOptions {
    var rest: Int
    var aweight: ApparatusWeight?
    var reps: Int? = nil
    var cycleIndex: Int?
    var apparatus: Apparatus?
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
        
        if let aweight = options.aweight {
            weightLabel.isHidden = false
            weightTextbox.isHidden = false

            switch aweight {
            case .weight(let weight):
                if let reps = options.reps {
                    repsLabel.isHidden = false
                    repsTextbox.isHidden = false
                    repsTextbox.text = "\(reps)"
                } else {
                    repsLabel.isHidden = true
                    repsTextbox.isHidden = true
                }
                
                tm1RMLabel.isHidden = true
                tm1RMTextbox.isHidden = true
                tmSubtitle.isHidden = true
                weightLabel.text = "Weight:"
                weightTextbox.text = Weight.friendlyStr(weight)

            case .trainingMax(percent: let percent, oneRepMax: let max):
                repsLabel.isHidden = true
                repsTextbox.isHidden = true
                tm1RMLabel.isHidden = false
                tm1RMTextbox.isHidden = false
                tmSubtitle.isHidden = false
                weightLabel.text = "TM:"
                weightTextbox.text = Weight.friendlyStr(percent*max)
                tm1RMTextbox.text = Weight.friendlyStr(max)
                tmSubtitle.text = "Training Max = \(Int(100*percent))% of 1RM"
            }
        } else {
            weightLabel.isHidden = true
            weightTextbox.isHidden = true
            tm1RMLabel.isHidden = true
            tm1RMTextbox.isHidden = true
            tmSubtitle.isHidden = true

            if let reps = options.reps {
                repsLabel.isHidden = false
                repsTextbox.isHidden = false
                repsTextbox.text = "\(reps)"
            } else {
                repsLabel.isHidden = true
                repsTextbox.isHidden = true
            }
        }
        
        if let cycle = options.cycleIndex {
            cycleLabel.isHidden = false
            cycleTextbox.isHidden = false
            cycleTextbox.text = "\(cycle+1)"
        } else {
            cycleLabel.isHidden = true
            cycleTextbox.isHidden = true
        }
        
        if options.apparatus != nil && options.aweight != nil {
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
        tm1RMTextbox.resignFirstResponder()
    }
    
    @IBAction func tmChanged(_ sender: Any) {
        if let text = weightTextbox.text, let tm = Double(text), let aweight = options.aweight {
            switch aweight {
            case .weight(_):
                break
            case .trainingMax(percent: let percent, oneRepMax: _):
                tm1RMTextbox.text = Weight.friendlyStr(tm/percent)
            }
        }
    }
    
    @IBAction func oneRepMaxChanged(_ sender: Any) {
        if let text = tm1RMTextbox.text, let max = Double(text), let aweight = options.aweight {
            switch aweight {
            case .weight(_):
                assert(false)
                
            case .trainingMax(percent: let percent, oneRepMax: _):
                weightTextbox.text = Weight.friendlyStr(percent*max)
            }
        }
    }
    
    @IBAction func unwindToRepsOptions(_ segue:UIStoryboardSegue) {
    }

    @IBAction func donePressed(_ sender: Any) {
        if let aweight = options.aweight {
            switch aweight {
            case .weight(_):
                if let text = weightTextbox.text, let tm = Double(text) {
                    options.aweight = .weight(Double(tm)) // TODO: use something like toWeight
                }
                
            case .trainingMax(percent: let percent, oneRepMax: _):
                if let text = tm1RMTextbox.text, let max = Double(text) {
                    options.aweight = .trainingMax(percent: percent, oneRepMax: max)
                }
            }
        }

        if let text = restTextbox.text, let value = strToSecs(text) {
            options.rest = value
        }
        if options.reps != nil {
            options.reps = Int(repsTextbox.text!)!
        }
        if options.cycleIndex != nil {
            options.cycleIndex = Int(cycleTextbox.text!)! - 1
        }
        completion(options)

        self.performSegue(withIdentifier: "unwindToExerciseID", sender: self)
    }
    
    @IBAction func apparatusPressed(_ sender: Any) {
        if let apparatus = options.apparatus {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)

            switch apparatus {
            case .dumbbells(weights: _, magnets: _, paired: _):
                let view = storyboard.instantiateViewController(withIdentifier: "DumbbellControllerID") as! DumbbellController
                view.initialize(apparatus, self.updateApparatus, breadcrumb, "unwindToRepsOptionsID")
                present(view, animated: true, completion: nil)

            case .barbell(bar: _, collar: _, plates: _, bumpers: _, magnets: _):
                let view = storyboard.instantiateViewController(withIdentifier: "BarbellControllerID") as! BarbellController
                view.initialize(apparatus, self.updateApparatus, breadcrumb, "unwindToRepsOptionsID")
                present(view, animated: true, completion: nil)

            case .machine(range1: _, range2: _, extra: _):
                let view = storyboard.instantiateViewController(withIdentifier: "MachineControllerID") as! MachineController
                view.initialize(apparatus, self.updateApparatus, breadcrumb, "unwindToRepsOptionsID")
                present(view, animated: true, completion: nil)

            case .pairedPlates(plates: _), .singlePlates(plates: _):
                let view = storyboard.instantiateViewController(withIdentifier: "PlatesControllerID") as! PlatesController
                view.initialize(apparatus, self.updateApparatus, breadcrumb, "unwindToRepsOptionsID")
                present(view, animated: true, completion: nil)
            }
        }
    }
    
    private func updateApparatus(_ apparatus: Apparatus) {
        options.apparatus = apparatus
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
    
    private func adjustWeight(_ adjustPercent: Double) {
        if let apparatus = options.apparatus, let aweight = options.aweight {
            switch aweight {
            case .weight(let weight):
                let newWeight = weight + weight*adjustPercent
                let info = Weight.init(newWeight, apparatus).closest()
                weightTextbox.text = Weight.friendlyStr(info.weight)

            case .trainingMax(percent: let percent, oneRepMax: let max):
                let oldWeight = percent*max
                let newWeight = oldWeight + oldWeight*adjustPercent
                let info = Weight.init(newWeight, apparatus).closest()
                weightTextbox.text = Weight.friendlyStr(info.weight)
                tm1RMTextbox.text = Weight.friendlyStr(info.weight/percent)
            }
        }
    }
    
    @IBOutlet var breadcrumbLabel: UILabel!
    @IBOutlet var restTextbox: UITextField!
    @IBOutlet var weightLabel: UILabel!
    @IBOutlet var weightTextbox: UITextField!
    @IBOutlet var repsTextbox: UITextField!
    @IBOutlet var cycleTextbox: UITextField!
    @IBOutlet var adjustButton: UIButton!
    @IBOutlet var apparatusButton: UIBarButtonItem!
    
    @IBOutlet var repsLabel: UILabel!
    @IBOutlet var cycleLabel: UILabel!
    
    @IBOutlet var tm1RMLabel: UILabel!
    @IBOutlet var tm1RMTextbox: UITextField!
    @IBOutlet var tmSubtitle: UILabel!
    
    private var options: RepsOptions!
    private var completion: Completion!
    private var breadcrumb: String!
}
