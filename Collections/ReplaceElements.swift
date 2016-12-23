//
//  ReplaceElements.swift
//  Collections
//
//  Created by James Bean on 12/23/16.
//
//

extension Array {
    
    // MARK: - Replace Elements
    
    /// Replace element at given `index` with the given `element`.
    public mutating func replaceElement(at index: Int, withElement newElement: Element)
        throws
    {
        
        guard index > 0 && index < self.count else {
            throw ArrayError.removalError
        }
        
        remove(at: index)
        insert(newElement, at: index)
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
}
