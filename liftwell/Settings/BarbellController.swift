//  Created by Jesse Jones on 10/28/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation
import UIKit
import os.log

class BarbellController: UIViewController {
    typealias Completion = (Apparatus) -> Void

    func initialize(_ apparatus: Apparatus, _ completion: @escaping Completion, _ breadcrumb: String, _ unwind: String) {
        self.apparatus = apparatus
        self.completion = completion
        self.unwind = unwind
        self.breadcrumb = "\(breadcrumb) • Barbell"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        breadcrumbLabel.text = breadcrumb
        
        switch apparatus! {
        case .barbell(bar: let bar, collar: let collar, plates: _, bumpers: _, magnets: _):
            collarTextbox.text = Weight.friendlyStr(collar)
            barTextbox.text = Weight.friendlyStr(bar)
        default:
            assert(false, "BarbellController was called without a barbell")
            abort()
        }
    }
    
    @IBAction func unwindToBarbell(_ segue: UIStoryboardSegue) {
    }
    
    @IBAction func viewTapped(_ sender: Any) {
        collarTextbox.resignFirstResponder()
        barTextbox.resignFirstResponder()
    }
    
    @IBAction func donePressed(_ sender: Any) {
        switch apparatus! {
        case .barbell(bar: _, collar: _, plates: let oldPlates, bumpers: let oldBumpers, magnets: let oldMagnets):
            apparatus = .barbell(
                bar: Double(barTextbox.text!)!,
                collar: Double(collarTextbox.text!)!,
                plates: oldPlates,
                bumpers: oldBumpers,
                magnets: oldMagnets)
            completion(apparatus)
        default:
            assert(false, "BarbellController was called without a barbell")
            abort()
        }
        
        self.performSegue(withIdentifier: unwind, sender: self)

    }
    
    @IBAction func platesPressed(_ sender: Any) {
        switch apparatus! {
        case .barbell(bar: _, collar: _, plates: let plates, bumpers: _, magnets: _):
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let view = storyboard.instantiateViewController(withIdentifier: "WeightsControllerID") as! WeightsController
            view.initialize(
                available: availablePlates(),
                used: plates,
                emptyOK: false,
                self.updatePlates,
                breadcrumbLabel.text! + " • Plates",
                "unwindToBarbellID")
            present(view, animated: true, completion: nil)
        default:
            assert(false, "BarbellController was called without a barbell")
            abort()
        }
    }
    
    private func updatePlates(_ newPlates: [Double]) {
        switch apparatus! {
        case .barbell(bar: let oldBar, collar: let oldCollar, plates: _, bumpers: let oldBumpers, magnets: let oldMagnets):
            apparatus = .barbell(bar: oldBar, collar: oldCollar, plates: newPlates, bumpers: oldBumpers, magnets: oldMagnets)
        default:
            assert(false, "BarbellController was called without a barbell")
            abort()
        }
    }

    @IBAction func bumpersPressed(_ sender: Any) {
        switch apparatus! {
        case .barbell(bar: _, collar: _, plates: _, bumpers: let bumpers, magnets: _):
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let view = storyboard.instantiateViewController(withIdentifier: "WeightsControllerID") as! WeightsController
            view.initialize(
                available: availableBumpers(),
                used: bumpers,
                emptyOK: true,
                self.updateBumpers,
                breadcrumbLabel.text! + " • Bumper Plates",
                "unwindToBarbellID")
            present(view, animated: true, completion: nil)
        default:
            assert(false, "BarbellController was called without a barbell")
            abort()
        }
    }
    
    private func updateBumpers(_ newBumpers: [Double]) {
        switch apparatus! {
        case .barbell(bar: let oldBar, collar: let oldCollar, plates: let oldPlates, bumpers: _, magnets: let oldMagnets):
            apparatus = .barbell(bar: oldBar, collar: oldCollar, plates: oldPlates, bumpers: newBumpers, magnets: oldMagnets)
        default:
            assert(false, "BarbellController was called without a barbell")
            abort()
        }
    }

    @IBAction func magnetsPressed(_ sender: Any) {
        switch apparatus! {
        case .barbell(bar: _, collar: _, plates: _, bumpers: _, magnets: let magnets):
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let view = storyboard.instantiateViewController(withIdentifier: "WeightsControllerID") as! WeightsController
            view.initialize(
                available: availableMagnets(),
                used: magnets,
                emptyOK: true,
                self.updateMagnets,
                breadcrumbLabel.text! + " • Magnets",
                "unwindToBarbellID")
            present(view, animated: true, completion: nil)
        default:
            assert(false, "BarbellController was called without a barbell")
            abort()
        }
    }
    
    private func updateMagnets(_ newMagnets: [Double]) {
        switch apparatus! {
        case .barbell(bar: let oldBar, collar: let oldCollar, plates: let oldPlates, bumpers: let oldBumpers, magnets: _):
            apparatus = .barbell(bar: oldBar, collar: oldCollar, plates: oldPlates, bumpers: oldBumpers, magnets: newMagnets)
        default:
            assert(false, "BarbellController was called without a barbell")
            abort()
        }
    }

    @IBOutlet var breadcrumbLabel: UILabel!
    @IBOutlet var collarTextbox: UITextField!
    @IBOutlet var barTextbox: UITextField!
    
    private var apparatus: Apparatus!
    private var completion: Completion!
    private var unwind = ""
    private var breadcrumb = ""
}




