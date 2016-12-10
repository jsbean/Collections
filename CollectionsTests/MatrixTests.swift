//
//  MatrixTests.swift
//  Collections
//
//  Created by James Bean on 12/10/16.
//
//

import XCTest
import Collections

class MatrixTests: XCTestCase {
    
    func testInit() {
        
        let amountRows = 2
        let amountColumns = 3
        var matrix = Matrix(amountRows, amountColumns, initial: 0)
        
        for row in 0 ..< amountRows {
            for column in 0 ..< amountColumns {
                XCTAssertEqual(matrix[row, column], 0)
            }
        }
    }
    
    func testSubscript() {
        var matrix = Matrix(2, 3, initial: 0)
        matrix[1, 2] = 1
        XCTAssertEqual(matrix[1, 2], 1)
    }
    
    func testSequence() {
        let matrix = Matrix(3, 3, initial: 0)
        XCTAssertEqual(matrix.map { $0 }.count, 9)
    }
    
    func testEquivalenceTrue() {
        var matrix1 = Matrix(2, 3, initial: 0)
        var matrix2 = Matrix(2, 3, initial: 0)
        matrix1[1, 2] = 1
        matrix2[1, 2] = 1
        XCTAssert(matrix1 == matrix2)
    }
    
    func testEquivalenceFalse() {
        var matrix1 = Matrix(2, 3, initial: 0)
        var matrix2 = Matrix(2, 3, initial: 0)
        matrix1[1, 2] = 1
        matrix2[1, 2] = 0
        XCTAssertFalse(matrix1 == matrix2)
    }
    
    func testSubscriptSetOutOfBounds() {
        var matrix = Matrix(2, 2, initial: 0)
        matrix[2,2] = 1
    }
    
    func testSubscriptGetOutOfBounds() {
        var matrix = Matrix(2, 2, initial: 0)
        XCTAssertNil(matrix[2,2])
    }
}
