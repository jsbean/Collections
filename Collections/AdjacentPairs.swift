//
//  AdjacentPairs.swift
//  Collections
//
//  Created by James Bean on 12/23/16.
//
//

extension BidirectionalCollection where IndexDistance == Int, Index == Int {

    /// - Parameter wrapped: Whether or not to include the pair of (last,first)
    /// - Returns: Array containing 2-tuples comprosed of adjacent values.
    public func adjacentPairs(wrapped: Bool = false) -> [(Iterator.Element, Iterator.Element)] {

        guard !isEmpty else {
            return []
        }

        let notWrapped = (0..<count-1).map { (self[$0], self[$0+1]) }
        return wrapped ? notWrapped + (last!, first!) : notWrapped
    }
}
