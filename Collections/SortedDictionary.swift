//
//  SortedDictionary.swift
//  Collections
//
//  Created by James Bean on 12/23/16.
//
//

import Foundation

/// Ordered dictionary which has sorted `keys`.
public struct SortedDictionary<Key, Value>: DictionaryProtocol where Key: Hashable & Comparable {

    // MARK: - Instance Properties

    /// Sorted keys.
    public var keys: SortedArray<Key> = []

    /// Backing dictionary.
    ///
    // FIXME: Make `private` in Swift 4
    internal var unsorted: [Key: Value] = [:]

    // MARK: - Initializers

    /// Create an empty `SortedOrderedDictionary`.
    public init() { }

    // MARK: - Subscripts

    /// - returns: Value for the given `key`, if available. Otherwise, `nil`.
    public subscript(key: Key) -> Value? {

        get {
            return unsorted[key]
        }

        set {

            guard let newValue = newValue else {
                unsorted.removeValue(forKey: key)
                keys.remove(key)
                return
            }

            let oldValue = unsorted.updateValue(newValue, forKey: key)

            if oldValue == nil {
                keys.insert(key)
            }
        }
    }

    // MARK: - Instance Methods

    /// Insert the given `value` for the given `key`. Order will be maintained.
    public mutating func insert(_ value: Value, key: Key) {
        keys.insert(key)
        unsorted[key] = value
    }

    /// Insert the contents of another `SortedDictionary` value.
    public mutating func insertContents(of sortedDictionary: SortedDictionary<Key, Value>) {
        sortedDictionary.forEach { insert($0.1, key: $0.0) }
    }

    /// - returns: Value at the given `index`, if present. Otherwise, `nil`.
    public func value(at index: Int) -> Value? {
        if index >= keys.count { return nil }
        return unsorted[keys[index]]
    }
}

extension SortedDictionary: Collection {

    // MARK: - `Collection`

    /// Index after given index `i`.
    public func index(after i: Int) -> Int {
        assert(i < endIndex, "Cannot decrement index to \(i - 1)")
        return i + 1
    }

    /// Start index.
    public var startIndex: Int {
        return 0
    }

    /// End index.
    public var endIndex: Int {
        return keys.count
    }

    /// - returns: Element at the given `index`.
    public subscript (index: Int) -> (Key, Value) {
        let key = keys[index]
        let value = unsorted[key]!
        return (key, value)
    }
}

extension SortedDictionary: BidirectionalCollection {

    public func index(before i: Int) -> Int {
        assert(i > 0, "Cannot decrement index to \(i - 1)")
        return i - 1
    }
}

extension SortedDictionary: ExpressibleByDictionaryLiteral {

    // MARK: - `ExpressibleByDictionaryLiteral`

    /// Create a `SortedDictionary` with a `DictionaryLiteral`.
    public init(dictionaryLiteral elements: (Key, Value)...) {

        self.init()

        elements.forEach { (k, v) in
            insert(v, key: k)
        }
    }
}

/// - returns: `true` if all values contained in both `SortedDictionary` values are
/// equivalent. Otherwise, `false`.
public func == <K, V: Equatable> (lhs: SortedDictionary<K,V>, rhs: SortedDictionary<K,V>)
    -> Bool
{

    guard lhs.keys == rhs.keys else {
        return false
    }

    for key in lhs.keys {

        if rhs.unsorted[key] == nil || rhs.unsorted[key]! != lhs.unsorted[key]! {
            return false
        }
    }

    for key in rhs.keys {

        if lhs.unsorted[key] == nil || lhs.unsorted[key]! != rhs.unsorted[key]! {
            return false
        }
    }

    return true
}

/// - returns: `SortedOrderedDictionary` with values of two `SortedOrderedDictionary` values.
public func + <Value, Key> (
    lhs: SortedDictionary<Value, Key>,
    rhs: SortedDictionary<Value, Key>
) -> SortedDictionary<Value, Key> where Key: Hashable, Key: Comparable
{
    var result = lhs
    rhs.forEach { result.insert($0.1, key: $0.0) }
    return result
}
