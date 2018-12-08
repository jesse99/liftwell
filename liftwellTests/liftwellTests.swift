//  Created by Jesse Jones on 10/1/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import XCTest
@testable import liftwell

class liftwellTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testX() {
        XCTAssertEqual("5".x(3, rest: .none, amrap: false), "5 5 5")
        XCTAssertEqual("5".x(3, rest: .none, amrap: true), "5 5 5+")

        XCTAssertEqual("5".x(3, rest: .normal, amrap: false), "5 R 5 R 5")
        XCTAssertEqual("5".x(3, rest: .normal, amrap: true), "5 R 5 R 5+")

        XCTAssertEqual("5-10".x(3, rest: .atEnd, amrap: false), "5-10 R 5-10 R 5-10 R")
        XCTAssertEqual("5-10".x(3, rest: .atEnd, amrap: true), "5-10 R 5-10 R 5-10+ R")
    }
}
