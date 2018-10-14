//  Created by Jesse Jones on 10/1/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation

extension Sequence {
    /// Returns true if the sequence is empty or all elements
    /// satisfy the predicate.
    func all(_ predicate: (Iterator.Element) -> Bool) -> Bool {
        for x in self {
            if !predicate(x) {
                return false
            }
        }
        return true
    }
    
    /// Returns false if the sequence is empty or none of the
    /// elements satisfy the predicate.
    func any(_ predicate: (Iterator.Element) -> Bool) -> Bool {
        for x in self {
            if predicate(x) {
                return true
            }
        }
        return false
    }
    
    /// Returns the last element that satisfies predicate.
    func findLast(_ predicate: (Iterator.Element) -> Bool) -> Element? {
        for x in self.reversed() {
            if predicate(x) {
                return x
            }
        }
        return nil
    }
    
    /// Returns the number of elements where the predicate is true.
    func count(_ predicate: (Iterator.Element) -> Bool) -> Int {
        var n = 0
        for x in self {
            if predicate(x) {
                n += 1
            }
        }
        return n
    }
    
    func mapi<T>(_ mapping: (Int, Iterator.Element) -> T) -> [T] {
        var result: [T] = []
        
        for (i, x) in self.enumerated() {
            result.append(mapping(i, x))
        }
        
        return result
    }
}

extension Sequence where Iterator.Element : Comparable {
    func maxElementi() -> (Self.Iterator.Element, Int)? {
        var result: (Self.Iterator.Element, Int)? = nil
        
        for (index, candidate) in self.enumerated() {
            if result == nil || candidate > result!.0 {
                result = (candidate, index)
            }
        }
        
        return result
    }
}


