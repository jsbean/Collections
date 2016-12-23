//
//  FlippedTest.swift
//  Collections
//
//  Created by James Bean on 12/23/16.
//
//

import XCTest
import Collections

class FlippedTest: XCTestCase {
    
    func testFlipped() {
        let a = 1
        let b = 2
        let result = flipped(a,b)
        
        XCTAssertEqual(result.0, 2)
        XCTAssertEqual(result.1, 1)
    }
}
