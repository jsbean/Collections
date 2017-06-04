//
//  SetExtensions.swift
//  Collections
//
//  Created by James Bean on 6/4/17.
//
//

extension Set {

    /// Inserts each of the elements contained by `other`.
    public mutating func insert(contentsOf other: Set) {
        for el in other {
            insert(el)
        }
    }
}
