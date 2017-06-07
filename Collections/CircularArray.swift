//
//  CircularArray.swift
//  Collections
//
//  Created by James Bean on 6/6/17.
//
//

/// Array-like structure that allows retrieval of elements at indices outside of the bounds of
/// the internal storage.
public struct CircularArray<Element> {
    
    internal var storage: Array<Element>
    
    // MARK: - Initializers
    
    /// Creates a `CircularArray` with an sequence.
    public init <S: Sequence> (_ storage: S) where S.Iterator.Element == Element {
        self.storage = Array(storage)
    }
    
    // MARK: - Instance Methods
    
    /// - Returns: Element at the given logical index.
    public subscript (circular index: Int) -> Element {
        return storage[circularIndex(index)]
    }
    
    /// - Returns: Array of elements from (and including) the given logical `start` index
    /// through (and including) the given logical `end` index.
    ///
    /// - Note: If the real start index is greater than the real end index (for the given
    /// logical indices), the resultant array will loop around the back, to the front of the
    /// internal storage.
    public subscript (from start: Int, through end: Int) -> [Element] {
        
        let start = circularIndex(start)
        let end = circularIndex(end)
        
        if start > end {
            let back = storage[start..<storage.count]
            let front = storage[0...end]
            return Array(back + front)
        }
        
        return Array(storage[start...end])
    }
    
    /// - Returns: Array of elements after (not including) the given logical `start` index
    /// up to (not including) the given logical `end` index.
    ///
    /// - Note: If the real start index is greater than the real end index (for the given
    /// logical indices), the resultant array will loop around the back, to the front of the
    /// internal storage.
    public subscript (after start: Int, upTo end: Int) -> [Element] {
        return self[from: start + 1, through: end - 1]
    }
    
    /// - Returns: A new `CircularArray` with the element removed at the given `index`.
    public func removing(at index: Int) -> CircularArray<Element> {
        return CircularArray(self.storage.removing(at: index))
    }
    
    private func circularIndex(_ index: Int) -> Int {
        return mod(index, storage.count)
    }
}

extension CircularArray: BidirectionalCollection {
    
    /// Start index.
    public var startIndex: Int {
        return storage.startIndex
    }
    
    /// End index.
    public var endIndex: Int {
        return storage.endIndex
    }
    
    /// Element at index.
    public subscript (index: Int) -> Element {
        return storage[index]
    }
    
    /// Index after given `i`.
    public func index(after i: Int) -> Int {
        
        guard i < endIndex else {
            fatalError("Index \(i) out of range.")
        }
        
        return i + 1
    }
    
    /// Index before given `i`.
    public func index(before i: Int) -> Int {
        
        guard i > startIndex else {
            fatalError("Index \(i) out of range.")
        }
        
        return i - 1
    }
}

/// - returns: "True" modulo (not "remainder", which is implemented by Swift's `%`).
private func mod <T: Integer> (_ dividend: T, _ modulus: T) -> T {
    let result = dividend % modulus
    return result < 0 ? result + modulus : result
}

extension Array {
    
    /// - Returns: `CircularArray` containing the elements contained herein.
    public var circular: CircularArray<Element> {
        return CircularArray(self)
    }
}
