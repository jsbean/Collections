//
//  PerformanceTestCase.swift
//  Collections
//
//  Created by James Bean on 7/12/17.
//
//

import XCTest
import Collections

final class Measuring<T> {

    enum Result {
        case success
        case failure(expected: Complexity, result: String)
    }

    enum Complexity {
        case constant
        case logarithmic
        case linear
        case quasiLineaer
        case quadratic
        case cubic
        case exponential
        case factorial
    }

    var resource: T

    init(_ resource: T) {
        self.resource = resource
    }

    @discardableResult func assertComplexity <U> (
        _ complexity: Complexity,
        setUp: ((inout T) -> Void)? = nil,
        for operation: (T) -> U
    ) -> Measuring
    {

//        assertLinearPerformance(
//            after: { (count) -> (Stack<Int>, Stack<Int>) in
//                var a = Stack<Int>()
//                var b = Stack<Int>()
//                for i in 0..<count {
//                    a.push(i)
//                    b.push(i)
//                }
//                return (a, b)
//            },
//            of: { _, stackPair in
//                _ = stackPair.0 == stackPair.1
//            }
//        )

        // XCTFail("x: \(x) is not equal to: \(y)")
        return self
    }

    /// Runs the `after` setup block, then times the performance of the `of` block. Each block is
    /// passed the `times` complexity parameter as an argument.
    /// - Returns: the average time it takes to run the `of` block out of 10 attempts
    private func calculateAveragePerformance<C>(
        after setup: (Int) -> C,
        of block: (Int, C) -> (),
        times n: Int,
        over trials: Int = 10
    ) -> Double
    {
        return (1...trials).map { _ in
            let mock = setup(n)
            let startTime = CFAbsoluteTimeGetCurrent()
            block(n, mock)
            let finishTime = CFAbsoluteTimeGetCurrent()
            return finishTime - startTime
            }.reduce(0, +) / Double(trials)
    }

    /// Runs the `after` setup block, then times the `of` block. Performs this sequence 10 times,
    /// increasing the complexity parameter each time linearly.
    /// - Returns: an array of pairs of `(n, averagePerformance)`
    func calculateLinearPerformanceResults<C>(
        after setup: (Int) -> C,
        of block: (Int, C) -> ()
    ) -> [(Int, Double)]
    {
        return stride(from: 100_000, through: 1_000_000, by: 100_000).map { n in
            return (n, calculateAveragePerformance(after: setup, of: block, times: n))
        }
    }

    /// Calculates the slope between points using the dy / dx formula.
    func calculateSlopes(of resultPoints: [(Int, Double)]) -> [Double] {
        return resultPoints.adjacentPairs().map { p1, p2 in
            let x1 = p1.0, x2 = p2.0
            let y1 = p1.1, y2 = p2.1
            guard y2-y1 != 0 else { return 0 }
            return Double(x2-x1) / (y2-y1)
        }
    }

    /// Asserts that the performance of the `block` after running `setup` is linear.
    /// The `setup` block is passed a complexity parameter as an argument (the `n` in `O(n)`)
    /// and must create a mock object. The `block` block is passed the complexity parameter and the
    /// mock objected created by the `setup` and is timed for its performance. The assertion is
    /// that the variance in the graph of average performance is under 0.5 compared to expected
    /// linear performance.
    func assertLinearPerformance<C>(after setup: (Int) -> C, of block: @escaping (Int, C) -> ()) {
        let results: [(Int, Double)] = calculateLinearPerformanceResults(after: setup, of: block)

        print("results: \(results)")

        let slopes = calculateSlopes(of: results)

        print("slopes: \(slopes)")

        let meanSlope = slopes.reduce(0, { a, b in a + b }) / Double(slopes.count)
        let normalizedSlopes = slopes.map { slope in slope / meanSlope }

        print("normalizedSlopes: \(normalizedSlopes)")

        let ratioVariance = normalizedSlopes.reduce(0, { a, b in a + (b-1) * (b-1) } )

        print("ratioVariance: \(ratioVariance)")
        
        XCTAssert(ratioVariance < 2)
    }
}

class CollectionPerformanceTestCase: XCTestCase {


