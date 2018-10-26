//  Created by Jesse Jones on 10/17/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation
import UIKit

extension UILabel {
    func setColor(_ color: UIColor) {
        if let text = self.text , !text.isEmpty {
            if var attrs = self.attributedText?.attributes(at: 0, effectiveRange: nil) {
                attrs[NSAttributedString.Key.foregroundColor] = color
                self.attributedText = NSAttributedString(string: text, attributes: attrs)
            }
        }
    }
}

