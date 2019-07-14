//  Created by Jesse Jones on 11/22/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation
import UIKit

func getDifficultly(_ view: UIViewController, _ completion: @escaping (ResultTag) -> Void) {
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
    
    var action = UIAlertAction(title: "Very Easy", style: .default) {_ in completion(.veryEasy)}
    alert.addAction(action)
    
    action = UIAlertAction(title: "Easy", style: .default) {_ in completion(.easy)}
    alert.addAction(action)
    
    action = UIAlertAction(title: "Normal", style: .default) {_ in completion(.normal)}
    alert.addAction(action)
    alert.preferredAction = action
    
    action = UIAlertAction(title: "Hard", style: .default) {_ in completion(.hard)}
    alert.addAction(action)
    
    action = UIAlertAction(title: "Failed", style: .default) {_ in completion(.failed)}
    alert.addAction(action)
    
    view.present(alert, animated: true, completion: nil)
}

func getAMRAPResult(_ view: UIViewController, _ goalReps: Int, _ completion: @escaping (Int, ResultTag) -> Void) {
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
    
    for reps in 0..<goalReps {
        let label = reps == 1 ? "1 Rep" : "\(reps) Reps"
        let action = UIAlertAction(title: label, style: .default) {_ in completion(reps, .failed)}
        alert.addAction(action)
    }
    
    let label = goalReps == 1 ? "1 Rep" : "\(goalReps) Reps"
    var action = UIAlertAction(title: label, style: .default) {_ in completion(goalReps, .hard)}
    alert.addAction(action)
    
    for reps in goalReps+1..<goalReps+3 {
        action = UIAlertAction(title: "\(reps) Reps", style: .default) {_ in completion(reps, .normal)}
        alert.addAction(action)
    }
    
    for reps in goalReps+3..<goalReps+17 {
        action = UIAlertAction(title: "\(reps) Reps", style: .default) {_ in completion(reps, .easy)}
        alert.addAction(action)
    }
    
    view.present(alert, animated: true, completion: nil)
}
