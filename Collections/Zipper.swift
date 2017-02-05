//
//  Zipper.swift
//  Collections
//
//  Created by James Bean on 2/5/17.
//
//

/// Value of a `Tree` with its neighboring `Tree` values.
public struct Crumb <T> {
    
    /// Associated value of the currently in-focus `tree`.
    public let value: T
    
    /// The other trees to the left and right of the tree currently in focus.
    public let trees: ([Tree<T>], [Tree<T>])
}

/// Navigate an immutable n-ary `Tree` structure.
public struct Zipper <T> {
    
    // MARK: - Associated Types
    
    public typealias Breadcrumbs = [Crumb<T>]
    
    // MARK: - Instance Properties
    
    public let tree: Tree<T>
    public let breadcrumbs: Breadcrumbs
    
    /// Move the `Zipper` up in the tree.
    public var up: Zipper<T> {
        
        guard let (latest, remaining) = breadcrumbs.destructured else {
            return self
        }
        
        let (left, right) = latest.trees
        let trees = left + tree + right
        
        return Zipper(.branch(latest.value, trees), remaining)
    }
    
    public var top: Zipper<T> {
        
        guard !breadcrumbs.isEmpty else {
            return self
        }
        
        return up.top
    }
    
    // MARK: - Initializers
    
    /// Create a `Zipper` with a `Tree` and a
    public init(_ tree: Tree<T>, _ breadcrumbs: Breadcrumbs = Breadcrumbs()) {
        self.tree = tree
        self.breadcrumbs = breadcrumbs
    }
    
    // MARK: - Instance Methods
    
    /// Move focus to the sub-tree with the given `index`.
    ///
    /// - throws: `TreeError` if index is out of bounds.
    public func move(to index: Int) throws -> Zipper<T> {

        switch tree {
            
        // Should never be called on a `leaf`
        case .leaf:
            throw TreeError.branchOperationPerformedOnLeaf
            
        case .branch(let value, let trees):
            
            guard let (left, subTree, right) = trees.splitAndExtractElement(at: index) else {
                throw TreeError.illFormedIndexPath
            }
            
            let crumb = Crumb(value: value, trees: (left, right))
            return Zipper(subTree, crumb + breadcrumbs)
        }
    }
    
    /// Transform the value of the wrapped `Tree`.
    public func update(_ f: (T) -> T) -> Zipper<T> {
        switch tree {
        case .leaf(let value):
            return Zipper(.leaf(f(value)), breadcrumbs)
        case .branch(let value, let trees):
            return Zipper(.branch(f(value), trees), breadcrumbs)
        }
    }
    
    /// Replace the value of the wrapped `Tree` with the given `value`.
    public func update(value: T) -> Zipper<T> {
        return update { _ in value }
    }
}
