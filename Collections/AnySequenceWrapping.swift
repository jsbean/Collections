//
//  AnySequenceWrapping.swift
//  Collections
//
//  Created by James Bean on 12/9/16.
//
//

/// `AnySequenceWrapping` is a type-erasing protocol that allows a `Sequence`-conforming 
/// structure to wrap any underlying `Sequence` implementation.
///
/// For example, `PitchSet` and `PitchCollection` are both containers for `Pitch` values, and
/// should both be able to be used as `Sequence` conforming structures. 
///
/// By conforming to this protocol, the `PitchSet` can use a `Set<Pitch>` as its underlying 
/// model, while `PitchSequence` can use an `Array<Pitch>` as its underlying model.
///
/// In the conforming `struct`, it is necessary to add a private `var` which is an
/// implementation of a `Sequence`-conforming `struct`, which is then given by the
/// `sequence` getter.
///
/// In the `init` method of the conforming `struct`, set the value of this private `var` with 
/// the given `sequence`.
public protocol AnySequenceWrapping: Sequence, ExpressibleByArrayLiteral {
    
    // MARK: Associated Types
    
    /// The contained type.
    associatedtype Element
    
    // MARK: - Instance Properties
    
    /// `AnySequence` wrapper that provides shade for the domain specific implementation.
    var sequence: AnySequence<Element> { get }
    
    // MARK: - Initializers
    
    /**
     Create an `AnySequenceType` with a `Sequence` of any type.
     
     In the `init` method of the conforming `struct`, set the value of this private variable
     with the given `sequence`.
     */
    init <S: Sequence> (_ sequence: S) where S.Iterator.Element == Element
}

extension AnySequenceWrapping {
    
    // MARK: - `Sequence`
    
    /// - returns a generator over the elements of this sequence.
    public func makeIterator() -> AnyIterator<Element> {

        let iterator = sequence.makeIterator()
        
        return AnyIterator {
            return iterator.next()
        }
    }
}
