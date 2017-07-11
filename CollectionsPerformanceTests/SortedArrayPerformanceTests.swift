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

    // Expected complexity: O(1)
    func testStartIndexPerformanceMillionInts() {
        let array = randomSortedArray(count: 1_000_000)
        measure { let _ = array.startIndex }
    }

    // Expected complexity: O(1)
    func testEndIndexPerformanceMillionInts() {
        let array = randomSortedArray(count: 1_000_000)
        measure { let _ = array.endIndex }
    }

    // Expected complexity: O(1)
    func testCountPerformanceMillionInts() {
        let array = randomSortedArray(count: 1_000_000)
        measure { let _ = array.count }
    }

    // Expected complexity: O(1)
    func testSubscriptGetterPerformanceMillionInts() {
        let array = randomSortedArray(count: 1_000_000)
        measure { let _ = array[65_4321] }
    }

    // Expected complexity: O(1)
    func testSubscriptGetterPerformanceThousandTimes() {
        let array = randomSortedArray(count: 1_000_000)
        measure { stride(from: 0, to: 1_000_000, by: 999).forEach { _ = array[$0] } }
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
        measure { (0..<1_000).forEach { _ in array.insert(.random) } }
    }

    func testIndexOfElementMillionInts() {
        let array = randomSortedArray(count: 1_000_000)
        measure {
            stride(from: 0, to: 1_000_000, by: 999).forEach { element in
                _ = array.index(of: element)
            }
        }
    }

    // Expected complexity: O(1)
    func testMinMillionInts() {
        let array = randomSortedArray(count: 1_000_000)
        measure { _ = array.min() }
    }

    // Expected complexity: O(1)
    func testMaxMillionInts() {
        let array = randomSortedArray(count: 1_000_000)
        measure { _ = array.max() }
    }

    // Expected complexity: O(1)
    // This should never be called, but it is part of the API surface, so in case.
    func testSortedMillionInts() {
        let array = randomSortedArray(count: 1_000_000)
        measure { _ = array.sorted() }
    }

    func testContainsMillionInts() {
        let array = randomSortedArray(count: 1_000_000)
        measure { _ = array.contains(.random) }
    }
}
