//
//  SortedArray.swift
//  Collections
//
//  Created by James Bean on 12/10/16.
//
//

import Algebra

/// `Array` that keeps itself sorted.
public struct SortedArray <Element: Comparable> {

    fileprivate var elements: [Element] = []

    // MARK: - Initializers

    /// Create an empty `SortedArray`.
    public init() { }

    /// Create a `SortedArray` with the given sequence of `elements`.
    public init <S: Sequence> (_ elements: S) where S.Iterator.Element == Element {
        self.elements = Array(elements).sorted()
    }

    // MARK: - Instance Methods

    /// Remove the given `element`, if it is contained herein.
    ///
    /// - TODO: Make `throws` instead of returning silently.
    public mutating func remove(_ element: Element) {
        guard let index = elements.index(of: element) else { return }
        elements.remove(at: index)
    }

    /// Insert the given `element`. Order will be kept.
    public mutating func insert(_ element: Element) {
        let index = insertionPoint(for: element)
        elements.insert(element, at: index)
    }

    /// Insert the contents of another sequence of `T`.
    public mutating func insert <S: Sequence> (contentsOf elements: S)
        where S.Iterator.Element == Element
    {
        elements.forEach { insert($0) }
    }

    /// Binary search to find insertion point
    ///
    /// - TODO: Move to extension on `BidirectionCollection where Element: Comparable`.
    private func insertionPoint(for element: Element) -> Int {
        var range = 0 ..< elements.count
        while range.startIndex < range.endIndex {
            let midIndex = range.startIndex + (range.endIndex - range.startIndex) / 2
            if elements[midIndex] == element {
                return midIndex
            } else if elements[midIndex] < element {
                range = (midIndex + 1) ..< range.endIndex
            } else {
                range = range.startIndex ..< midIndex
            }
        }
        return range.startIndex
    }
}

extension SortedArray: Collection {

    // MARK: - Collection

    /// - Returns: Index after the given `index`.
    public func index(after i: Int) -> Int {
        assert(i < endIndex, "Cannot increment index to \(i + 1)")
        return i + 1
    }

    /// Start index.
    public var startIndex: Int {
        return 0
    }

    /// End index.
    public var endIndex: Int {
        return elements.count
    }

    /// - returns: Element at the given `index`.
    public subscript (index: Int) -> Element {
        return elements[index]
    }
}

extension SortedArray: BidirectionalCollection {

    // MARK: - BidirectionalCollection

    /// - Returns: Index before the given `index`.
    public func index(before index: Int) -> Int {
        assert(index > 0, "Cannot decrement index to \(index - 1)")
        return index - 1
    }

    /// Count of elements contained herein.
    ///
    /// - Complexity: O(_1_)
    ///
    public var count: Int {
        return elements.count
    }
}

extension SortedArray: Equatable {

    // MARK: - Equatable

    /// - returns: `true` if all elements in both arrays are equivalent. Otherwise, `false`.
    public static func == <T> (lhs: SortedArray<T>, rhs: SortedArray<T>) -> Bool {
        return lhs.elements == rhs.elements
    }
}

extension SortedArray: Additive {

    // MARK: - Additive

    /// - Returns: Empty `SortedArray`.
    public static var zero: SortedArray<Element> {
        return SortedArray()
    }

    /// - returns: `SortedArray` with the contents of two `SortedArray` values.
    public static func + <T> (lhs: SortedArray<T>, rhs: SortedArray<T>) -> SortedArray<T> {
        var result = lhs
        result.insert(contentsOf: rhs)
        return result
    }
}

extension SortedArray: Monoid {

    // MARK: - Monoid

    /// - Returns: Empty `SortedArray`.
    public static var identity: SortedArray<Element> {
        return .zero
    }

    /// - Returns: Composition of two of the same `Semigroup` type values.
    public static func <> (lhs: SortedArray<Element>, rhs: SortedArray<Element>)
        -> SortedArray<Element>
    {
        return lhs + rhs
    }
}

extension SortedArray: ExpressibleByArrayLiteral {

    // MARK: - ExpressibleByArrayLiteral

    /// - returns: Create a `SortedArray` with an array literal.
    public init(arrayLiteral elements: Element...) {
        self.init(elements)
    }
}
