//
//  ListProcessing.swift
//  Collections
//
//  Created by James Bean on 12/23/16.
//
//

extension Collection where SubSequence.Iterator.Element == Iterator.Element {

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

        return Array(dropFirst())
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
