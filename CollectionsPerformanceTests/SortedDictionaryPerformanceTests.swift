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

    
}
