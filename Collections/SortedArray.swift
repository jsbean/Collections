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

    /// Insert the given `element`.
    ///
    /// - Complexity: O(_n_)
    public mutating func insert(_ element: Element) {
        let index = self.index(for: element)
        elements.insert(element, at: index)
    }

    /// Insert the contents of another sequence of `T`.
    public mutating func insert <S: Sequence> (contentsOf elements: S)
        where S.Iterator.Element == Element
    {
        elements.forEach { insert($0) }
    }

    /// - Returns: Index for the given `element`, if it exists. Otherwise, `nil`.
    public func index(of element: Element) -> Int? {
        let index = self.index(for: element)
        guard index < count, elements[index] == element else { return nil }
        return index
    }

    /// Binary search to find insertion point
    ///
    /// - TODO: Move to extension on `BidirectionCollection where Element: Comparable`.
    private func index(for element: Element) -> Int {
        var start = 0
        var end = elements.count
        while start < end {
            let middle = start + (end - start) / 2
            if element > elements[middle] {
                start = middle + 1
            } else {
                end = middle
            }
        }
        return start
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

    /// - Returns: Element at the given `index`.
    public subscript (index: Int) -> Element {
        return elements[index]
    }

    /// - Returns: Element with the least value.
    public func min() -> Element? {
        return first
    }

    /// - Returns: Element with the greatest value.
    public func max() -> Element? {
        return last
    }

    /// - Returns: Elements, sorted.
    public func sorted() -> [Element] {
        return elements
    }

    /// - Returns: `true` if the given `element` is contained herein. Otherwise, `false`.
    public func contains(_ element: Element) -> Bool {
        return index(of: element) != nil
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
    /// - Complexity: O(1)
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