    func testRefactor() {


        let resource: Array<Int> = []
        Measuring(resource)
            .assertComplexity(.constant) { $0.count }
            .assertComplexity(.linear) { $0.contains(.random) }


//        let resource: SortedDictionary<Int,Int> = [:]
//        Measuring(resource)
//            .assertComplexity(.constant, setUp: { $0.insert(1, key: 1) }) { $0.endIndex }
//            .assertComplexity(.linear, setUp: { $0 = [:] }) { $0.startIndex }
//            .assertComplexity(.constant) { $0.startIndex }
    }
//
//    /// Runs the `after` setup block, then times the performance of the `of` block. Each block is
//    /// passed the `times` complexity parameter as an argument.
//    /// - Returns: the average time it takes to run the `of` block out of 10 attempts
//    func calculateAveragePerformance<C>(
//        after setup: (Int) -> C,
//        of block: (Int, C) -> (),
//        times n: Int
//    ) -> Double
//    {
//        let indices = (1...10)
//        let timings: [Double] = indices.map { _ in
//            let mock = setup(n)
//            let startTime = CFAbsoluteTimeGetCurrent()
//            block(n, mock)
//            let finishTime = CFAbsoluteTimeGetCurrent()
//            return finishTime - startTime
//        }
//        let mean = timings.reduce(0, +) / Double(timings.count)
//        return mean
//    }
//
//    /// Runs the `after` setup block, then times the `of` block. Performs this sequence 10 times,
//    /// increasing the complexity parameter each time linearly.
//    /// - Returns: an array of pairs of `(n, averagePerformance)`
//    func calculateLinearPerformanceResults<C>(
//        after setup: (Int) -> C,
//        of block: (Int, C) -> ()
//    ) -> [(Int, Double)]
//    {
//        return stride(from: 100_000, through: 1_000_000, by: 100_000).map { n in
//            return (n, calculateAveragePerformance(after: setup, of: block, times: n))
//        }
//    }
//
//    /// Calculates the slope between points using the dy / dx formula.
//    func calculateSlopes(of resultPoints: [(Int, Double)]) -> [Double] {
//        return resultPoints.adjacentPairs().map { p1, p2 in
//            let x1 = p1.0, x2 = p2.0
//            let y1 = p1.1, y2 = p2.1
//            guard y2-y1 != 0 else { return 0 }
//            return Double(x2-x1) / (y2-y1)
//        }
//    }
//
//    /// Asserts that the performance of the `block` after running `setup` is linear.
//    /// The `setup` block is passed a complexity parameter as an argument (the `n` in `O(n)`)
//    /// and must create a mock object. The `block` block is passed the complexity parameter and the
//    /// mock objected created by the `setup` and is timed for its performance. The assertion is
//    /// that the variance in the graph of average performance is under 0.5 compared to expected
//    /// linear performance.
//    func assertLinearPerformance<C>(after setup: (Int) -> C, of block: @escaping (Int, C) -> ()) {
//        let results: [(Int, Double)] = calculateLinearPerformanceResults(after: setup, of: block)
//
//        print("results: \(results)")
//
//        let slopes = calculateSlopes(of: results)
//
//        print("slopes: \(slopes)")
//
//        let meanSlope = slopes.reduce(0, { a, b in a + b }) / Double(slopes.count)
//        let normalizedSlopes = slopes.map { slope in slope / meanSlope }
//
//        print("normalizedSlopes: \(normalizedSlopes)")
//
//        let ratioVariance = normalizedSlopes.reduce(0, { a, b in a + (b-1) * (b-1) } )
//
//        print("ratioVariance: \(ratioVariance)")
//
//        XCTAssert(ratioVariance < 2)
//    }
//
//    /// Example test to demonstrate usage. Time taken to compare two stacks should be linear
//    /// in the number of elements in the stack.
//    func DISABLED_testExample() {
//        assertLinearPerformance(
//            after: { (count) -> (Stack<Int>, Stack<Int>) in
//                var a = Stack<Int>()
//                var b = Stack<Int>()
//                for i in 0..<count {
//                    a.push(i)
//                    b.push(i)
//                }
//                return (a, b)
//            },
//            of: { _, stackPair in
//                _ = stackPair.0 == stackPair.1
//            }
//        )
//    }
}
