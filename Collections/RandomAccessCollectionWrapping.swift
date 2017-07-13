//
//  RandomAccessCollectionWrapping.swift
//  Collections
//
//  Created by James Bean on 7/13/17.
//
//

/// Interface for wrapping any `RandomAccessCollection` type. The `RandomAccessCollection` interface
/// is exposed, regardless of the concrete implementation of the wrapped type.
///
/// The performance guarantees made by the `RandomAccessCollection` are sustained.
public protocol RandomAccessCollectionWrapping: RandomAccessCollection {

    // MARK: - Assosicated Types

    /// The type contained by the wrapped type.
    associatedtype Element

    // MARK: - Instance Properties

    /// `AnyRandomAccessCollection` that exposes the `RandomAccessCollection` interface, while
    /// hiding the concrete implementation of the wrapped type.
    var randomAccessCollection: AnyRandomAccessCollection<Element> { get }
}

extension RandomAccessCollectionWrapping {

    // MARK: - RandomAccessCollection

    /// Start index.
    ///
    /// - Complexity: O(1)
    ///
    public var startIndex: AnyIndex {
        return randomAccessCollection.startIndex
    }

    /// End index.
    ///
    /// - Complexity: O(1)
    ///
    public var endIndex: AnyIndex {
        return randomAccessCollection.endIndex
    }

    /// First element, if there is at least one element. Otherwise, `nil`.
    ///
    /// - Complexity: O(1)
    ///
    public var first: Element? {
        return randomAccessCollection.first
    }

    /// Last element, if there is at least one element. Otherwise, `nil`.
    ///
    /// - Complexity: O(1)
    ///
    public var last: Element? {
        return randomAccessCollection.last
    }

    /// Amount of elements.
    ///
    /// - Complexity: O(1)
    ///
    public var count: IntMax {
        return randomAccessCollection.count
    }

    /// - Returns: `true` if there are no elements contained herein. Otherwise, `false`.
    ///
    /// - Complexity: O(1)
    ///
    public var isEmpty: Bool {
        return randomAccessCollection.isEmpty
    }

    /// - Returns: The element at the given `index`.
    ///
    /// - Complexity: O(1)
    ///
    public subscript(index: AnyIndex) -> Element {
        return randomAccessCollection[index]
    }

    /// - Returns: Index after the given `index`.
    ///
    /// - Complexity: O(1)
    public func index(after index: AnyIndex) -> AnyIndex {
        return randomAccessCollection.index(after: index)
    }

    /// - Returns: Index before the given `index`.
    ///
    /// - Complexity: O(1)
    ///
    public func index(before index: AnyIndex) -> AnyIndex {
        return randomAccessCollection.index(before: index)
    }

}
