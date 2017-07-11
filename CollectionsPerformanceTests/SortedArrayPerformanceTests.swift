//
//  SortedArrayPerformanceTests.swift
//  Collections
//
//  Created by James Bean on 7/11/17.
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
        return SortedArray((0..<count).map { _ in .random })
    }

    func testStartIndexPerformanceMillionInts() {
        let array = randomSortedArray(count: 1_000_000)
        measure { let _ = array.startIndex }
    }

    func testEndIndexPerformanceMillionInts() {

        let array = randomSortedArray(count: 1_000_000)
        measure { let _ = array.endIndex }
    }

    func testCountPerformanceMillionInts() {
        let array = randomSortedArray(count: 1_000_000)
        measure { let _ = array.count }
    }
}
