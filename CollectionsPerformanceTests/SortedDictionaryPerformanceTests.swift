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

    func randomSortedDictionary(count: Int) -> SortedDictionary<Int,Int> {
        assert(count > 0)
        return SortedDictionary((0..<count).map { _ in (.random, .random) })
    }

    // Expected complexity: O(1)
    func testStartIndexPerformanceMillionInts() {
        let dict = randomSortedDictionary(count: 1_000_000)
        measure { let _ = dict.startIndex }
    }

    // Expected complexity: O(1)
    func testEndIndexPerformanceMillionInts() {
        let dict = randomSortedDictionary(count: 1_000_000)
        measure { let _ = dict.endIndex }
    }

    // TODO: count O(1)
    // TODO: subscript O(1)
    // TODO: insert O(logn)
    // TODO: insert contents O(logn)
    // TODO: value(at:) O(1)
    // TODO: min() O(logn)
    // TODO: max() O(logn)
}
