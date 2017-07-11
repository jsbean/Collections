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

    func testSubscriptGetterPerformanceMillionInts() {
        let array = randomSortedArray(count: 1_000_000)
        measure { let _ = array[65_4321] }
    }

    func testSubscriptGetterPerformanceThousandTimes() {
        let array = randomSortedArray(count: 1_000_000)
        measure { stride(from: 0, to: 1_000_000, by: 999).forEach { index in _ = array[index] } }
    }

    // Expected complexity: O(log_n_)
    func testInsertSingleIntInSortedArrayWithMillionInts() {
        var array = randomSortedArray(count: 1_000_000)
        measure { array.insert(.random) }
    }

    func testInsertThousandIntsInSortedArrayWithThousandInts() {
        var array = randomSortedArray(count: 1_000)
        measure { (0..<1_000).forEach { _ in array.insert(.random) } }
    }

    func testInsertThousandIntsInSortedArrayWithMillionInts() {
        var array = randomSortedArray(count: 1_000_000)
        measure { stride(from: 0, to: 1_000_000, by: 999).forEach { value in array.insert(value) } }
    }

    func testIndexOfElementMillionInts() {
        let array = randomSortedArray(count: 1_000_000)
        measure {
            stride(from: 0, to: 1_000_000, by: 999).forEach { element in
                _ = array.index(of: element)
            }
        }
    }
}
