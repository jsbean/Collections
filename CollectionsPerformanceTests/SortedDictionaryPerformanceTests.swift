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

    let thousandRandomInts = SortedDictionary((0..<1_000).map { _ in (Int.random, Int.random) })
//
//    func randomSortedDictionary(count: Int) -> SortedDictionary<Int,Int> {
//        assert(count > 0)
//        return SortedDictionary((0..<count).map { _ in (.random, .random) })
//    }
//
    // Expected complexity: O(1)
    func testStartIndexPerformanceThousandInts() {
        measure { _ = self.thousandRandomInts.startIndex }
    }

    // Expected complexity: O(1)
    func testEndIndexPerformanceThousandInts() {
        measure { _ = self.thousandRandomInts.endIndex }
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

//    func testInsertHundredThousandRandomInts() {
//        var dict = SortedDictionary<Int,Int>()
//        measure { (0..<40_000).forEach { i in dict.insert(i, key: i) } }
//    }

    // TODO: count O(1)
    // TODO: subscript O(1)
    // TODO: insert O(logn)
    // TODO: insert contents O(logn)
    // TODO: value(at:) O(1)
    // TODO: min() O(logn)
    // TODO: max() O(logn)
}
