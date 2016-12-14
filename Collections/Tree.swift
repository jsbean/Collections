//
//  Tree.swift
//  Collections
//
//  Created by James Bean on 12/9/16.
//
//

/// Node in tree structure
public enum Tree <T> {
    
    // MARK: - Cases
    
    /// Empty tree.
    case empty
    
    /// Node with 0 or more subtrees.
    indirect case node (T, [Tree])
    
    // MARK: - Instance Properties
    
    /// Leaves of this `Tree`.
    public var leaves: [T] {
        
        func flattened(accum: [T], node: Tree) -> [T] {
            switch node {
            case .empty:
                return []
            case .node(let element, let children):
                return children.isEmpty
                    ? accum + [element]
                    : children.reduce(accum, flattened)
            }
        }
        
        return flattened(accum: [], node: self)
    }
    
    // MARK: - Initializers
    
    /// Create a `TreeNode.container` with a `Sequence` parameretized over `T`.
    public init <S: Sequence> (_ value: T, _ sequence: S) where S.Iterator.Element == T {
        self = .node(value, sequence.map { .node($0, []) })
    }
}
