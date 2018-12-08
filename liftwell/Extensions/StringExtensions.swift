//  Created by Jesse Jones on 12/8/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation

enum RestType {
    case none
    case normal
    case atEnd
}

extension String {
    /// Used to help construct sets string literals.
    func x(_ count: Int, rest: RestType = .normal, amrap: Bool = false) -> String {
        var result = ""
        
        for i in 0..<count {
            result += self
            
            if amrap && i + 1 == count {
                result += "+"
            }

            switch rest {
            case .none: if i + 1 < count {result += " "}
            case .normal: if i + 1 < count {result += " R "}
            case .atEnd: result += " R "
            }
        }
        return result
    }
}
