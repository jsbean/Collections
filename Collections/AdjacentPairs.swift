//
//  AdjacentPairs.swift
//  Collections
//
//  Created by James Bean on 12/23/16.
//
//

extension Collection where IndexDistance == Int, Index == Int {
    
    /**
     - returns: All adjacent pairs of elements, if count > 1. Otherwise `nil`.
     */
    public var adjacentPairs: [(Iterator.Element, Iterator.Element)]? {
        guard count > 1 else { return nil }
        return (0 ..< count - 1).map { (self[$0], self[$0 + 1]) }
    }
}
