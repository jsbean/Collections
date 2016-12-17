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
    
    func testEmpty() {
        let _ = TreeNode<Int>.empty
    }
    
    func testLeaf() {
        let _ = TreeNode.node(0, [])
    }
    
    /*
    func testLeafInit() {
        let _ = TreeNode.node(1, [])
    }
    */
    
    
    func testInitWithSequence() {
        
        let seq = [1,2,3,4,5]
        let root = TreeNode(0, seq)
 
        guard case .node = root else {
            XCTFail()
            return
        }
    }
    
    
    func testLeavesLeaf() {
        let leaf = TreeNode(0, [1])
        XCTAssertEqual(leaf.leaves, [1])
    }
    
    func testLeavesContainerSingleChild() {
        let root = TreeNode.node(0, [.node(1, [])])
        XCTAssertEqual(root.leaves, [1])
    }
    
    func testLeavesContainerMultipleChildren() {
        let root = TreeNode(0, [1,2,3])
        XCTAssertEqual(root.leaves, [1,2,3])
    }
    
    
    func testLeavesMultipleDepth() {
        
        let root = TreeNode.node(0,
            [
                .node(1, []),
                .node(0, [
                    .node(2, []),
                    .node(3, []),
                    .node(4, [])
                ]),
                .node(5, []),
                .node(0, [
                    .node(6, []),
                    .node(7, []),
                    .node(8, [])
                ])
            ]
        )
        
        XCTAssertEqual(root.leaves, [1,2,3,4,5,6,7,8])
    }
}
