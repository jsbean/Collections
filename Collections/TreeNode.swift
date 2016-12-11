//
//  TreeNode.swift
//  Collections
//
//  Created by James Bean on 12/9/16.
//
//

/// Node in tree structure.
public enum TreeNode <T> {
    
    // MARK: - Cases
    
    /// Empty.
    case empty
    
    /// Node with value, and 0 or more children nodes.
    indirect case node(T, [TreeNode<T>])
    
    /// Leaves of this `TreeNode`.
    public var leaves: [T] {
        
        func flattened(accum: [T], node: TreeNode) -> [T] {
            switch node {
            case .empty:
                return accum
            case .node(let value, let children):
                
                guard children.count > 0 else {
                    return accum + [value]
                }
                
                return children.reduce(accum, flattened)
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
