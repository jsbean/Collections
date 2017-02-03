//
//  ReplaceElements.swift
//  Collections
//
//  Created by James Bean on 12/23/16.
//
//

/// - TODO: Move up to `Collection`
extension Array {
    
    // MARK: - Replace Elements
    
    /// Replace element at given `index` with the given `element`.
    public mutating func replaceElement(at index: Int, with element: Element)
        throws
    {
        
        guard index >= startIndex && index < endIndex else {
            throw ArrayError.removalError
        }
        
        remove(at: index)
        insert(element, at: index)
    }
    
    /// Immutable version of `replaceElement(at:with:)`
    public func replacingElement(at index: Int, with element: Element) throws -> Array {
        var copy = self
        try copy.replaceElement(at: index, with: element)
        return copy
    }
    
    /// Replace the last element in `Array` with the given `element`.
    public mutating func replaceLast(with element: Element) throws {
        
        guard self.count > 0 else {
            throw ArrayError.removalError
        }
        
        removeLast()
        append(element)
    }
    
    
    /// Replace first element in Array with a new element.
    ///
    /// - throws: `ArrayError.removalError` if `self` is empty.
    public mutating func replaceFirst(with element: Element) throws {
        
        try removeFirst()
        insert(element, at: 0)
    }
    
    // TODO: Implement immutable versions (`replacingElement(at:with:) -> Array`)
}
