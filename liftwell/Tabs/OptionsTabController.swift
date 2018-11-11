//  Created by Jesse Jones on 11/10/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import UIKit

class OptionsTabControllerController: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let app = UIApplication.shared.delegate as! AppDelegate
        weightTextbox.text = "\(app.bodyWeight)"
    }
    
    @IBAction func onTapped(_ sender: Any) {
        weightTextbox.resignFirstResponder()

        // Nicer to use viewWillDisappear but that is called after viewWillAppear
        // so we do it this way to ensure that the achievements tab is legit.
        let app = UIApplication.shared.delegate as! AppDelegate
        if let weight = Int(weightTextbox.text!), weight != app.bodyWeight {
            app.bodyWeight = weight
            app.saveState()
        }
    }
    
    @IBOutlet var weightTextbox: UITextField!
}

