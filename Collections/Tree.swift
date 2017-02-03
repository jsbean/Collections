//
//  ImmutableTree.swift
//  Collections
//
//  Created by James Bean on 12/9/16.
//
//

/// Things that can go wrong when doing things to a `Tree`.
public enum TreeError: Error {
    case indexOutOfBounds
    case branchOperationPerformedOnLeaf
    case illFormedIndexPath
}

/// Value-semantic, immutable Tree structure.
public enum Tree <T> {
    
    // MARK: - Cases
    
    /// Leaf.
    case leaf(T)
    
    /// Branch.
    indirect case branch(T, [Tree])
    
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
    public func replacingTree(at index: Int, with tree: Tree) throws -> Tree {
        switch self {
        case .leaf:
            throw TreeError.branchOperationPerformedOnLeaf
        case .branch(let value, let trees):
            return .branch(value, try trees.replacingElement(at: index, with: tree))
        }
    }
    
    /// - returns: A new `Tree` with the given `tree` inserted at the given `index`, through
    /// the given `path`.
    public func inserting(_ tree: Tree, through path: [Int] = [], at index: Int)
        throws -> Tree
    {
        
        func traverse(
            _ tree: Tree,
            inserting newTree: Tree,
            through path: [Int],
            at index: Int
        ) throws -> Tree
        {

            switch tree {
            
            // We should never get to a `leaf`.
            case .leaf:
                throw TreeError.branchOperationPerformedOnLeaf
                
            // Either `traverse` further, or insert to accumulated path
            case .branch(let value, let trees):
                
                // If we have exhausted our path, attempt to insert `newTree` at `index`
                guard let (head, tail) = path.destructured else {
                    return Tree.branch(value, try insert(newTree, into: trees, at: index))
                }
                
                guard let subTree = trees[safe: head] else {
                    throw TreeError.illFormedIndexPath
                }

                let newBranch = try traverse(subTree,
                    inserting: newTree,
                    through: tail,
                    at: index
                )
                
                return try tree.replacingTree(at: index, with: newBranch)
            }
        }
        
        return try traverse(self, inserting: tree, through: path, at: index)
    }
    
    private func insert <A> (_ element: A, into elements: [A], at index: Int) throws -> [A] {
        
        guard let (left, right) = elements.split(at: index) else {
            throw TreeError.illFormedIndexPath
        }
        
        return left + [element] + right
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
