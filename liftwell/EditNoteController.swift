//  Created by Jesse Jones on 11/2/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation
import UIKit
import os.log

class EditNoteController: UIViewController, UITextViewDelegate {
    func initialize(_ formalName: String, _ breadcrumb: String) {
        self.formalName = formalName
        self.breadcrumb = "\(breadcrumb) • Edit"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        breadcrumbLabel.text = breadcrumb
        textView.delegate = self
        
        let app = UIApplication.shared.delegate as! AppDelegate
        if let markup = app.program.customNotes[formalName] {
            textView.text = markup
        } else if let markup = builtInNotes[formalName] {
            textView.text = markup
        } else {
            textView.text = ""
        }
        
        originalMarkup = textView.text!
        
        NotificationCenter.default.addObserver(self, selector: #selector(EditNoteController.keyboardWillShowNotification(_:)), name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(EditNoteController.keyboardWillHideNotification(_:)), name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    //    override func updateTextViewFonts(_ view: UITextView) {
    //        reset()
    //    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func donePressed(_ sender: Any) {
        // It would be nice to validate that the markup is legit but markdown is so freeform
        // that that seems hard to do (and CocoMarkdown doesn't seem to have any way to report
        // errors).
        if let text = textView.text, text != originalMarkup {
            let app = UIApplication.shared.delegate as! AppDelegate
            app.program.customNotes[formalName] = text
            app.saveState()
        }
        
        performSegue(withIdentifier: "unwindToNotesID", sender: self)
    }
    
    @IBAction func tapped(_ sender: AnyObject) {
        textView.resignFirstResponder()
        
        if bottomConstraint.constant < 100 {
            bottomConstraint.constant = 100
        } else {
            bottomConstraint.constant = 10
        }
    }
    
    @IBAction func helpPressed(_ sender: AnyObject) {
        if let url = URL(string: "http://commonmark.org/help/") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func cancelPressed(_ sender: AnyObject) {
        performSegue(withIdentifier: "unwindToNotesID", sender: self)
    }
    
    @objc func keyboardWillShowNotification(_ notification: Notification) {
        let userInfo = (notification as NSNotification).userInfo!
        let keyboardEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let convertedKeyboardEndFrame = view.convert(keyboardEndFrame, from: view.window)
        
        let offset = view.bounds.maxY - convertedKeyboardEndFrame.minY
        updateBottomLayoutConstraintWithNotification(notification, offset: offset)
    }
    
    @objc func keyboardWillHideNotification(_ notification: Notification) {
        updateBottomLayoutConstraintWithNotification(notification, offset: 10)
    }
    
    func updateBottomLayoutConstraintWithNotification(_ notification: Notification, offset: CGFloat) {
        bottomConstraint.constant = offset
        
        let userInfo = (notification as NSNotification).userInfo!
        let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let rawAnimationCurve = ((notification as NSNotification).userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber).uint32Value << 16
        let animationCurve = UIView.AnimationOptions.init(rawValue: UInt(rawAnimationCurve))
        UIView.animate(withDuration: animationDuration,
                       delay: 0.0,
                       options: UIView.AnimationOptions([.beginFromCurrentState, animationCurve]),
                       animations: {self.view.layoutIfNeeded()},
                       completion: nil)
    }
    
    @IBOutlet private var breadcrumbLabel: UILabel!
    @IBOutlet private var textView: UITextView!
    @IBOutlet private var bottomConstraint: NSLayoutConstraint!
    
    private var formalName = ""
    private var breadcrumb = ""
    private var originalMarkup = ""
}






