//
//  Stack.swift
//  Collections
//
//  Created by James Bean on 12/9/16.
//
//

/// Stack structure.
public struct Stack <T> {
    
    fileprivate var items: [T] = []
    
    // MARK: - Instance Properties
    
    /// Last element in `Stack`.
    public var top: T? { return items.last }
    
    // MARK: - Initializers

    /// Create an empty `Stack`.
    public init() { }
    
    /// Create a `Stack` with the elements of an `Array`.
    public init(_ items: [T]) {
        self.items = items
    }
    
    /// Create a `Stack` with items.
    public init(_ items: T...) {
        self.items = items
    }
    
    // MARK: - Instance Methods
    
    /// Push item to end of `Stack`.
    public mutating func push(_ item: T) {
        items.append(item)
    }
    
    /// Pop item from end of `Stack` if there are any items. Otherwise, `nil`.
    public mutating func pop() -> T? {
        return items.popLast()
    }
    
    /// - returns: `Stack` containing items popped from end of `Stack`
    public mutating func pop(amount: Int) -> Stack<T>? {
        
        guard items.count > amount else {
            return nil
        }
        
        var poppedItems = Stack<T>()
        for _ in 0..<amount { poppedItems.push(pop()!) }
        return poppedItems
    }
}

extension Stack: Collection {
    
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
        return items.count
    }

    /// - returns: Element at the given `index`.
    public subscript (index: Int) -> T {
        return items[index]
    }
}

/// - returns: `true` if all items in both `Stack` structs are equivalent. Otherwise `false`.
public func == <T: Equatable> (lhs: Stack<T>, rhs: Stack<T>) -> Bool {
    return lhs.items == rhs.items
}
