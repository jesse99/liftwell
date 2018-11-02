//  Created by Jesse Jones on 11/1/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation
import UIKit
import os.log
import TSMarkdownParser

class NotesController: UIViewController, UITextViewDelegate {
    func initialize(_ exercise: Exercise, _ breadcrumb: String) {
        self.exercise = exercise
        self.breadcrumb = "\(breadcrumb) • Notes"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        breadcrumbLabel.text = breadcrumb
        textView.delegate = self
        reset()
    }
    
    override func viewDidLayoutSubviews() {
        // So the text is scrolled to the top when the screen loads.
        textView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    //    override func updateTextViewFonts(_ view: UITextView) {
    //        reset()
    //    }
    
    private func reset() {
        let app = UIApplication.shared.delegate as! AppDelegate
        if let markup = app.program.customNotes[exercise.formalName] {
            setText(markup)
            revertButton.isEnabled = true
        } else if let markup = builtInNotes[exercise.formalName] {
            setText(markup)
            revertButton.isEnabled = false
        } else {
            let text = NSAttributedString(string: "")
            textView.textStorage.setAttributedString(text)
            revertButton.isEnabled = false
        }
    }
    
    private func setText(_ str: String) {
        if let parser = TSMarkdownParser.standard() {
            if let text = parser.attributedString(fromMarkdown: str) {
                textView.textStorage.setAttributedString(text)
            } else {
                textView.text = "There was an error parsing the text."
            }
        } else {
            textView.text = "Failed to load TSMarkdownParser."
        }
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        return true
    }
    
    @IBAction func unwindToNotes(_ segue: UIStoryboardSegue) {
        reset()
    }
    
    @IBAction func donePressed(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToExerciseID", sender: self)
    }
    
    @IBAction func revertPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Restore original note?", message: nil, preferredStyle: .actionSheet)
        
        var action = UIAlertAction(title: "Yes", style: .destructive) {_ in self.doRevert()}
        alert.addAction(action)
        
        action = UIAlertAction(title: "No", style: .default, handler: nil)
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func editPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "EditNoteControllerID") as! EditNoteController
        view.initialize(exercise.formalName, breadcrumbLabel.text!)
        self.present(view, animated: true, completion: nil)
    }
    
    private func doRevert() {
        let app = UIApplication.shared.delegate as! AppDelegate
        app.program.customNotes[exercise.formalName] = nil
        app.saveState()
        reset()
    }
    
    @IBOutlet private var breadcrumbLabel: UILabel!
    @IBOutlet private var textView: UITextView!
    @IBOutlet private var revertButton: UIBarButtonItem!
    
    private var exercise: Exercise!
    private var breadcrumb = ""
}
