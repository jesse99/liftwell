//  Created by Jesse Jones on 10/31/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation
import UIKit
import os.log

class MachineController: UIViewController {
    typealias Completion = (Apparatus) -> Void
    
    func initialize(_ apparatus: Apparatus, _ completion: @escaping Completion, _ breadcrumb: String, _ unwind: String) {
        self.apparatus = apparatus
        self.completion = completion
        self.unwind = unwind
        self.breadcrumb = "\(breadcrumb) • Machine"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        breadcrumbLabel.text = breadcrumb
        switch apparatus! {
        case .machine(range1: let range1, range2: let range2, extra: let extra):
            min1Textbox.text = Weight.friendlyStr(range1.min)
            max1Textbox.text = Weight.friendlyStr(range1.max)
            step1Textbox.text = Weight.friendlyStr(range1.step)
            
            min2Textbox.text = Weight.friendlyStr(range2.min)
            max2Textbox.text = Weight.friendlyStr(range2.max)
            step2Textbox.text = Weight.friendlyStr(range2.step)
            
            let e = extra.map {Weight.friendlyStr($0)}
            extraTextbox.text = e.joined(separator: ", ")
        default:
            assert(false, "MachineController was called without a machine")
            abort()
        }
        doneButton.isEnabled = true
    }
    
    @IBAction func viewTapped(_ sender: Any) {
        extraTextbox.resignFirstResponder()
        
        min1Textbox.resignFirstResponder()
        max1Textbox.resignFirstResponder()
        step1Textbox.resignFirstResponder()
        
        min2Textbox.resignFirstResponder()
        max2Textbox.resignFirstResponder()
        step2Textbox.resignFirstResponder()
    }
    
    @IBAction func cancepPrressed(_ sender: Any) {
        self.performSegue(withIdentifier: unwind, sender: self)
    }
    
    @IBAction func donePressed(_ sender: Any) {
        switch apparatus! {
        case .machine(range1: _, range2: _, extra: _):
            if let range1 = getRange(minTextbox: min1Textbox, maxTextbox: max1Textbox, stepTextbox: step1Textbox) {
                if let range2 = getRange(minTextbox: min2Textbox, maxTextbox: max2Textbox, stepTextbox: step2Textbox) {
                    if let extra = getExtra() {
                        apparatus = .machine(range1: range1, range2: range2, extra: extra)
                        completion(apparatus)
                    }
                }
            }
        default:
            assert(false, "MachineController was called without a machine")
            abort()
        }
        
        self.performSegue(withIdentifier: unwind, sender: self)
    }
    
    @IBAction func textEdited(_ sender: Any) {
        if let range1 = getRange(minTextbox: min1Textbox, maxTextbox: max1Textbox, stepTextbox: step1Textbox) {
            if getRange(minTextbox: min2Textbox, maxTextbox: max2Textbox, stepTextbox: step2Textbox) != nil {
                if getExtra() != nil {
                    doneButton.isEnabled = range1.step > 0
                    return
                }
            }
        }
        doneButton.isEnabled = false
    }
    
    private func getRange(minTextbox: UITextField, maxTextbox: UITextField, stepTextbox: UITextField) -> MachineRange? {
        if let minText = minTextbox.text, let min = Double(minText) {
            if let maxText = maxTextbox.text, let max = Double(maxText) {
                if let stepText = stepTextbox.text, let step = Double(stepText) {
                    if min <= max && step >= 0.0 {
                        return MachineRange(min: min, max: max, step: step)
                    }
                }
            }
        }
        return nil
    }
    
    private func getExtra() -> [Double]? {
        if var extraText = extraTextbox.text {
            var extra: [Double] = []
            extraText = extraText.replacingOccurrences(of: " ", with: "")
            let parts = extraText.split(separator: ",")
            
            for part in parts {
                if let weight = Double(part) {
                    extra.append(weight)
                } else {
                    return nil
                }
            }
            return extra
        }
        return nil
    }
    
    @IBOutlet private var breadcrumbLabel: UILabel!
    @IBOutlet private var extraTextbox: UITextField!
    @IBOutlet private var doneButton: UIBarButtonItem!
    
    @IBOutlet private var min1Textbox: UITextField!
    @IBOutlet private var max1Textbox: UITextField!
    @IBOutlet private var step1Textbox: UITextField!
    
    @IBOutlet private var min2Textbox: UITextField!
    @IBOutlet private var max2Textbox: UITextField!
    @IBOutlet private var step2Textbox: UITextField!
    
    private var apparatus: Apparatus!
    private var completion: Completion!
    private var breadcrumb = ""
    private var unwind = ""
}
