//
//  PerformanceTestCase.swift
//  Collections
//
//  Created by James Bean on 7/12/17.
//
//

import XCTest
import Collections

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

}
