//
//  Sequence+Monoid.swift
//  Collections
//
//  Created by James Bean on 7/19/17.
//
//

import Algebra

extension Sequence where Iterator.Element: Monoid {

    /// - Returns: The values contained herein, reduced from the `.identity` value of the `Monoid`,
    /// composing with the `<>` operation of the `Monoid`.
    public var reduced: Iterator.Element {
        return reduce(.identity, <>)
    }
}

extension Sequence where Iterator.Element: MonoidView {

    /// - Returns: The values contained herein, reduced from the `.identity` value of the `Monoid`,
    /// composing with the `<>` operation of the `Monoid`.
    public var reduced: Iterator.Element.Value {
        return reduce(.identity, <>).value
    }
}
