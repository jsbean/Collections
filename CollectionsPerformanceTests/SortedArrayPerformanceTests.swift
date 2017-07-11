//
//  SortedArrayPerformanceTests.swift
//  Collections
//
//  Created by Brian Heim on 7/10/17.
//
//

import XCTest
import Collections

class SortedArrayPerformanceTests: XCTestCase {

    // TODO: Add numbers in range
    // TODO: Add version with struct element
    // TODO: Add version reference type element
    func randomSortedArray(count: Int) -> SortedArray<Int> {
        assert(count > 0)
        return SortedArray((0..<count).map { _ in numericCast(arc4random_uniform(UInt32.max)) })
    }

    func testPerformanceExample() {
        measure {

        }
    }
}
