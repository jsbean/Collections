//
//  Matrix.swift
//  Collections
//
//  Created by James Bean on 12/10/16.
//
//

/// Matrix with user-definable dimensions, parameterized over any type `T`.
///
/// - TODO: Conform to `CustomStringConvertible`.
public struct Matrix <T> {
    
    fileprivate let amountRows: Int
    fileprivate let amountColumns: Int
    fileprivate var grid: [T] = []
    
    // MARK: - Initializers
    
    /// Create a `Matrix` with the given dimensions and given `defaultValue`.
    public init(_ amountRows: Int, _ amountColumns: Int, initial: T) {
        self.amountRows = amountRows
        self.amountColumns = amountColumns
        self.grid = Array(repeating: initial, count: Int(amountRows * amountColumns))
    }
    
    // MARK: - Subscripts
    
    /// Get and set the value for the given `row` and `column`, if these are valid indices.
    /// Otherwise, `nil` is returned or nothing is set.
    public subscript (row: Int, column: Int) -> T? {
        
        get {
            
            guard let index = index(row, column) else {
                return nil
            }
            
            return grid[index]
        }
        
        set {
            
            guard
                let index = index(row, column),
                let newValue = newValue
            else {
                return
            }
            
            grid[index] = newValue
        }
    }
    
    private func index(_ row: Int, _ column: Int) -> Int? {
        
        guard row < amountRows && column < amountColumns else {
            return nil
        }
        
        return row * column + column
    }
}

extension Matrix: Collection {
    
    // MARK: - `Collection`
    
    /// - Index after given index `i`.
    public func index(after i: Int) -> Int {
        
        guard i != endIndex else {
            fatalError("Cannot increment endIndex")
        }
        
        return i + 1
    }
    
    /// - Start index.
    public var startIndex: Int {
        return 0
    }
    
    /// - End index.
    public var endIndex: Int {
        return grid.count
    }
    
    /// - returns: Element at the given `index`.
    public subscript (index: Int) -> T {
        return grid[index]
    }
}

/// - returns: `true` if all values of both matrices are equivalent. Otherwise, `false`.
public func == <T: Equatable> (lhs: Matrix<T>, rhs: Matrix<T>) -> Bool {
    return lhs.grid == rhs.grid
}