//  Created by Jesse Jones on 10/7/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation

/// A type representing an alternative of one of two types.
///
/// By convention, and where applicable, `Left` is used to indicate failure, while `Right` is used to indicate success. (Mnemonic: “right” is a synonym for “correct.”)
///
/// Otherwise, it is implied that `Left` and `Right` are effectively unordered alternatives of equal standing.
public enum Either<T, U> {
    case left(T)
    case right(U)
}
