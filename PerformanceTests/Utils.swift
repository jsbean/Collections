//
//  Utils.swift
//  Collections
//
//  Created by James Bean on 7/11/17.
//
//

import Darwin

extension Int {

    /// - Returns: Random number between 0..<4294967295
    static var random: Int {
        return numericCast(arc4random_uniform(UInt32.max))
    }
}
