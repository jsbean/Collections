//
//  Split.swift
//  Collections
//
//  Created by James Bean on 2/2/17.
//
//

/// - TODO: Generalize to `Sequence`
extension Array {
    
    public func split(at index: Index) -> ([Element], [Element])? {
        
        guard index >= startIndex && index <= endIndex else {
            return nil
        }
        
        let left = Array(self[startIndex ..< index])
        let right = index == endIndex ? [] : Array(self[index ..< endIndex])
        
        return (left, right)
    }
}
