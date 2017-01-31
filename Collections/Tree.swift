//
//  ImmutableTree.swift
//  Collections
//
//  Created by James Bean on 12/9/16.
//
//

/// Value-semantic, immutable Tree structure.
///
/// Parameterized over two types:
///
/// - `B`: Type of payload carried by `branch` cases
/// - `L`: Type of payload carried by `leaf` cases
public enum Tree <B,L> {
    
    // MARK: - Cases
    
    /// Container node.
    indirect case branch(B, [Tree])
    
    /// Leaf node.
    case leaf(L)
    
    // MARK: - Instance Properties
    
    /// Leaves of this `TreeNode`.
    public var leaves: [L] {
        
        func flattened(accum: [L], tree: Tree) -> [L] {
            switch tree {
            case .branch(_, let trees):
                return trees.reduce(accum, flattened)
            case .leaf(let value):
                return accum + [value]
            }
        }
        
        return flattened(accum: [], tree: self)
    }
    
    // MARK: - Initializers
    
    /// Create a `TreeNode.container` with a `Sequence` parameretized over `T`.
    public init <S: Sequence> (_ value: B, _ sequence: S) where S.Iterator.Element == L {
        self = .branch(value, sequence.map(Tree.leaf))
    }
}

extension Tree: CustomStringConvertible {
    
    /// Printed description.
    public var description: String {
        
        func indents(_ amount: Int) -> String {
            return (0 ..< amount).reduce("") { accum, _ in accum + "  " }
        }
        
        func traverse(tree: Tree, indentation: Int = 0) -> String {
            
            switch tree {
            case .leaf(let value):
                return indents(indentation) + "\(value)"
            case .branch(let value, let trees):
                return (
                    indents(indentation) + "\(value): (\n" +
                    trees
                        .map { traverse(tree: $0, indentation: indentation + 1) }
                        .joined(separator: "\n") +
                    "\n" + indents(indentation) + ")"
                )
            }
        }
        
        return traverse(tree: self)
    }
}
