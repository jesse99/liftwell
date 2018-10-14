//  Created by Jesse Jones on 10/13/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import XCTest
@testable import liftwell

class PopulateTests: XCTestCase {
    func testRepsSublabel() {
        let apparatus = Apparatus.barbell(bar: 45.0, collar: 0.0, plates: defaultPlates(), bumpers: [], magnets: [])
        
        var sets = [Reps(reps: 5, percent: 0.5), Reps(reps: 3, percent: 0.75), Reps(reps: 5, percent: 1.0), Reps(reps: 5, percent: 1.0), Reps(reps: 5, percent: 0.8)]
        XCTAssertEqual(repsSublabel(apparatus, sets, 100.0, 10), "2x5 @ 100 lbs")
        
        sets = [Reps(reps: 5, percent: 0.5), Reps(reps: 3, percent: 0.75), Reps(minReps: 5, maxReps: 8, percent: 1.0), Reps(minReps: 5, maxReps: 8, percent: 1.0)]
        XCTAssertEqual(repsSublabel(apparatus, sets, 100.0, 4), "2x4-8 @ 100 lbs")
    }
}