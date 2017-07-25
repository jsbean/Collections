//
//  EnumIterationTests.swift
//  Collections
//
//  Created by James Bean on 12/23/16.
//
//

import XCTest
import Collections

class EnumIterationTests: XCTestCase {

    func testCases() {

        enum TestEnum: String {
            case A, B, C, D, E, F, G
        }

        let expected: [TestEnum] = [.A, .B, .C, .D, .E, .F, .G]

        XCTAssertEqual(TestEnum.cases, expected)
    }
}
