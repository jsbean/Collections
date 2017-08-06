//
//  PerformanceComplexityAssertion.swift
//  Collections
//
//  Brian Heim, August 2017.
//
//

import XCTest
import Collections

struct PerformanceComplexityAssertionConfig {

    // Controls whether any methods in this file print debugging information
    static var debug: Bool = true

    // The default minimum correlation to accept
    static var defaultMinimumCorrelation: Double = 0.95

    // Default number of trials for performance testing
    static var defaultTrialCount: Int = 10

}

/// Classes of complexity (big-oh style).
enum ComplexityClass {

    case constant
    case logarithmic
    case linear
    case linearithmic // not implemented yet
    case quadratic
    case cubic
    case exponential
    case customComplexity(inverseFunction: (Double) -> Double)

    /// Maps data representing performance of a certain complexity so that it
    /// can be fit with linear regression. This is done by applying the inverse
    /// function of the expected performance function.
    public func mapDataForLinearFit(_ data: [(Double, Double)]) -> [(Double, Double)] {
        switch self {
        case .constant:
            return data
        case .logarithmic:
            return data.map { ($0.0, exp($0.1)) }
        case .linear:
            return data
        case .linearithmic:
            fatalError("inverse linearithmic data mapping not yet implemented")
        case .quadratic:
            return data.map { ($0.0, sqrt($0.1)) }
        case .cubic:
            return data.map { ($0.0, pow($0.1, 1/3)) }
        case .exponential:
            return data.map { ($0.0, log($0.1)) }
        case .customComplexity(let inverseFunction):
            return data.map { ($0.0, inverseFunction($0.1)) }
        }
    }
}

/// TODO: add helper functions that wraps data generation and performance assertion.

/// Tests the performance of a non-mutating operation.
func testNonMutatingOperation<C>(
    mock object: C,
    setupFunction: (inout C, Double) -> (),
    trialCode: (inout C, Double) -> (),
    testPoints: [Double],
    trialCount: Int = PerformanceComplexityAssertionConfig.defaultTrialCount)
    -> [(Double, Double)]
{
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

/// Tests the performance of a mutating operation.
func testMutatingOperation<C>(
    mock object: C,
    setupFunction: (inout C, Double) -> (),
    trialCode: (inout C, Double) -> (),
    testPoints: [Double],
    trialCount: Int = PerformanceComplexityAssertionConfig.defaultTrialCount)
    -> [(Double, Double)]
{
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

/// Assert that the data indicates that performance fits well to the given
/// complexity class. Optional parameter for minimum acceptable correlation.
func assertPerformanceComplexity(
    _ data: [(Double, Double)],
    complexity: ComplexityClass,
    minimumCorrelation: Double = PerformanceComplexityAssertionConfig.defaultMinimumCorrelation)
{
    let mappedData = complexity.mapDataForLinearFit(data)
    let (slope, intercept, correlation) = linearRegression(mappedData)

    if PerformanceComplexityAssertionConfig.debug {
        print("\(#function): mapped data:")
        for (x, y) in mappedData { print("\t(\(x), \(y))") }

        print("\(#function): slope:       \(slope)")
        print("\(#function): intercept:   \(intercept)")
        print("\(#function): correlation: \(correlation)")
        print("\(#function): min corr.:   \(minimumCorrelation)")
    }

    // FIXME: should split into two methods, add accuracy arg
    switch complexity {
    case .constant:
        XCTAssertEqual(slope, 0, accuracy: 0.01)
    default:
        XCTAssert(correlation >= minimumCorrelation)
    }
}

/// Performs linear regression on the given dataset. Returns a triple of
/// (slope, intercept, correlation).
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

/// Helper function to calculate the regression coefficient ("r") of the given dataset.
func calculateRegressionCoefficient(_ data: [(Double, Double)], sumOfXs: Double, sumOfYs: Double, slope: Double) -> Double {

    let meanOfYs = sumOfYs / Double(data.count)
    let squaredErrorOfYs = data.map { pow($0.1 - meanOfYs, 2) }.reduce(0, +)
    let denominator = squaredErrorOfYs

    if PerformanceComplexityAssertionConfig.debug {
        print("\(#function): denominator: \(denominator)")
    }

    guard denominator != 0 else { return 0 }

    let meanOfXs = sumOfXs / Double(data.count)
    let squaredErrorOfXs = data.map { pow($0.0 - meanOfXs, 2) }.reduce(0, +)
    let numerator = squaredErrorOfXs

    if PerformanceComplexityAssertionConfig.debug {
        print("\(#function): numerator: \(numerator)")
    }

    return sqrt(numerator / denominator) * slope
}

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
