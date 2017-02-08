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
    
    /// Leaves of this `Tree`.
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
    
    /// All of the values along the paths from this node to each leaf
    public var paths: [[T]] {

        func traverse(_ tree: Tree, accum: [[T]]) -> [[T]] {
            
            var accum = accum
            let path = accum.popLast() ?? []
            
            switch tree {
            case .leaf(let value):
                return accum + (path + value)

            case .branch(let value, let trees):
                return trees.flatMap { traverse($0, accum: accum + (path + value)) }
            }
        }
        
        return traverse(self, accum: [])
    }
    
    /// Height of a `Tree`.
    public var height: Int {
        
        func traverse(_ tree: Tree, height: Int) -> Int {
            
            switch tree {
            case .leaf:
                return height
            case .branch(_, let trees):
                return trees.map { traverse($0, height: height + 1) }.max()!
            }
        }
        
        return traverse(self, height: 0)
    }
    
    // MARK: - Initializers
    
    /// Create a `TreeNode.branch` with a `Sequence` parameretized over `T`.
    public init <S: Sequence> (_ value: T, _ sequence: S) where S.Iterator.Element == T {
        self = .branch(value, sequence.map(Tree.leaf))
    }
    
    /// Apply a given `transform` to all nodes in a `Tree`.
    public func map <U> (_ transform: (T) -> U) -> Tree<U> {
        
        switch self {
        case .leaf(let value):
            return .leaf(transform(value))
        case .branch(let value, let trees):
            return .branch(transform(value), trees.map { $0.map(transform) })
        }
    }
    
    /// - returns: A new `Tree` with the given `value` as payload.
    public func updating(value: T) -> Tree {
        
        switch self {
        case .leaf:
            return .leaf(value)
        case .branch(_, let trees):
            return .branch(value, trees)
        }
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
    
    /// Replace the subtree at the given `path`.
    ///
    /// - throws: `TreeError` if the given `path` is valid.
    public func replacingTree(through path: [Int], with tree: Tree) throws -> Tree {
        
        func traverse(_ tree: Tree, inserting newTree: Tree, path: [Int]) throws -> Tree {
            
            switch tree {
                
            // This should never be called on a leaf
            case .leaf:
                throw TreeError.branchOperationPerformedOnLeaf
                
            // Either `traverse` futher, or replace at last index specified in `path`.
            case .branch(let value, let trees):
                
                // Ensure that the `indexPath` given is valid
                guard
                    let (index, remainingPath) = path.destructured,
                    let subTree = trees[safe: index]
                else {
                    throw TreeError.illFormedIndexPath
                }
                
                // We are done if only one `index` remaining in `indexPath`
                guard path.count > 1 else {
                    return .branch(value, try trees.replacingElement(at: index, with: newTree))
                }

                // Otherwise, keep recursing down
                return try tree.replacingTree(
                    at: index,
                    with: try traverse(subTree, inserting: newTree, path: remainingPath)
                )
            }
        }
        
        return try traverse(self, inserting: tree, path: path)
    }
    
    /// - returns: A new `Tree` with the given `tree` inserted at the given `index`, through
    /// the given `path`.
    ///
    /// - throws: `TreeError` in the case of ill-formed index paths and indexes out-of-range.
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

/// - returns: A new `Tree` resulting from applying the given function `f` to each
/// corresponding node in the given trees `a` and `b`.
///
/// - invariant: `a` and `b` are the same shape.
public func zip <T,U,V> (_ a: Tree<T>, _ b: Tree<U>, _ f: (T, U) -> V) -> Tree<V> {
    
    switch (a,b) {
    case (.leaf(let a), .leaf(let b)):
        return .leaf(f(a,b))
    case (.branch(let a, let aTrees), .branch(let b, let bTrees)):
        return .branch(f(a,b), zip(aTrees, bTrees).map { a,b in zip(a,b,f) })
    default:
        fatalError("Incompatible trees")
    }
}

/// - TODO: Make extension, retroactively conforming to `Equatable` when Swift allows it

/// - returns: `true` if two `Tree` values are equivalent. Otherwise, `false`.
public func == <T: Equatable> (lhs: Tree<T>, rhs: Tree<T>) -> Bool {
    
    switch (lhs, rhs) {
    case (.leaf(let a), .leaf(let b)):
        return a == b
    case (.branch(let valueA, let treesA), .branch(let valueB, let treesB)):
        return valueA == valueB && treesA == treesB
    default:
        return false
    }
}

/// - returns: `true` if two `Tree` values are not equivalent. Otherwise, `false`.
public func != <T: Equatable> (lhs: Tree<T>, rhs: Tree<T>) -> Bool {
    return !(lhs == rhs)
}

/// - returns: `true` if two arrays of `Tree` values are equivalent. Otherwise, `false.`
public func == <T: Equatable> (lhs: [Tree<T>], rhs: [Tree<T>]) -> Bool {
    
    guard lhs.count == rhs.count else {
        return false
    }
    
    for (lhs, rhs) in zip(lhs, rhs) {
        if lhs != rhs {
            return false
        }
    }
    
    return true
}
