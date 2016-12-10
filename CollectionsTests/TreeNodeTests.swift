//
//  TreeNodeTests.swift
//  Collections
//
//  Created by James Bean on 12/9/16.
//
//

import XCTest
import Collections

class TreeNodeTests: XCTestCase {
    
    func testLeafInit() {
        let _ = TreeNode.leaf(1)
    }
    
    func testInitWithSequence() {
        
        let seq = [1,2,3,4,5]
        let container = TreeNode(seq)
        
        guard case .container = container else {
            XCTFail()
            return
        }
    }
    
    func testLeavesLeaf() {
        let leaf: TreeNode = .leaf(1)
        XCTAssertEqual(leaf.leaves, [1])
    }
    
    func testLeavesContainerSingleChild() {
        let container: TreeNode = .container([.leaf(1)])
        XCTAssertEqual(container.leaves, [1])
    }
    
    func testLeavesContainerMultipleChildren() {
        let container = TreeNode.container([.leaf(1), .leaf(2), .leaf(3)])
        XCTAssertEqual(container.leaves, [1,2,3])
    }
    
    func testLeavesMultipleDepth() {
        
        let container = TreeNode.container([
            .leaf(1),
            .container([
                .leaf(2),
                .leaf(3),
                .leaf(4)
            ]),
            .leaf(5),
            .container([
                .leaf(6),
                .container([
                    .leaf(7),
                    .leaf(8)
                ])
            ])
        ])
        
        XCTAssertEqual(container.leaves, [1,2,3,4,5,6,7,8])
    }
}
