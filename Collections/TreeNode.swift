//
//  TreeNode.swift
//  Collections
//
//  Created by James Bean on 12/9/16.
//
//

/// Node in tree structure
public enum TreeNode <T> {
    
    // MARK: - Cases
    
    /// Container node.
    case container([TreeNode])
    
    /// Leaf node.
    case leaf(T)
    
    // MARK: - Instance Properties
    
    /// Leaves of this `TreeNode`.
    public var leaves: [T] {
        
        func flatten(accum: [T], node: TreeNode) -> [T] {
            switch node {
            case .container(let children):
                return children.reduce(accum, flatten)
            case .leaf(let value):
                return accum + [value]
            }
        }
        
        return flatten(accum: [], node: self)
    }
    
    // MARK: - Initializers
    
    /// Create a `TreeNode.container` with a `Sequence` parameretized over `T`.
    public init <S: Sequence> (_ sequence: S) where S.Iterator.Element == T {
        self = .container(sequence.map(TreeNode.leaf))
    }
}
