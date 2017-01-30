//
//  ImmutableTree.swift
//  Collections
//
//  Created by James Bean on 12/9/16.
//
//

/// Value-semantic, immutable Tree structure.
public enum Tree <T> {
    
    // MARK: - Cases
    
    /// Container node.
    indirect case container(T, [Tree])
    
    /// Leaf node.
    case leaf(T)
    
    // MARK: - Instance Properties
    
    /// Leaves of this `TreeNode`.
    public var leaves: [T] {
        
        func flattened(accum: [T], node: Tree) -> [T] {
            switch node {
            case .container(_, let children):
                return children.reduce(accum, flattened)
            case .leaf(let value):
                return accum + [value]
            }
        }
        
        return flattened(accum: [], node: self)
    }
    
    // MARK: - Initializers
    
    /// Create a `TreeNode.container` with a `Sequence` parameretized over `T`.
    public init <S: Sequence> (_ value: T, _ sequence: S) where S.Iterator.Element == T {
        self = .container(value, sequence.map(Tree.leaf))
    }
}

extension Tree: CustomStringConvertible {
    
    /// Printed description.
    public var description: String {
        
        func indents(_ amount: Int) -> String {
            return (0 ..< amount).reduce("") { accum, _ in accum + "  " }
        }
        
        func traverse(node: Tree, indentation: Int = 0) -> String {
            
            switch node {
            case .leaf(let value):
                return indents(indentation) + "\(value)"
            case .container(let value, let children):
                return (
                    indents(indentation) + "\(value): (\n" +
                    children
                        .map { traverse(node: $0, indentation: indentation + 1) }
                        .joined(separator: "\n") +
                    "\n" + indents(indentation) + ")"
                )
            }
        }
        
        return traverse(node: self)
    }
}
