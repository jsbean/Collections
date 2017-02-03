//
//  ImmutableTree.swift
//  Collections
//
//  Created by James Bean on 12/9/16.
//
//

public enum TreeError: Error {
    case indexOutOfBounds
    case branchOperationPerformedOnLeaf
    case illFormedIndexPath
}

/// Value-semantic, immutable Tree structure.
public enum Tree <T> {
    
    // MARK: - Cases
    
    /// Container node.
    indirect case branch(T, [Tree])
    
    /// Leaf node.
    case leaf(T)
    
    // MARK: - Instance Properties
    
    /// The payload of a given `Tree`.
    public var value: T {
        switch self {
        case .leaf(let value):
            return value
        case .branch(let value, _):
            return value
        }
    }
    
    /// Leaves of this `TreeNode`.
    public var leaves: [T] {
        
        func flattened(accum: [T], tree: Tree) -> [T] {
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
    public init <S: Sequence> (_ value: T, _ sequence: S) where S.Iterator.Element == T {
        self = .branch(value, sequence.map(Tree.leaf))
    }
    
    /// Replace the subtree at the given `index` for the given `tree`.
    ///
    /// - throws: `TreeError` if `self` is a `leaf`.
    public func replacing(_ tree: Tree, forTreeAt index: Int) throws -> Tree {
        switch self {
        case .leaf:
            throw TreeError.branchOperationPerformedOnLeaf
        case .branch(let value, let trees):
            return .branch(value, try trees.replacingElement(at: index, with: tree))
        }
    }
    
    // take in path: [Int], and index: Int
    // as two separate things
    
    public func inserting(_ tree: Tree, through path: [Int] = [], at index: Int)
        throws -> Tree
    {
        
        func traverse(
            _ tree: Tree,
            toInsert newTree: Tree,
            path: [Int],
            index: Int
        ) throws -> Tree
        {

            switch tree {
            
            // We should never get to a `leaf`.
            case .leaf:
                throw TreeError.branchOperationPerformedOnLeaf
                
            // Either `traverse` further, or insert to accumulated path
            case .branch(let value, let trees):
                
                guard let (head, tail) = path.destructured else {
                    return Tree.branch(value, try insert(newTree, into: trees, at: index))
                }
                
                return try tree.replacing(
                    try traverse(trees[head], toInsert: newTree, path: tail, index: index),
                    forTreeAt: index
                )
            }
        }
        
        return try traverse(self, toInsert: tree, path: path, index: index)
    }
    
    private func insert(_ tree: Tree, into trees: [Tree], at index: Int) throws -> [Tree] {
        
        guard let (left, right) = trees.split(at: index) else {
            throw TreeError.illFormedIndexPath
        }
        
        return left + [tree] + right
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
                    indents(indentation) + "\(value)\n" +
                    trees
                        .map { traverse(tree: $0, indentation: indentation + 1) }
                        .joined(separator: "\n")
                )
            }
        }
        
        return traverse(tree: self)
    }
}
