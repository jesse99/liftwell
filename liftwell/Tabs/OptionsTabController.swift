//  Created by Jesse Jones on 11/10/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import UIKit

class OptionsTabControllerController: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let app = UIApplication.shared.delegate as! AppDelegate
        weightTextbox.text = "\(app.bodyWeight)"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        let app = UIApplication.shared.delegate as! AppDelegate
        if let weight = Int(weightTextbox.text!), weight != app.bodyWeight {
            app.bodyWeight = weight
            app.saveState()
        }
    }
    
    @IBAction func onTapped(_ sender: Any) {
        weightTextbox.resignFirstResponder()
    }
    
    @IBOutlet var weightTextbox: UITextField!
}

