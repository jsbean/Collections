//
//  AdjacentPairsTests.swift
//  Collections
//
//  Created by James Bean on 12/23/16.
//
//

import XCTest
import Collections

class AdjacentPairsTests: XCTestCase {
    
    func testAdjacentPairsNil() {
        XCTAssertNil([1].adjacentPairs)
    }
    
    func testAdjacentPairs() {
        XCTAssertEqual([1,2,3,4].adjacentPairs!.count, 3)
    }
}
