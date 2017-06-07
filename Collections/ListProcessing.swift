//
//  ListProcessing.swift
//  Collections
//
//  Created by James Bean on 12/23/16.
//
//

extension Collection where Index == Int, SubSequence.Iterator.Element == Iterator.Element {
    
    // MARK: - List Processing
    
    /// First `Element` of a list.
    public var head: Iterator.Element? {
        return first
    }
    
    /// Remaining `Elements` of a list.
    public var tail: Array<Iterator.Element>? {
        
        guard !isEmpty else {
            return nil
        }
        
        return Array(self[1..<endIndex])
    }
    
    /// 2-tuple containing the `head` `Element` and `tail` `[Element]` of `Self`
    public var destructured: (Iterator.Element, Array<Iterator.Element>)? {
        
        guard
            let head = head,
            let tail = tail
        else {
            return nil
        }
        
        return (head, tail)
    }
}

/// - returns: New `Array` with the first element `head`, and the remaining elements of `tail`.
public func + <T> (head: T, tail: [T]) -> [T] {
    return [head] + tail
}

/// - returns: New `Array` with `item` appended to the end of `list`.
public func + <T> (list: [T], item: T) -> [T] {
    return list + [item]
}
