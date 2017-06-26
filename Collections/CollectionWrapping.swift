//
//  CollectionWrapping.swift
//  Collections
//
//  Created by James Bean on 1/10/17.
//
//

/// `CollectionWrapping` is a type-erasing protocol that allows a `Collection`-conforming
/// structure to wrap any underlying `Collection` implementation.
///
/// As a result, all of the `Collection` boilerplate is done for free.
public protocol CollectionWrapping: Collection {
    
    // MARK: - Associated Types
    
    /// The contained type.
    associatedtype Element
    
    // MARK: - Instance Properties
    
    /// `AnyCollection` wrapper that provides shade for the domain specific implementation.
    var collection: AnyCollection<Element> { get }
}

extension CollectionWrapping {
    
    // MARK: - `Collection`
    
    /// Index after given index `i`.
    public func index(after i: AnyIndex) -> AnyIndex {
        return collection.index(after: i)
    }
    
    /// Start index.
    public var startIndex: AnyIndex {
        return collection.startIndex
    }
    
    /// End index.
    public var endIndex: AnyIndex {
        return collection.endIndex
    }
    
    /// - returns: Element at the given `index`.
    public subscript (index: AnyIndex) -> Element {
        return collection[index]
    }
}
