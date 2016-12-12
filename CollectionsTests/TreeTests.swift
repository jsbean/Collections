//
//  TreeTests.swift
//  Collections
//
//  Created by James Bean on 12/9/16.
//
//

import XCTest
import Collections

class TreeTests: XCTestCase {
    
    func testLeafInit() {
        let _ = Tree.node(1, [])
    }

    func testInitWithSequence() {
        
        let seq = [1,2,3,4,5]
        let container = Tree(0, seq)
        
        switch container {
        case .empty: XCTFail()
        case .node(let element, let children):
            XCTAssertEqual(element, 0)
            XCTAssertEqual(children.count, 5)
        }
    }
    
    func testLeavesLeaf() {
        let leaf: Tree = .node(1, [])
        XCTAssertEqual(leaf.leaves, [1])
    }
    
    
    func testLeavesContainerSingleChild() {
        let container: Tree = .node(0, [.node(1, [])])
        XCTAssertEqual(container.leaves, [1])
    }
    
    
    func testLeavesContainerMultipleChildren() {
        let container: Tree = .node(0, [.node(1, []), .node(2, []), .node(3, [])])
        XCTAssertEqual(container.leaves, [1,2,3])
    }

    func testLeavesMultipleDepth() {
        
        let container: Tree = .node(0, [
            .node(1, []),
            .node(0, [
                .node(2, []),
                .node(3, []),
                .node(4, [])
            ]),
            .node(5, []),
            .node(0, [
                .node(6, []),
                .node(0, [
                    .node(7, []),
                    .node(8, [])
                ])
            ])
        ])
        
        XCTAssertEqual(container.leaves, [1,2,3,4,5,6,7,8])
    }
}
