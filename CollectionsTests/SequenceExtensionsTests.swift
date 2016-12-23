//
//  SequenceExtensionsTests.swift
//  Collections
//
//  Created by James Bean on 12/23/16.
//
//

import XCTest
import Collections

struct S {
    let value: Int
}

extension S: Equatable { }

func == (lhs: S, rhs: S) -> Bool {
    return lhs.value == rhs.value
}

class SequenceExtensionsTests: XCTestCase {
    
    let structs = [S(value: 1), S(value: 3), S(value: 2), S(value: 3)]
    
    func testAllSatisfyTrue() {
        let array = [1,1,1,1,1,1,1,1]
        XCTAssertTrue(array.allSatisfy { $0 == 1 })
    }
    
    func testAllSatisfyFalse() {
        let array = [1,2,3,4,5,6,7,8,9]
        XCTAssertFalse(array.allSatisfy { $0 == 1})
    }
    
    func testAnySatisfyTrue() {
        let array = [3,1,2,6]
        XCTAssertTrue(array.anySatisfy { $0 == 2 })
    }
    
    func testAnySatisfyFalse() {
        let array = [1,2,3,4,5,6,7,8,9]
        XCTAssertFalse(array.anySatisfy { $0 == 10 })
    }
    
    func testExtremeElementsGreatest() {
        let greatest = structs.extremeElements(>) { $0.value }
        XCTAssertEqual(greatest, [S(value: 3), S(value: 3)])
    }
    
    func testExtremeElementsLeast() {
        let least = structs.extremeElements(<) { $0.value }
        XCTAssertEqual(least, [S(value: 1)])
    }
    
    func testGreatest() {
        let greatest = structs.greatest { $0.value }
        XCTAssertEqual(greatest, 3)
    }
    
    func testLeast() {
        let least = structs.least { $0.value }
        XCTAssertEqual(least, 1)
    }
    
    func testExtremityEmptyNil() {
        let array: [S] = []
        XCTAssertNil(array.extremity(>) { $0.value })
    }
    
    func testExtremeElementsNil() {
        let array: [S] = []
        XCTAssertEqual(array.extremeElements(<) { $0.value }, [])
    }
    
    func testIsHomogenousEmptyTrue() {
        XCTAssert(Array<Int>().isHomogeneous)
    }
    
    func testIsHomogenousSingleElementTrue() {
        XCTAssert([1].isHomogeneous)
    }
    
    func testIsHomoegeneous() {
        XCTAssert([1,1,1,1,1].isHomogeneous)
    }
    
    func testIsHomogeneousFail() {
        XCTAssertFalse([1,2,1,1].isHomogeneous)
    }
    
    func testIsHeterogeneousFalse() {
        XCTAssertFalse([1,1,1,1,1].isHeterogeneous)
    }
    
    /*
    func testAmountOfElementNotPresentZero() {
        let array = [1,2,3,4]
        XCTAssertEqual(array.amount(of: 0), 0)
    }
    
    func testAmountOfElementPresent() {
        let array = [1,2,3,4,1]
        XCTAssertEqual(array.amount(of: 1), 2)
    }
    
    func testExtractAllNotPresent() {
        
        let array = [1,2,3,4]
        let (expectedExtracted, expectedRemaining): ([Int],[Int]) = ([], [1,2,3,4])
        let (resultExtracted, resultRemaining) = array.extractAll(0)
        
        XCTAssertEqual(expectedExtracted, resultExtracted)
        XCTAssertEqual(expectedRemaining, resultRemaining)
    }
    
    func testExtractAllPresent() {
        
        let array = [1,2,3,4,1]
        let (expectedExtracted, expectedRemaining): ([Int],[Int]) = ([1,1], [2,3,4])
        let (resultExtracted, resultRemaining) = array.extractAll(1)
        
        XCTAssertEqual(expectedExtracted, resultExtracted)
        XCTAssertEqual(expectedRemaining, resultRemaining)
    }
    
    func testSortedWithOrderOfContentsSourceEmpty() {
        
        let source: [Int] = []
        let reference = [1,2,3]
        
        XCTAssertEqual(source.sorted(withOrderOfContentsIn: reference), [])
    }
    
    func testSortedWithOrderOfContentsReferenceEmpty() {
        
        let source = [1,2,3]
        let reference: [Int] = []
        
        XCTAssertEqual(source.sorted(withOrderOfContentsIn: reference), [1,2,3])
    }
    
    func testSortedWithOrderedOfContentsAllPresent() {
        
        let source = [1,2,3]
        let reference: [Int] = [2,3,1]
        
        XCTAssertEqual(source.sorted(withOrderOfContentsIn: reference), [2,3,1])
    }
    
    func testExtractDuplicatesNone() {
        
        let array = [1,2,3]
        let (duplicates, remaining) = array.extractDuplicates()
        
        XCTAssertEqual(duplicates, [])
        XCTAssertEqual(remaining, array)
    }
    
    func testExtractDuplicatesSome() {
        
        let array = [1,2,2,3,1]
        let (duplicates, remaining) = array.extractDuplicates()
        
        XCTAssertEqual(duplicates, [2,1])
        XCTAssertEqual(remaining, [1,2,3])
    }
    
    func testUnique() {
        let array = [1,2,2,3,1]
        XCTAssertEqual(array.unique, [1,2,3])
    }
    
    func testReplaceElementNotYetExtant() {
        
        var array: [Int] = [1,2,3,4]
        
        do {
            try array.replace(0, with: 5)
        } catch ArrayError.removalError {
            // success
        } catch _ {
            XCTFail()
        }
    }
    
    func testReplaceElementExtant() {
        
        var array: [Int] = [1,2,5,4]
        
        do {
            try array.replace(5, with: 3)
            XCTAssertEqual(array, [1,2,3,4])
        } catch {
            XCTFail()
        }
    }
    */
}
