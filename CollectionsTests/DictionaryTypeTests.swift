//
//  DictionaryTypeTests.swift
//  Collections
//
//  Created by James Bean on 12/23/16.
//
//

import XCTest
import Collections

class DictionaryTypeTests: XCTestCase {
    
    func testSafelyAppendToExisting() {
        
        var dict = [0: [0,1,2]]
        dict.safelyAppend(3, toArrayWith: 0)
        
        XCTAssertEqual(dict[0]!, [0,1,2,3])
    }
    
    func testSafelyAppendToNotYetExisting() {
        
        var dict = [0: [0,1,2]]
        dict.safelyAppend(0, toArrayWith: 1)
        
        XCTAssertEqual(dict[1]!, [0])
    }
    
    func testSafelyAppendContentsToExisting() {
        
        var dict = [0: [0,1,2]]
        dict.safelyAppendContents(of: [3,4,5], toArrayWith: 0)
        
        XCTAssertEqual(dict[0]!, [0,1,2,3,4,5])
    }
    
    func testSafelyAppendContentsToNotYetExtant() {
        
        var dict = [0: [0,1,2]]
        dict.safelyAppendContents(of: [0,1,2], toArrayWith: 1)
        
        XCTAssertEqual(dict[1]!, [0,1,2])
    }
    
    func testSafelyAndUniquelyAppendValuePreexisting() {
        
        var dict = [0: [0,1,2]]
        dict.safelyAndUniquelyAppend(1, toArrayWith: 1)
        
        XCTAssertEqual(dict[0]!, [0,1,2])
    }
    
    func testSafelyAndUniquelyAppendValueNotExtant() {
        
        var dict = [0: [0,1,2]]
        dict.safelyAndUniquelyAppend(3, toArrayWith: 0)
        
        XCTAssertEqual(dict[0]!, [0,1,2,3])
    }
    
    func testEnsureArrayTypeValueForKeyPreexisting() {
        
        var dict = [0: [0], 1: [1], 2: [2]]
        dict.ensureValue(for: 0)
        
        XCTAssertEqual(dict[1]!, [1])
    }
    
    func testEnsureArrayTypeValueForKeyNotYetExtant() {
        
        var dict = [0: [0], 1: [1], 2: [2]]
        dict.ensureValue(for: 3)
        
        XCTAssertEqual(dict[3]!, [])
    }
    
    func testEnsureDictionaryTypeValuePreexisting() {
        
        var dict = [0: [0: 0]]
        dict.ensureValue(for: 0)
        
        XCTAssertNotNil(dict[0])
    }
    
    func testEnsureDictionaryTypeValueNotYetExtant() {
        
        var dict = [0: [0: 0]]
        dict.ensureValue(for: 1)
        
        XCTAssertNotNil(dict[1])
    }
    
    func testUpdateValueForKeyPathThrowsAllIllFormed() {
        
        var dict = ["parent": ["child": 0]]
        XCTAssertThrowsError(try dict.update(1, keyPath: [1,2]))
    }
    
    func testUpdateValueForKeyPathThrowsRootIllFormed() {
        
        var dict = ["parent": ["child": 0]]
        XCTAssertThrowsError(try dict.update(1, keyPath: ["parent", 0]))
    }
    
    func testUpdateValueForKeyPathThrowsNestedIllFormed() {
        
        var dict = ["parent": ["child": 0]]
        XCTAssertThrowsError(try dict.update(1, keyPath: [1, "child"]))
    }
    
    func testUpdateValueForKeyPathStringKeys() {
        
        var dict = ["parent": ["child": 0]]
        try! dict.update(1, keyPath: "parent.child")
        
        XCTAssertEqual(dict["parent"]!["child"], 1)
    }
    
    func testUpdateValueForKeyPathHeterogeneousKeys() {
        
        var dict = ["0": [1: 2.0]]
        try! dict.update(2.1, keyPath: ["0", 1])
        
        XCTAssertEqual(dict["0"]![1], 2.1)
    }
    
    func testMergeNewDictOvercomesOriginal() {
        
        var a = ["1": 1, "2": 2, "3": 3]
        let b = ["1": 0 ,"2": 1, "3": 2]
        a.merge(with: b)

        XCTAssertEqual(a,b)
    }
    
    func testMergedNewDictOvercomesOriginal() {
        
        let a = ["1": 1, "2": 2, "3": 3]
        let b = ["1": 0 ,"2": 1, "3": 2]
        let result = a.merged(with: b)
        let expected = b
        
        XCTAssertEqual(result, expected)
    }
    
    func testDictionaryInitWithArrays() {
        
        let xs = [0,1,2,3,4]
        let ys = ["a","b","c","d","e"]
        
        let dict = Dictionary(xs,ys)
        
        XCTAssertEqual(dict[0], "a")
        XCTAssertEqual(dict[4], "e")
    }
    
    func testSortedDictionaryInitWithArraysSorted() {
        
        let xs = [0,3,4,1,2]
        let ys = ["a","d","e","b","c"]
        
        let dict = SortedDictionary(xs,ys)
        
        XCTAssertEqual(dict[0], "a")
        XCTAssertEqual(dict[4], "e")
    }
    
    func testEqualitySimple() {
        
        let stringByInt = [1: "one", 2: "two", 3: "three"]
        XCTAssert(stringByInt == [1: "one", 2: "two", 3: "three"])
    }
}
