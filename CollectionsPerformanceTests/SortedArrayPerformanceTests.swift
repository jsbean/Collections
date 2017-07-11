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

    let millionSortedInts = SortedArray((0..<1_000_000).map { _ in Int.random })

    // TODO: Add numbers in range
    // TODO: Add version with struct element
    // TODO: Add version reference type element
    func randomSortedArray(count: Int) -> SortedArray<Int> {
        assert(count > 0)
        return SortedArray((0..<count).map { _ in .random })
    }

    // Expected complexity: O(1)
    func testStartIndexPerformanceMillionInts() {
        measure { _ = self.millionSortedInts.startIndex }
    }

    // Expected complexity: O(1)
    func testEndIndexPerformanceMillionInts() {
        measure { _ = self.millionSortedInts.endIndex }
    }

    // Expected complexity: O(1)
    func testCountPerformanceMillionInts() {
        measure { _ = self.millionSortedInts.count }
    }

    func testIsEmptyPerformanceMillionInts() {
        measure { _ = self.millionSortedInts.isEmpty }
    }

    // Expected complexity: O(1)
    func testSubscriptGetterPerformanceMillionInts() {
        measure { _ = self.millionSortedInts[65_4321] }
    }

    // Expected complexity: O(1)
    func testSubscriptGetterPerformanceThousandTimes() {
        var array = millionSortedInts
        measure { stride(from: 0, to: 1_000_000, by: 999).forEach { _ = array[$0] } }
    }

    // Expected complexity: O(log_n_)
    func testInsertSingleIntInSortedArrayWithMillionInts() {
        var array = millionSortedInts
        measure { array.insert(.random) }
    }

    func testInsertThousandIntsInSortedArrayWithThousandInts() {
        var array = randomSortedArray(count: 1_000)
        measure { (0..<1_000).forEach { _ in array.insert(.random) } }
    }

    func testInsertThousandIntsInSortedArrayWithMillionInts() {
        var array = millionSortedInts
        measure { (0..<1_000).forEach { _ in array.insert(.random) } }
    }

    func testIndexOfElementMillionInts() {
        let array = millionSortedInts
        measure {
            stride(from: 0, to: 1_000_000, by: 999).forEach { element in
                _ = array.index(of: element)
            }
        }
    }

    // Expected complexity: O(1)
    func testMinMillionInts() {
        let array = millionSortedInts
        measure { _ = array.min() }
    }

    // Expected complexity: O(1)
    func testMaxMillionInts() {
        let array = millionSortedInts
        measure { _ = array.max() }
    }

    // Expected complexity: O(1)
    // This should never be called, but it is part of the API surface, so in case.
    func testSortedMillionInts() {
        let array = millionSortedInts
        measure { _ = array.sorted() }
    }

    func testContainsMillionInts() {
        let array = millionSortedInts
        measure { _ = array.contains(.random) }
    }
}
