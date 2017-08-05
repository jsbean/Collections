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

func testNonMutatingOperation<C>(
    mock object: C,
    setupFunction: (inout C, Double) -> (),
    trialCode: (inout C, Double) -> (),
    testPoints: [Double],
    trialCount: Int = 10
) -> [(Double, Double)] {
    return testPoints.map { point in
        var pointMock = object
        setupFunction(&pointMock, point)
        let average = (0..<trialCount).map { _ in
            let startTime = CFAbsoluteTimeGetCurrent()
            trialCode(&pointMock, point)
            let finishTime = CFAbsoluteTimeGetCurrent()
            return finishTime - startTime
        }.reduce(0, +) / Double(trialCount)
        return (point, average)
    }
}

func testMutatingOperation<C>(
    mock object: C,
    setupFunction: (inout C, Double) -> (),
    trialCode: (inout C, Double) -> (),
    testPoints: [Double],
    trialCount: Int = 10
) -> [(Double, Double)] {
    return testPoints.map { point in
        var pointMock = object
        setupFunction(&pointMock, point)
        let average = (0..<trialCount).map { _ in
            var trialMock = pointMock
            let startTime = CFAbsoluteTimeGetCurrent()
            trialCode(&trialMock, point)
            let finishTime = CFAbsoluteTimeGetCurrent()
            return finishTime - startTime
        }.reduce(0, +) / Double(trialCount)
        return (point, average)
    }
}

func assertLinearPerformance(_ data: [(Double, Double)]) {
    let (slope, intercept, rvalue) = linearRegression(data)
    let expectedSlope: Double = 1
    let expectedSlopeAccuracy = 0.01
    let expectedRValueMin = 0.99

    // debug
    print("slope: \(slope), expected \(expectedSlope) with accuracy \(expectedSlopeAccuracy)")
    print("intercept: \(intercept)")
    print("rvalue: \(rvalue), expected min \(expectedRValueMin)")

    XCTAssertEqual(slope, expectedSlope, accuracy: expectedSlopeAccuracy)
    XCTAssert(rvalue < expectedRValueMax)
}

func assertConstantPerformance(_ data: [(Double, Double)]) {
    let (slope, intercept, rvalue) = linearRegression(data)
    let expectedSlope: Double = 0
    let expectedSlopeAccuracy = 0.01
    let expectedRValueMin = 0.99

    // debug
    print("slope: \(slope), expected \(expectedSlope) with accuracy \(expectedSlopeAccuracy)")
    print("intercept: \(intercept)")
    print("rvalue: \(rvalue), expected min \(expectedRValueMax)")

    XCTAssertEqual(slope, expectedSlope, accuracy: expectedSlopeAccuracy)
    XCTAssert(rvalue < expectedRValueMax)
}

func assertLogPerformance(_ data: [(Double, Double)]) {
    let logData = data.map { ($0, exp($1)) }
    let (slope, intercept, rvalue) = linearRegression(logData)
    let expectedSlope: Double = 0
    let expectedSlopeAccuracy = 0.01
    let expectedRValueMax = 0.01

    // debug
    print("slope: \(slope), expected \(expectedSlope) with accuracy \(expectedSlopeAccuracy)")
    print("intercept: \(intercept)")
    print("rvalue: \(rvalue), expected max \(expectedRValueMax)")

    XCTAssertEqual(slope, expectedSlope, accuracy: expectedSlopeAccuracy)
    XCTAssert(rvalue < expectedRValueMax)
}

func linearRegression(_ data: [(Double, Double)]) -> (Double, Double, Double) {
    let xs = data.map { $0.0 }
    let ys = data.map { $0.1 }
    let sumOfXs = xs.reduce(0, +)
    let sumOfYs = ys.reduce(0, +)
    let sumOfXsSquared = xs.map { pow($0, 2) }.reduce(0, +)
    let sumOfXsTimesYs = data.map(*).reduce(0, +)

    let denominator = Double(data.count) * sumOfXsSquared - pow(sumOfXs, 2)
    let interceptNumerator = sumOfYs * sumOfXsSquared - sumOfXs * sumOfXsTimesYs
    let slopeNumerator = Double(data.count) * sumOfXsTimesYs - sumOfXs * sumOfYs

    let intercept = interceptNumerator / denominator
    let slope = slopeNumerator / denominator
    let regressionCoefficient = calculateRegressionCoefficient(data, sumOfXs: sumOfXs, sumOfYs: sumOfYs, slope: slope)

    return (slope, intercept, regressionCoefficient)
}

func calculateRegressionCoefficient(_ data: [(Double, Double)], sumOfXs: Double, sumOfYs: Double, slope: Double) -> Double {

    let meanOfYs = sumOfYs / Double(data.count)
    let squaredErrorOfYs = data.map { pow($0.1 - meanOfYs, 2) }.reduce(0, +)
    let denominator = squaredErrorOfYs

    // debugging
    print("\(#function): denominator: \(denominator)")

    guard denominator != 0 else { return 0 }

    let meanOfXs = sumOfXs / Double(data.count)
    let squaredErrorOfXs = data.map { pow($0.0 - meanOfXs, 2) }.reduce(0, +)
    let numerator = squaredErrorOfXs

    // debugging
    print("\(#function): numerator: \(numerator)")

    return sqrt(numerator / denominator) * slope
}

class CollectionPerformanceTestCase: XCTestCase {

    func testBasic() {
        assertLinearPerformance([(1, 1.01), (2, 2.01), (3, 3.05), (4, 3.99)])
        assertConstantPerformance([(1, 1.01), (2, 1.01), (3, 1.05), (4, 1.99)])
        assertLogPerformance([(1, 16), (2, 8), (3, 4), (4, 2)])
    }
    func testRefactor() {

        // ideal API:
        // Measuring(resource)
        //   .assertComplexity(.complexity, after: { <setup code> }, of: { <measured code> })

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
