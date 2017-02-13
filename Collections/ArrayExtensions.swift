//
//  ArrayExtensions.swift
//  Collections
//
//  Created by James Bean on 2/13/17.
//
//

extension Array {
    
    /// - returns: Left-hand-side value appening the right-hand-side value, if it exists. 
    /// Otherwise, the left-hand-side value.
    public static func + (lhs: Array, rhs: Element?) -> Array {
        
        if let element = rhs {
            return lhs + element
        }
        
        return lhs
    }
}
