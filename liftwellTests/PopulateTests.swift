//  Created by Jesse Jones on 10/13/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import XCTest
@testable import liftwell

class PopulateTests: XCTestCase {
    func testRepsSublabel() {
        let apparatus = Apparatus.barbell(bar: 45.0, collar: 0.0, plates: defaultPlates(), bumpers: [], magnets: [])
        
        var sets = Sets([Set(reps: 5, percent: 0.5), Set(reps: 3, percent: 0.75), Set(reps: 5, percent: 1.0), Set(reps: 5, percent: 1.0), Set(reps: 5, percent: 0.8)])
        XCTAssertEqual(sets.sublabel(apparatus, 100.0, 10), "2x5 @ 100 lbs")
        
        sets = Sets([Set(reps: 5, percent: 0.5), Set(reps: 3, percent: 0.75), Set(minReps: 5, maxReps: 8, percent: 1.0), Set(minReps: 5, maxReps: 8, percent: 1.0)])
        XCTAssertEqual(sets.sublabel(apparatus, 100.0, 4), "2x4-8 @ 100 lbs")
    }
}
