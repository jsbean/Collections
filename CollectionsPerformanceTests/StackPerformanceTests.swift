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

    func testStartIndexPerformanceMillionInts() {

        let stack = randomStack(count: 1_000_000)

        measure {
            let _ = stack.startIndex
        }
    }

    func testEndIndexPerformanceMillionInts() {

        let stack = randomStack(count: 1_000_000)

        measure {
            let _ = stack.endIndex
        }
    }

    func testCountPerformanceThousandInts() {

        let stack = randomStack(count: 1_000)

        measure {
            let _ = stack.count
        }
    }

    func testCountPerformanceMillionInts() {

        let stack = randomStack(count: 1_000_000)

        measure {
            let _ = stack.count
        }
    }


}
