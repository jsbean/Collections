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

extension Sequence where Iterator.Element: Multiplicative {

    /// - Returns: Product of all values contained herein.
    public var product: Iterator.Element {
        return map { $0.product }.reduced
    }
}

extension Sequence where Iterator.Element: Additive {

    /// - Returns: Sum of all values contained herein.
    public var sum: Iterator.Element {
        return map { $0.sum }.reduced
    }
}

extension Collection where
    Iterator.Element: AdditiveSemigroup,
    SubSequence.Iterator.Element == Iterator.Element
{

    public var nonEmptySum: Iterator.Element? {
        guard let (head,tail) = destructured else { return nil }
        return tail.reduce(head, +)
    }
}

extension Collection where
    Iterator.Element: MultiplicativeSemigroup,
    SubSequence.Iterator.Element == Iterator.Element
{

    public var nonEmptyProduct: Iterator.Element? {
        guard let (head,tail) = destructured else { return nil }
        return tail.reduce(head, *)
    }
}
