//  Created by Jesse Jones on 10/7/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation

class Parser {
    struct Error {
        let mesg: String
        let offset: Int
        
        init(_ mesg: String, _ offset: Int) {
            self.mesg = mesg
            self.offset = offset
        }

        init(expected: String, _ lexer: Lexer) {
            if case .eof = lexer.token() {
                self.mesg = "Expected \(expected) but ran out of characters"
            } else {
                self.mesg = "Expected \(expected) but found '\(lexer.char())'"
            }
            self.offset = lexer.tokenOffset()
        }
    }
    
    init(text: String) {
        self.lexer = Lexer(text: text)
    }
    
    // Sets := Reps*
    func parseSets() -> Either<Parser.Error, [Set]> {
        var result: [Set] = []
        while true {
            if case .eof = lexer.token() {
                break
            }
            if case .slash = lexer.token() {
                break
            }
            switch parseReps() {
            case .left(let m): return .left(m)
            case .right(let r): result.append(r)
            }
        }
                
        return .right(result)
    }

    // Reps := Int ('-' Int)? '+'? ('@' Int '%')? 'R'? 
    private func parseReps() -> Either<Parser.Error, Set> {
        // Int
        let minOffset = lexer.tokenOffset()
        if case .number(let minReps) = lexer.token() {
            lexer.advance()

            // ('-' Int)?
            var maxReps = minReps
            var maxOffset = 0
            if case .dash = lexer.token() {
                lexer.advance()
                maxOffset = lexer.tokenOffset()
                if case .number(let n) = lexer.token() {
                    lexer.advance()
                    maxReps = n
                } else {
                    return .left(Error(expected: "maxReps", lexer))
                }
            }

            // '+'?
            var amrap = false
            if case .plus = lexer.token() {
                lexer.advance()
                amrap = true
            }

            // ('@' Int '%')?
            var percent = 100
            var percentOffset = 0
            if case .at = lexer.token() {
                lexer.advance()

                percentOffset = lexer.tokenOffset()
                if case .number(let n) = lexer.token() {
                    lexer.advance()
                    percent = n
                    
                    if case .percent = lexer.token() {
                        lexer.advance()
                    } else {
                        return .left(Error(expected: "%", lexer))
                    }
                    
                } else {
                    return .left(Error(expected: "percentage", lexer))
                }
            }
            
            // 'R'?
            var rest = false
            if case .rest = lexer.token() {
                lexer.advance()
                rest = true
            }

            if minReps < 1 {
                return .left(Error("minReps should be greater than 0", minOffset))
            }
            if maxReps < minReps {
                return .left(Error("maxReps is less than minReps", maxOffset))
            }
            if percent > 100 {
                return .left(Error("percentage should be less than or equal to 100", percentOffset))
            }
            return .right(Set(minReps: minReps, maxReps: maxReps, percent: Double(percent)/100.0, amrap: amrap, rest: rest))

        } else {
            return .left(Error(expected: "minReps", lexer))
        }
    }
        
    private var lexer: Lexer
}


enum Token: Equatable {
    case number(Int)
    case rest
    case dash
    case plus
    case slash
    case at
    case percent
    case eof
    case unexpected(Character)
}

class Lexer {
    init(text: String) {
        self.text = text
        self.advance()
    }
    
    func token() -> Token {
        return currentToken
    }
    
    func tokenOffset() -> Int {
        return currentOffset
    }
    
    func char() -> Character {
        let index = text.index(text.startIndex, offsetBy: tokenOffset())
        return text[index]
    }
    
    func advance() {
        skipWhitespace()
        if atEnd() {
            currentToken = .eof
            currentOffset = offset
            return
        }
        
        let index = text.index(text.startIndex, offsetBy: offset)
        switch text[index] {
        case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9": lexNumber(index)
        case "R": currentToken = .rest; currentOffset = offset; offset += 1
        case "-": currentToken = .dash; currentOffset = offset; offset += 1
        case "+": currentToken = .plus; currentOffset = offset; offset += 1
        case "/": currentToken = .slash; currentOffset = offset; offset += 1
        case "@": currentToken = .at; currentOffset = offset; offset += 1
        case "%": currentToken = .percent; currentOffset = offset; offset += 1
        default: currentToken = .unexpected(text[index]); currentOffset = offset; offset += 1
        }
    }
    
    private func atEnd() -> Bool {
        return offset >= text.count
    }
    
    private func lexNumber(_ start: String.Index) {
        let startOffset = offset
        var found = true
        while !atEnd() && found {
            let index = text.index(text.startIndex, offsetBy: offset)
            switch text[index] {
            case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9": offset += 1
            default: found = false
            }
        }
        let end = text.index(text.startIndex, offsetBy: offset)
        let s = text[start..<end]
        
        let n = Int(s)!
        currentToken = .number(n)
        currentOffset = startOffset
    }
    
    private func skipWhitespace() {
        var found = true
        while !atEnd() && found {
            let index = text.index(text.startIndex, offsetBy: offset)
            switch text[index] {
            case " ", "\n", "\t": offset += 1
            default: found = false
            }
        }
    }
    
    private let text: String
    private var offset: Int = 0 // it'd be a bit more efficient to use a String.Index here but that does make it harder to inspect state when debugging...
    private var currentToken: Token = Token.unexpected(" ")
    private var currentOffset = 0
}
