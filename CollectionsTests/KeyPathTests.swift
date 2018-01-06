//
//  KeyPathTests.swift
//  Collections
//
//  Created by James Bean on 12/23/16.
//
//

import XCTest
import Collections

class KeyPathTests: XCTestCase {

    func testInitArray() {
        let keyPath = Collections.KeyPath(["1", "2", "ok"])
        XCTAssertEqual(keyPath.count, 3)
    }

    func testInitArrayLiteral() {
        let keyPath: Collections.KeyPath = ["1", "2", "ok"]
        XCTAssertEqual(keyPath.count, 3)
    }

    func testInitStringLiteral() {
        let keyPath: Collections.KeyPath = "a.b.2.ok.g"
        XCTAssertEqual(keyPath.count, 5)
    }

    func testInitHeterogeneousType() {
        let keyPath = KeyPath(["a", 1])
        XCTAssertEqual(keyPath[0] as! String, "a")
        XCTAssertEqual(keyPath[1] as! Int, 1)
    }
}
