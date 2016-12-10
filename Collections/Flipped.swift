//
//  Flipped.swift
//  Collections
//
//  Created by James Bean on 12/10/16.
//
//

/// - returns: A tuple with the two values in reverse order.
public func flipped <T,U> (_ a: T, _ b: U) -> (U, T) {
    return (b, a)
}
