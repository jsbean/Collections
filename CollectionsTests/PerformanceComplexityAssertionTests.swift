//
// PerformanceComplexityAssertionTests.swift
// Collections
//
// Author: Brian Heim, August 2017

import XCTest
import Collections

/// Tests to check correctness of PerformanceComplexityAssertion functions. Data is
/// intentionally dirty.
class PerformanceComplexityAssertionTests: XCTestCase {

    // - MARK: constant

    func testConstant() {
        let data: [(Double, Double)] = [(1, 1.01), (2, 1.01), (3, 1.05), (4, 0.99)]
        assertPerformanceComplexity(data, complexity: .constant)
    }

    // - MARK: logarithmic

    func testLogarithmicBaseTwoSlopeOne() {
        let data: [(Double, Double)] = [(10, 3.32), (20, 4.32), (30, 4.91), (40, 5.32)]
        assertPerformanceComplexity(data, complexity: .logarithmic)
    }

    func testLogarithmicBaseTwoSlopeThree() {
        let data: [(Double, Double)] = [(10, 4.90), (20, 5.91), (30, 6.49), (40, 6.90)]
        assertPerformanceComplexity(data, complexity: .logarithmic)
    }

    func testLogarithmicBaseESlopeOne() {
        let data: [(Double, Double)] = [(10, 2.30), (20, 2.99), (30, 3.40), (40, 3.69)]
        assertPerformanceComplexity(data, complexity: .logarithmic)
    }

    func testLogarithmicBaseESlopeThree() {
        let data: [(Double, Double)] = [(10, 3.40), (20, 4.09), (30, 4.50), (40, 4.79)]
        assertPerformanceComplexity(data, complexity: .logarithmic)
    }

    // - MARK: linear

    func testLinearSlopeOne() {
        let data: [(Double, Double)] = [(10, 10), (20, 20.5), (30, 29.5), (40, 39.9)]
        assertPerformanceComplexity(data, complexity: .linear)
    }

    func testLinearSlopeThree() {
        let data: [(Double, Double)] = [(10, 30), (20, 61), (30, 85), (40, 121)]
        assertPerformanceComplexity(data, complexity: .linear)
    }

    // - MARK: linearithmic (TODO)

    // - MARK: quadratic

    func testQuadraticSlopeOne() {
        let data: [(Double, Double)] = [(10, 100), (20, 400), (30, 900), (40, 1640)]
        assertPerformanceComplexity(data, complexity: .quadratic)
    }

    func testQuadraticSlopeThree() {
        let data: [(Double, Double)] = [(10, 300), (20, 1207), (30, 2704), (40, 4805)]
        assertPerformanceComplexity(data, complexity: .quadratic)
    }

    // - MARK: cubic

    func testCubicSlopeOne() {
        let data: [(Double, Double)] = [(10, 1000), (20, 4000), (30, 9000), (40, 16040)]
        assertPerformanceComplexity(data, complexity: .cubic)
    }

    func testCubicSlopeThree() {
        let data: [(Double, Double)] = [(10, 3000), (20, 12007), (30, 27004), (40, 48050)]
        assertPerformanceComplexity(data, complexity: .cubic)
    }

    // - MARK: exponential

    func testExponentialBaseTwoSlopeOne() {
        let data: [(Double, Double)] = [(10, 1024), (20, 1e6), (30, 1e9), (40, 1e12)]
        assertPerformanceComplexity(data, complexity: .exponential)
    }

    func testExponentialBaseTwoSlopeThree() {
        let data: [(Double, Double)] = [(10, 3072), (20, 3e6), (30, 3e9), (40, 3e12)]
        assertPerformanceComplexity(data, complexity: .exponential)
    }

}
