//  Created by Jesse Jones on 10/1/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import XCTest
@testable import liftwell

class ParserTests: XCTestCase {
    func testLexer1() {
        let lexer = Lexer(text: "5@9%")
        
        XCTAssertEqual(lexer.token(), Token.number(5))
        
        lexer.advance()
        XCTAssertEqual(lexer.token(), Token.at)
        
        lexer.advance()
        XCTAssertEqual(lexer.token(), Token.number(9))
        
        lexer.advance()
        XCTAssertEqual(lexer.token(), Token.percent)
        
        lexer.advance()
        XCTAssertEqual(lexer.token(), Token.eof)
    }
    
    func testLexer2() {
        let lexer = Lexer(text: "100")
        
        XCTAssertEqual(lexer.token(), Token.number(100))
        
        lexer.advance()
        XCTAssertEqual(lexer.token(), Token.eof)
    }
    
    func testLexer3() {
        let lexer = Lexer(text: "5@75% R   8 @ 85%")
        
        XCTAssertEqual(lexer.token(), Token.number(5))
        
        lexer.advance()
        XCTAssertEqual(lexer.token(), Token.at)
        
        lexer.advance()
        XCTAssertEqual(lexer.token(), Token.number(75))
        
        lexer.advance()
        XCTAssertEqual(lexer.token(), Token.percent)
        
        lexer.advance()
        XCTAssertEqual(lexer.token(), Token.rest)
        
        lexer.advance()
        XCTAssertEqual(lexer.token(), Token.number(8))
        
        lexer.advance()
        XCTAssertEqual(lexer.token(), Token.at)
        
        lexer.advance()
        XCTAssertEqual(lexer.token(), Token.number(85))
        
        lexer.advance()
        XCTAssertEqual(lexer.token(), Token.percent)
        
        lexer.advance()
        XCTAssertEqual(lexer.token(), Token.eof)
    }
    
    func testParser1() {
        let parser = Parser(text: "5 R 3")
        switch parser.parseSets() {
        case .left(let err): XCTAssert(false, "\(err.mesg) at \(err.offset)")
        case .right(let sets):
            XCTAssertEqual(sets.count, 2)
            XCTAssertEqual(sets[0].minReps, 5)
            XCTAssertEqual(sets[0].maxReps, 5)
            XCTAssertEqual(sets[0].percent, 1.0)
            XCTAssertEqual(sets[0].amrap, false)
            XCTAssertEqual(sets[0].rest, true)
            
            XCTAssertEqual(sets[1].minReps, 3)
            XCTAssertEqual(sets[1].maxReps, 3)
            XCTAssertEqual(sets[1].percent, 1.0)
            XCTAssertEqual(sets[1].amrap, false)
            XCTAssertEqual(sets[1].rest, false)
        }
    }
    
    func testParser2() {
        let parser = Parser(text: "  5@50% R 4-8@100% R  4+ @100% ")
        switch parser.parseSets() {
        case .left(let err): XCTAssert(false, "\(err.mesg) at \(err.offset)")
        case .right(let sets):
            XCTAssertEqual(sets.count, 3)
            XCTAssertEqual(sets[0].minReps, 5)
            XCTAssertEqual(sets[0].maxReps, 5)
            XCTAssertEqual(sets[0].percent, 0.5)
            XCTAssertEqual(sets[0].amrap, false)
            XCTAssertEqual(sets[0].rest, true)
            
            XCTAssertEqual(sets[1].minReps, 4)
            XCTAssertEqual(sets[1].maxReps, 8)
            XCTAssertEqual(sets[1].percent, 1.0)
            XCTAssertEqual(sets[1].amrap, false)
            XCTAssertEqual(sets[1].rest, true)
            
            XCTAssertEqual(sets[2].minReps, 4)
            XCTAssertEqual(sets[2].maxReps, 4)
            XCTAssertEqual(sets[2].percent, 1.0)
            XCTAssertEqual(sets[2].amrap, true)
            XCTAssertEqual(sets[2].rest, false)
        }
    }
    
    func testParser3() {
        let parser = Parser(text: "5@50% R 4-@100%")
        switch parser.parseSets() {
        case .left(let err):
            XCTAssertEqual(err.mesg, "Expected maxReps but found '@'")
            XCTAssertEqual(err.offset, 10)
        case .right(_):
            XCTAssert(false)
        }
    }
    
    func testParser4() {
        let parser = Parser(text: "5@50% R 4-2@100%")
        switch parser.parseSets() {
        case .left(let err):
            XCTAssertEqual(err.mesg, "maxReps is less than minReps")
            XCTAssertEqual(err.offset, 10)
        case .right(_):
            XCTAssert(false)
        }
    }
    
    func testParser5() {
        let parser = Parser(text: "random gibberish")
        switch parser.parseSets() {
        case .left(let err):
            XCTAssertEqual(err.mesg, "Expected minReps but found 'r'")
            XCTAssertEqual(err.offset, 0)
        case .right(_):
            XCTAssert(false)
        }
    }
    
    func testParser6() {
        let parser = Parser(text: "5 3 5/5 3 3")
        switch parser.parseCycles() {
        case .left(let err): XCTAssert(false, "\(err.mesg) at \(err.offset)")
        case .right(let cycles):
            XCTAssertEqual(cycles.count, 2)
            
            let cycle1 = cycles[0]
            XCTAssertEqual(cycle1.sets.count, 3)
            XCTAssertEqual(cycle1.sets[0].minReps, 5)
            XCTAssertEqual(cycle1.sets[1].minReps, 3)
            XCTAssertEqual(cycle1.sets[2].minReps, 5)
            
            let cycle2 = cycles[1]
            XCTAssertEqual(cycle2.sets.count, 3)
            XCTAssertEqual(cycle2.sets[0].minReps, 5)
            XCTAssertEqual(cycle2.sets[1].minReps, 3)
            XCTAssertEqual(cycle2.sets[2].minReps, 3)
        }
    }
}
