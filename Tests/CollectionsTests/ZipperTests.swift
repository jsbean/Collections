//
//  ZipperTests.swift
//  Collections
//
//  Created by James Bean on 2/5/17.
//
//

import XCTest
import Collections

//class ZipperTests: XCTestCase {
//
//    func testInit() {
//        let t = Tree.leaf(0)
//        _ = Zipper(t)
//    }
//
//    func testmoveToIndexLeafError() {
//        let z = Zipper(.leaf(0))
//        XCTAssertThrowsError(try z.move(to: 0))
//    }
//
//    func testmoveToIndexZeroNoError() {
//
//        let t = Tree.branch(-1, [
//            .leaf(1),
//            .leaf(2),
//            .leaf(3)
//        ])
//
//        let z = Zipper(t)
//
//        let result = try! z.move(to: 0)
//        XCTAssert(result.tree == Tree.leaf(1))
//        XCTAssertEqual(result.breadcrumbs.count, 1)
//        XCTAssertEqual(result.breadcrumbs[0].value, -1)
//        XCTAssert(result.breadcrumbs[0].trees.0 == [])
//        XCTAssert(result.breadcrumbs[0].trees.1 == [.leaf(2), .leaf(3)])
//    }
//
//    func testmoveToIndexMiddleNoError() {
//
//        let t = Tree.branch(-1, [
//            .leaf(1),
//            .leaf(2),
//            .leaf(3)
//        ])
//
//        let z = Zipper(t)
//
//        let result = try! z.move(to: 1)
//        XCTAssert(result.tree == Tree.leaf(2))
//        XCTAssertEqual(result.breadcrumbs.count, 1)
//    }
//
//    func testToIndexEndNoError() {
//
//        let t = Tree.branch(-1, [
//            .leaf(1),
//            .leaf(2),
//            .leaf(3)
//        ])
//
//        let z = Zipper(t)
//
//        let result = try! z.move(to: 2)
//        XCTAssert(result.tree == Tree.leaf(3))
//        XCTAssertEqual(result.breadcrumbs.count, 1)
//    }
//
//    func testToIndexToFarError() {
//
//        let t = Tree.branch(-1, [
//            .leaf(1),
//            .leaf(2),
//            .leaf(3)
//        ])
//
//        let z = Zipper(t)
//
//        XCTAssertThrowsError(try z.move(to: 3))
//    }
//
//    func testTop() {
//
//        let t = Tree.branch(-1, [
//            .leaf(1),
//            .leaf(2),
//            .leaf(3)
//        ])
//
//        let z = Zipper(t)
//
//        XCTAssert(z.top.tree == z.tree)
//    }
//
//    func testMoveToIndexNested() {
//
//        let t = Tree.branch(-1, [
//            .leaf(1),
//            .branch(-1, [
//                .leaf(2),
//                .leaf(3),
//                .leaf(4)
//            ]),
//            .leaf(5)
//        ])
//
//        let z = Zipper(t)
//        let branch = try! z.move(to: 1)
//
//        XCTAssertEqual(branch.tree.leaves, [2,3,4])
//    }
//
//    func testUpFromNested() {
//
//        let t = Tree.branch(-1, [
//            .leaf(1),
//            .branch(-1, [
//                .leaf(2),
//                .leaf(3),
//                .leaf(4)
//            ]),
//            .leaf(5)
//        ])
//
//        let z = Zipper(t)
//        let top = try! z.move(to: 1).up!
//
//        XCTAssertEqual(top.tree.leaves, z.tree.leaves)
//    }
//
//    func testUp() {
//
//        let t = Tree.branch(-1, [
//            .leaf(1),
//            .branch(-1, [
//                .leaf(2),
//                .leaf(3),
//                .leaf(4)
//            ]),
//            .leaf(5)
//        ])
//
//        let z = Zipper(t)
//        let three = try! z.move(to: 1).move(to: 1)
//        let middle = three.up!
//        let top = middle.up!
//
//        XCTAssertEqual(middle.tree.leaves, [2,3,4])
//        XCTAssertEqual(top.tree.leaves, z.tree.leaves)
//        XCTAssert(three.up!.up!.tree == z.tree)
//    }
//
//    func testUpdate() {
//
//        let t = Tree.branch(-1, [
//            .leaf(1),
//            .branch(-1, [
//                .leaf(2),
//                .leaf(3),
//                .leaf(4)
//            ]),
//            .leaf(5)
//        ])
//
//        let z = Zipper(t)
//        let updated = try! z.move(to: 1).move(to: 1).update { $0 * 2 }.top
//        XCTAssertEqual(updated.tree.leaves, [1,2,6,4,5])
//    }
//
//    func testUpdateValue() {
//
//        let t = Tree.branch(-1, [
//            .leaf(1),
//            .branch(-1, [
//                .leaf(2),
//                .leaf(3),
//                .leaf(4)
//            ]),
//            .leaf(5)
//        ])
//
//        let z = Zipper(t)
//        let updated = try! z.move(to: 2).update(value: 0)
//        XCTAssertEqual(updated.tree.value, 0)
//    }
//
//    func testMoveThroughPathEmpty() {
//
//        let t = Tree.branch(-1, [
//            .leaf(1),
//            .branch(-1, [
//                .leaf(2),
//                .leaf(3),
//                .leaf(4)
//            ]),
//            .leaf(5)
//        ])
//
//        let z = Zipper(t)
//        let three = try! z.move(through: [])
//        XCTAssert(z.tree == three.tree)
//    }
//
//    func testMoveThroughPathNotEmpty() {
//
//        let t = Tree.branch(-1, [
//            .leaf(1),
//            .branch(-1, [
//                .leaf(2),
//                .leaf(3),
//                .leaf(4)
//            ]),
//            .leaf(5)
//        ])
//
//
//        let z = Zipper(t)
//        let three = try! z.move(through: [1,1])
//        XCTAssert(three.tree == .leaf(3))
//    }
//
//    func testMoveThroughPathBadPathError() {
//
//        let t = Tree.branch(-1, [
//            .leaf(1),
//            .branch(-1, [
//                .leaf(2),
//                .leaf(3),
//                .leaf(4)
//            ]),
//            .leaf(5)
//        ])
//
//        let z = Zipper(t)
//        XCTAssertThrowsError(try z.move(through: [2,3]))
//    }
//
//    func testChildren() {
//
//        let t = Tree.branch(-1, [
//            .leaf(1),
//            .branch(-1, [
//                .leaf(2),
//                .leaf(3),
//                .leaf(4)
//            ]),
//            .leaf(5)
//        ])
//
//        let z = Zipper(t)
//        let zChildren = z.children
//        XCTAssertEqual(zChildren.count, 3)
//
//        let internalBranch = try! z.move(to: 1)
//        let internalBranchChildren = internalBranch.children
//        XCTAssertEqual(internalBranchChildren.count, 3)
//    }
//
//    func testSiblings() {
//
//        let t = Tree.branch(-1, [
//            .leaf(1),
//            .branch(-1, [
//                .leaf(2),
//                .leaf(3),
//                .leaf(4)
//            ]),
//            .leaf(5)
//        ])
//
//        let z = Zipper(t)
//
//        XCTAssertEqual(z.siblings.count, 0)
//    }
//}
