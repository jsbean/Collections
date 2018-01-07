//
//  ComparableExtensionsTests.swift
//  Collections
//
//  Created by Brian Heim on 1/6/18.
//

import XCTest
import Collections

class ComparableExtensionsTests: XCTestCase {

    func testClampedBelow() {
        XCTAssertEqual(3.clamped(in: 4...8), 4)
    }

    func testClampedAbove() {
        XCTAssertEqual(3.clamped(in: 0...2), 2)
    }

    func testClampedInside() {
        XCTAssertEqual(3.clamped(in: 1...5), 3)
    }
    
}
