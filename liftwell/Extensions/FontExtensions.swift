//  Created by Jesse Jones on 10/21/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import UIKit

extension UIFont {
    func makeBold() -> UIFont {
        if let descriptor = self.fontDescriptor.withSymbolicTraits(.traitBold) {
            return UIFont(descriptor: descriptor, size: self.pointSize)
        }
        return self
    }
}

