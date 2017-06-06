//
//  ArrayExtensions.swift
//  Collections
//
//  Created by James Bean on 2/13/17.
//
//

extension Array {
    
    /// - Returns: Left-hand-side value appening the right-hand-side value, if it exists.
    /// Otherwise, the left-hand-side value.
    public static func + (lhs: Array, rhs: Element?) -> Array {
        
        if let element = rhs {
            return lhs + element
        }
        
        return lhs
    }
    
    /// - Returns: Array with the element at the given `index` removed.
    public func removing(at index: Int) -> [Element] {
        var copy = self
        copy.remove(at: index)
        return copy
    }
}
