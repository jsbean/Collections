//
//  Stack.swift
//  Collections
//
//  Created by James Bean on 12/9/16.
//
//

/// Stack structure.
public struct Stack <T> {

    fileprivate var storage: [T] = []

    // MARK: - Instance Properties

    /// Top element of `Stack`.
    public var top: T? {
        return storage.last
    }

    /// - returns: The `top` and the remaining items, if possible. Otherwise, `nil`.
    public var destructured: (T, Stack<T>)? {

        guard self.count > 0 else {
            return nil
        }

        var copy = self
        let top = copy.pop()!
        return (top, copy)
    }

    // MARK: - Initializers

    /// Create an empty `Stack`.
    public init() { }

    /// Create a `Stack` with the elements of an `Array`.
    public init(_ items: [T]) {
        self.storage = items
    }

    /// Create a `Stack` with items.
    public init(_ items: T...) {
        self.storage = items
    }

    // MARK: - Instance Methods

    /// Push item to end of `Stack`.
    public mutating func push(_ item: T) {
        storage.append(item)
    }

    /// - returns: A new `Stack` with the given `item` pushed to the top.
    public func pushing(_ item: T) -> Stack<T> {
        var copy = self
        copy.push(item)
        return copy
    }

    /// - returns: Item from top of `Stack` if there are any. Otherwise, `nil`.
    @discardableResult public mutating func pop() -> T? {
        return storage.popLast()
    }

    /// - returns: `Stack` containing items popped from end of `Stack`
    public mutating func pop(amount: Int) -> Stack<T>? {

        guard storage.count > amount else {
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
        return storage.count
    }

    /// - returns: Element at the given `index`.
    public subscript (index: Int) -> T {
        return storage[index]
    }
}

extension Stack: ExpressibleByArrayLiteral {

    // MARK: - `ExpressibleByArrayLiteral`.

    /// - returns: Create a `SortedArray` with an array literal.
    public init(arrayLiteral elements: T...) {
        self.init(elements)
    }
}


/// - returns: `true` if all items in both `Stack` structs are equivalent. Otherwise `false`.
public func == <T: Equatable> (lhs: Stack<T>, rhs: Stack<T>) -> Bool {
    return lhs.storage == rhs.storage
}
