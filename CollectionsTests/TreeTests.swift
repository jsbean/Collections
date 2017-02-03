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
    
    private var tree: Tree<Int> {
        return Tree.branch(0, [
            .leaf(1),
            .leaf(2),
            .leaf(3)
        ])
    }
    
    func testLeafInit() {
        let _ = Tree<Int>.leaf(1)
    }
    
    func testInitWithSequence() {
        
        let seq = [1,2,3,4,5]
        let branch = Tree(0, seq)
        
        guard case .branch = branch else {
            XCTFail()
            return
        }
    }
    
    func testLeavesLeaf() {
        let leaf: Tree<Int> = .leaf(1)
        XCTAssertEqual(leaf.leaves, [1])
    }
    
    func testLeavesBranchSingleChild() {
        let container: Tree = .branch(0, [.leaf(1)])
        XCTAssertEqual(container.leaves, [1])
    }
    
    func testLeavesBranchMultipleTrees() {
        let container = Tree.branch(0, [.leaf(1), .leaf(2), .leaf(3)])
        XCTAssertEqual(container.leaves, [1,2,3])
    }
    
    func testLeavesMultipleDepth() {
        
        let container = Tree.branch(0, [
            .leaf(1),
            .branch(0, [
                .leaf(2),
                .leaf(3),
                .leaf(4)
            ]),
            .leaf(5),
            .branch(0, [
                .leaf(6),
                .branch(0, [
                    .leaf(7),
                    .leaf(8)
                ])
            ])
        ])
        
        XCTAssertEqual(container.leaves, [1,2,3,4,5,6,7,8])
    }
    
    func testReplacingLeafAtBegining() {
        
        let newTree = try! tree.replacingTree(at: 0, with: .leaf(0))
        XCTAssertEqual(newTree.leaves, [0,2,3])
    }
    
    func testReplacingLeafInMiddle() {
        
        let newTree = try! tree.replacingTree(at: 1, with: .leaf(0))
        XCTAssertEqual(newTree.leaves, [1,0,3])
    }
    
    func testReplacingLeafAtEnd() {
        
        let newTree = try! tree.replacingTree(at: 2, with: .leaf(0))
        XCTAssertEqual(newTree.leaves, [1,2,0])
    }
    
    func testInsertLeafAtBeginningSingleDepth() {
        
        let leafToInsert = Tree.leaf(0)
        let newTree = try! tree.inserting(leafToInsert, at: 0)
        XCTAssertEqual(newTree.leaves, [0,1,2,3])
    }
    
    func testInsertBranchAtBeginningSingleDepth() {
        
        let treeToInsert = Tree.branch(0, [
            .leaf(-1),
            .leaf(0)
        ])
        
        let newTree = try! tree.inserting(treeToInsert, at: 0)
        XCTAssertEqual(newTree.leaves, [-1,0,1,2,3])
    }
    
    func testInsertBranchInMiddleSingleDepth() {
        
        let treeToInsert = Tree.branch(0, [
            .leaf(0),
            .leaf(0)
        ])
        
        let newTree = try! tree.inserting(treeToInsert, at: 1)
        XCTAssertEqual(newTree.leaves, [1,0,0,2,3])
    }
    
    func testInsertBranchAtEndSingleDepth() {
        
        let treeToInsert = Tree.branch(0, [
            .leaf(4),
            .leaf(5)
        ])
        
        let newTree = try! tree.inserting(treeToInsert, at: 3)
        XCTAssertEqual(newTree.leaves, [1,2,3,4,5])
    }
    
    func testInsertLeafNested() {
        
        //         -1
        //        / | \
        //      -1 -1  4
        //         /|\
        //        1 2(3) insert
        let tree = Tree.branch(-1, [
            .leaf(0),
            .branch(-1, [
                .leaf(1),
                .leaf(2)
            ])
        ])
        
        let newTree = try! tree.inserting(.leaf(3), through: [], at: 2)
        XCTAssertEqual(newTree.leaves, [0,1,2,3])
    }
    
    func testInsertLeafNestedLessNested() {
        
        //         -1
        //        / | \
        //      -1 -1  4
        //         /|\
        //        1 2(3) insert
        let tree = Tree.branch(-1, [
            .leaf(0),
            .branch(-1, [
                .leaf(1),
                .leaf(2)
            ]),
            .leaf(3)
        ])
        
        let newTree = try! tree.inserting(.leaf(4), through: [], at: 3)
        XCTAssertEqual(newTree.leaves, [0,1,2,3,4])
    }
    
    func testInsertBranchReallyNested() {
        
        let tree = Tree.branch(-1, [
            .branch(-1, [
                .leaf(0),
                .leaf(1)
            ]),
            .branch(-1, [
                .leaf(2),
                .branch(-1, [
                    .leaf(3),
                    .branch(-1, [
                        .leaf(4),
                        
                        // insert branch here!
                        
                        .leaf(10)
                    ]),
                    .leaf(11)
                ]),
                .leaf(12)
            ])
        ])
        
        let branchToInsert = Tree.branch(-1, [
            .leaf(5),
            .leaf(6),
            .branch(-1, [
                .leaf(7),
                .leaf(8),
                .leaf(9)
            ])
        ])
        
        let newTree = try! tree.inserting(branchToInsert, through: [1,1,1], at: 1)
        XCTAssertEqual(newTree.leaves, [0,1,2,3,4,5,6,7,8,9,10,11,12])
    }
}
