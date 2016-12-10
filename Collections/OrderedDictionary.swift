//
//  OrderedDictionary.swift
//  Collections
//
//  Created by James Bean on 12/10/16.
//
//

/// Ordered Dictionary.
public struct OrderedDictionary <K: Hashable, V> {
    
    // MARK: - Instance Properties
    
    /// Ordered keys.
    public var keys: [K] = []
    
    /// Values.
    public var values: [K: V] = [:]
    
    // MARK: - Initializers
    
    /// Create an empty `OrderedDictionary`
    public init() { }
    
    /// - returns: Value for the given `key`, if available. Otherwise, `nil`.
    public subscript(key: K) -> V? {
        
        get {
            return values[key]
        }
        
        set {
            
            guard let newValue = newValue else {
                values.removeValue(forKey: key)
                keys = keys.filter { $0 != key }
                return
            }
            
            let oldValue = values.updateValue(newValue, forKey: key)
            if oldValue == nil { keys.append(key) }
        }
    }
    
    /// Append `value` for given `key`.
    public mutating func append(_ value: V, key: K) {
        keys.append(key)
        values[key] = value
    }
    
    /// Insert `value` for given `key` at `index`.
    public mutating func insert(_ value: V, key: K, index: Int) {
        keys.insert(key, at: index)
        values[key] = value
    }
    
    /// Append the contens of another `OrderedDictionary` structure.
    public mutating func appendContents(of orderedDictionary: OrderedDictionary<K,V>) {
        keys.append(contentsOf: orderedDictionary.keys)
        for key in orderedDictionary.keys {
            values.updateValue(orderedDictionary[key]!, forKey: key)
        }
    }
    
    /// - returns: The value at the given `index`.
    public func value(index: Int) -> V? {
        
        guard index >= 0 && index < keys.count else {
            return nil
        }
        
        return values[keys[index]]
    }
}

/// - returns: `true` if all values contained in both `OrderedDictionary` values are
/// equivalent. Otherwise, `false`.
public func == <K, V: Equatable> (lhs: OrderedDictionary<K,V>, rhs: OrderedDictionary<K,V>)
    -> Bool
{
    
    guard lhs.keys == rhs.keys else {
        return false
    }
    
    for key in lhs.keys {
        
        if rhs.values[key] == nil || rhs.values[key]! != lhs.values[key]! {
            return false
        }
    }
    
    for key in rhs.keys {
        
        if lhs.values[key] == nil || lhs.values[key]! != rhs.values[key]! {
            return false
        }
    }
    
    return true
}

extension OrderedDictionary: ExpressibleByDictionaryLiteral {
    
    // MARK: - `OrderedDictionary`
    
    /// Create an `OrderedDictionary` with a `DictionaryLiteral`.
    public init(dictionaryLiteral elements: (K,V)...) {
        
        self.init()
        
        elements.forEach { (k, v) in
            append(v, key: k)
        }
    }
}
