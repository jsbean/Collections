//
//  ComparableExtensions.swift
//  Collections
//
//  Created by Brian Heim on 1/6/18.
//

extension Comparable {

    public func clamped(in range: ClosedRange<Self>) -> Self {
        if self < range.lowerBound {
            return range.lowerBound
        } else if self > range.upperBound {
            return range.upperBound
        }
        return self
    }
    
}
