//
//  StackPerformanceTests.swift
//  Collections
//
//  Created by James Bean on 7/11/17.
//
//

import XCTest
import Collections

class StackPerformanceTests: XCTestCase {

    func randomStack(count: Int) -> Stack<Int> {
        assert(count > 0)
        return Stack((0..<count).map { _ in .random })
    }

    // Expected complexity: O(1)
    func testStartIndexPerformanceMillionInts() {
        let stack = randomStack(count: 1_000_000)
        measure { let _ = stack.startIndex }
    }

    // Expected complexity: O(1)
    func testEndIndexPerformanceMillionInts() {
        let stack = randomStack(count: 1_000_000)
        measure { let _ = stack.endIndex }
    }

    // Expected complexity: O(1)
    func testCountPerformanceMillionInts() {
        let stack = randomStack(count: 1_000_000)
        measure { let _ = stack.count }
    }

    // Expected complexity: O(1)
    func testPushPerformanceMillionInts() {
        var stack = randomStack(count: 1_000_000)
        measure { stack.push(.random) }
    }

    // Expected complexity: O(1)
    func testPopPerformanceMillionInts() {
        var stack = randomStack(count: 1_000_000)
        measure { _ = stack.pop() }
    }

    // Expected complexity: O(1)
    func testSubscriptGetterPerformanceMillionInts() {
        let stack = randomStack(count: 1_000_000)
        measure { let _ = stack[12_345] }
    }
}
