//
//  StringExtensions.swift
//  Collections
//
//  Created by James Bean on 1/16/17.
//
//

public extension String {
    
    /// - returns: The `Character` value at the given `index`, if available. Otherwise `nil`.
    subscript (index: Int) -> Character? {
        
        if index >= self.characters.count {
            return nil
        }
        
        return self[self.characters.index(self.startIndex, offsetBy: index)]
    }
    
    /// - returns: The `String` value at the given `index`, if available. Otherwise `nil`.
    subscript (index: Int) -> String? {
        let charOrNil: Character? = self[index]
        
        guard let char = charOrNil else {
            return nil
        }
        
        return String(char as Character)
    }
    
    /// - returns: The `String` value for the given `range`, if available. Otherwise `nil`.
    subscript (range: Range<Int>) -> String {
        return substring(
            with: Range(
                characters.index(startIndex, offsetBy: range.lowerBound) ..<
                characters.index(startIndex, offsetBy: range.upperBound)
            )
        )
    }

    /// - returns: Tuple of the first, and remaining string values, if available.
    /// Otherwise, `nil`.
    public var destructured: (String, String)? {
        
        guard let head: String = self[0] else {
            return nil
        }
        
        let tail: String = self[1..<self.characters.count]
        return (head, tail)
    }
}
