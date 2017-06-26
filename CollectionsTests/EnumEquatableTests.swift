//
//  EnumEquatableTests.swift
//  Collections
//
//  Created by James Bean on 1/8/17.
//
//

import XCTest
import Collections

class EnumEquatableTests: XCTestCase {

    enum E: Int {
        case a, b, c
    }

    func testEqual() {
        XCTAssert(E.a == E.a)
    }

    func testNotEqual() {
        XCTAssertFalse(E.a == E.b)
    }
}
