//
//  SortedDictionaryPerformanceTests.swift
//  Collections
//
//  Created by James Bean on 7/11/17.
//
//

import XCTest
import Collections

class SortedDictionaryPerformanceTests: XCTestCase {

    lazy var thousandRandomInts = {
        SortedDictionary((0..<1_000).map { _ in (Int.random, Int.random) })
    }()

    // Expected complexity: O(1)
    func testStartIndexPerformanceThousandInts() {
        measure { _ = self.thousandRandomInts.startIndex }
    }

    // Expected complexity: O(1)
    func testEndIndexPerformanceThousandInts() {
        measure { _ = self.thousandRandomInts.endIndex }
    }

    // Expected complexity: O(1)
    func testFirstPerformanceThousandInts() {
        measure { _ = self.thousandRandomInts.first }
    }

    // Expected complexity: O(1)
    func testLastPerformanceThousandInts() {
        measure { _ = self.thousandRandomInts.first }
    }

    // Expected complexity: O(1)
    func testCountPerformanceThousandInts() {
        measure { _ = self.thousandRandomInts.count }
    }

    func testInsertHundredInts() {
        var dict = SortedDictionary<Int,Int>()
        measure { (0..<100).forEach { _ in dict.insert(.random, key: .random) } }
    }

    // Expected complexity: O(logn)
    func testInsertThousandRandomInts() {
        var dict = SortedDictionary<Int,Int>()
        measure { (0..<1_000).forEach { _ in dict.insert(.random, key: .random) } }
    }

    func testInsertTenThousandRandomInts() {
        var dict = SortedDictionary<Int,Int>()
        measure { (0..<10_000).forEach { _ in dict.insert(.random, key: .random) } }
    }

    func testInsertTwentyThousandRandomInts() {
        var dict = SortedDictionary<Int,Int>()
        measure { (0..<20_000).forEach { _ in dict.insert(.random, key: .random) } }
    }

    func testMin() {
        measure { _ = self.thousandRandomInts.min() }
    }

    func testMax() {
        measure { _ = self.thousandRandomInts.max() }
    }

    func testCount() {
        measure { _ = self.thousandRandomInts.count }
    }

    func testValues() {
        measure { _ = self.thousandRandomInts.values[800] }
    }
}
