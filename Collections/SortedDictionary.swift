//
//  SortedDictionary.swift
//  Collections
//
//  Created by James Bean on 12/23/16.
//
//

/**
 Ordered Dictionary that keeps its `keys` sorted.
 */
public struct SortedDictionary<Key, Value> where Key: Hashable, Key: Comparable {
    
    // MARK: - Instance Properties
    
    /// Sorted keys.
    //public var keyStorage: KeyStorage = []
    
    public var keys: SortedArray<Key> = []
    
    /// Backing dictionary.
    public var values: [Key: Value] = [:]
    
    // MARK: - Initializers
    
    /**
     Create an empty `SortedOrderedDictionary`.
     */
    public init() { }
    
    // MARK: - Instance Methods
    
    /**
     Insert the given `value` for the given `key`. Order will be maintained.
     */
    public mutating func insert(_ value: Value, key: Key) {
        keys.insert(key)
        values[key] = value
    }
    
    /**
     Insert the contents of another `SortedDictionary` value.
     */
    public mutating func insertContents(of sortedDictionary: SortedDictionary<Key, Value>)
    {
        sortedDictionary.forEach { insert($0.1, key: $0.0) }
    }
    
    /**
     - returns: Value at the given `index`, if present. Otherwise, `nil`.
     */
    public func value(at index: Int) -> Value? {
        if index >= keys.count { return nil }
        return values[keys[index]]
    }
}

extension SortedDictionary: Collection {
    
    // MARK: - `Collection`
    
    /// - Index after given index `i`.
    public func index(after i: Int) -> Int {
        
        guard i != endIndex else {
            fatalError("Cannot increment endIndex")
        }
        
        return i + 1
    }
    
    /// - Start index.
    public var startIndex: Int {
        return 0
    }
    
    /// - End index.
    public var endIndex: Int {
        return keys.count
    }
    
    /// - returns: Element at the given `index`.
    public subscript (index: Int) -> (Key, Value) {
        let key = keys[index]
        let value = values[key]!
        return (key, value)
    }
}

extension SortedDictionary: ExpressibleByDictionaryLiteral {
    
    // MARK: - `OrderedDictionary`
    
    /// Create an `OrderedDictionary` with a `DictionaryLiteral`.
    public init(dictionaryLiteral elements: (Key, Value)...) {
        
        self.init()
        
        elements.forEach { (k, v) in
            insert(v, key: k)
        }
    }
}

/*
extension SortedDictionary: DictionaryType {
    
    // MARK: - `DictionaryType`
    
    // Key type.
    public typealias Key = K
    
    // Value type.
    public typealias Value = V
    
    /**
     - returns: Value for the given `key`, if available. Otherise `nil`.
     */
    public subscript(key: Key) -> Value? {
        
        get {
            return values[key]
        }
        
        set(newValue) {
            
            if newValue == nil {
                values.removeValue(forKey: key)
                keyStorage = SortedArray(keyStorage.filter { $0 != key })
                return
            }
            
            let oldValue = values.updateValue(newValue!, forKey: key)
            if oldValue == nil { keyStorage.insert(key) }
        }
    }
}
 */

/*
extension SortedDictionary: OrderedDictionaryType {
    
    // MARK: - `OrderedDictionaryType`
    
    /// `CollectionType` storing keys.
    public typealias KeyStorage = SortedArray<Key>
}

// TODO: Conform to `DictionaryLiteralConvertible`


/**
 - returns: `SortedOrderedDictionary` with values of two `SortedOrderedDictionary` values.
 */
public func + <Value, Key> (
    lhs: SortedDictionary<Value, Key>,
    rhs: SortedDictionary<Value, Key>
    ) -> SortedDictionary<Value, Key> where Key: Hashable, Key: Comparable
{
    var result = lhs
    rhs.forEach { result.insert($0.1, key: $0.0) }
    return result
}
*/
