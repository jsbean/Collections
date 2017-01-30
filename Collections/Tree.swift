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
    indirect case branch(T, [Tree])
    
    /// Leaf node.
    case leaf(T)
    
    // MARK: - Instance Properties
    
    /// Leaves of this `TreeNode`.
    public var leaves: [T] {
        
        func flattened(accum: [T], node: Tree) -> [T] {
            switch node {
            case .branch(_, let nodes):
                return nodes.reduce(accum, flattened)
            case .leaf(let value):
                return accum + [value]
            }
        }
        
        return flattened(accum: [], node: self)
    }
    
    // MARK: - Initializers
    
    /// Create a `TreeNode.container` with a `Sequence` parameretized over `T`.
    public init <S: Sequence> (_ value: T, _ sequence: S) where S.Iterator.Element == T {
        self = .branch(value, sequence.map(Tree.leaf))
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
            case .branch(let value, let nodes):
                return (
                    indents(indentation) + "\(value): (\n" +
                    nodes
                        .map { traverse(node: $0, indentation: indentation + 1) }
                        .joined(separator: "\n") +
                    "\n" + indents(indentation) + ")"
                )
            }
        }
        
        return traverse(node: self)
    }
}
