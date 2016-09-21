//
//  Operators.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 26/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation


infix operator << {}

infix operator !< {
    associativity none
    precedence 160
}

infix operator !~ {
    associativity none
    precedence 130
}


// MARK: - Comparators

/* Between */

/**
 A property's value is in a provided range
 
 - parameters:
    - property: the name of a property
    - range:    the range the property should be in
 
 - returns: a `FilterStatement`
 */
public func << <T: StoreableValueConvertible where T: ForwardIndexType>(property: String, range: Range<T>) -> FilterStatement {
    return Expression.between(property, range.startIndex.storeableValue, range.endIndex.storeableValue)
}

/**
 A property's value is not in a provided range
 
 - parameters:
    - property: the name of a property
    - range:    the range the property should not be in
 
 - returns: a `FilterStatement`
 */
public func !< <T: StoreableValueConvertible where T: ForwardIndexType>(property: String, range: Range<T>) -> FilterStatement {
    return Expression.notBetween(property, range.startIndex.storeableValue, range.endIndex.storeableValue)
}

/* Contained */

/**
 A property's value is in a provided array
 
 - parameters:
    - property: the name of a property
    - array:    the array the property should be contained in
 
 - returns: a `FilterStatement`
 */
public func << <T: StoreableValueConvertible>(property: String, array: [T?]) -> FilterStatement {
    return property << array.map { $0?.storeableValue }
}

/**
 A property's value is in a provided array
 
 - parameters:
    - property: the name of a property
    - array:    the array the property should be contained in
 
 - returns: a `FilterStatement`
 */
public func << (property: String, array: [StoreableValue?]) -> FilterStatement {
    return Expression.containedIn(property, array)
}

/**
 A property's value is not in a provided array
 
 - parameters:
 - property: the name of a property
 - array:    the array the property should not be contained in
 
 - returns: a `FilterStatement`
 */
public func !< <T: StoreableValueConvertible>(property: String, array: [T?]) -> FilterStatement {
    return property !< array.map { $0?.storeableValue }
}

/**
 A property's value is not in a provided array
 
 - parameters:
    - property: the name of a property
    - array:    the array the property should not be contained in
 
 - returns: a `FilterStatement`
 */
public func !< (left: String, right: [StoreableValue?]) -> FilterStatement {
    return Expression.notContainedIn(left, right)
}

/* Like */

/**
 A property's value matches a provided pattern
 
 * `%` matches any sequence of characters
 * `_` matches any single character

 - parameters:
    - property: the name of a property
    - pattern:  the patternt used for matching
 
 - returns: a `FilterStatement`
 */
public func ~= (left: String, right: String) -> FilterStatement {
    return Expression.like(left, right.storeableValue)
}

/**
 A property's value does not match a provided pattern
 
 * `%` matches any sequence of characters
 * `_` matches any single character
 
 - parameters:
    - property: the name of a property
    - pattern:  the patternt used for matching
 
 - returns: a `FilterStatement`
 */
public func !~ (left: String, right: String) -> FilterStatement {
    return Expression.notLike(left, right.storeableValue)
}


public func == <T: Storeable>(left: String, right: T) -> FilterStatement {
    let reader = Mapper.readerForObject(right)
    return Expression.equal(left, reader.identifierValue)
}

public func == <T: Storeable>(left: String, right: T?) -> FilterStatement {
    var reader: Reader? = nil
    
    if let object = right {
        reader = Mapper.readerForObject(object)
    }
    
    return Expression.equal(left, reader?.identifierValue)
}


public func == <T: StoreableValueConvertible>(left: String, right: T) -> FilterStatement {
    return Expression.equal(left, right.storeableValue)
}

public func == <T: StoreableValueConvertible>(left: String, right: T?) -> FilterStatement {
    return Expression.equal(left, right?.storeableValue)
}



public func != <T: Storeable>(left: String, right: T) -> FilterStatement {
    let reader = Mapper.readerForObject(right)
    return Expression.notEqual(left, reader.identifierValue)
}

public func != <T: StoreableValueConvertible>(left: String, right: T) -> FilterStatement {
    return Expression.notEqual(left, right.storeableValue)
}

public func != <T: StoreableValueConvertible>(left: String, right: T?) -> FilterStatement {
    return Expression.notEqual(left, right?.storeableValue)
}


public func < <T: StoreableValueConvertible>(left: String, right: T) -> FilterStatement {
    return Expression.less(left, right.storeableValue)
}

public func > <T: StoreableValueConvertible>(left: String, right: T) -> FilterStatement {
    return Expression.greater(left, right.storeableValue)
}

public func <= <T: StoreableValueConvertible>(left: String, right: T) -> FilterStatement {
    return Expression.lessOrEqual(left, right.storeableValue)
}

public func >= <T: StoreableValueConvertible>(left: String, right: T) -> FilterStatement {
    return Expression.greaterOrEqual(left, right.storeableValue)
}


// MARK: RawRepresentable

public func == <T: RawRepresentable where T.RawValue: StoreableValueConvertible>(left: String, right: T) -> FilterStatement {
    return Expression.equal(left, right.rawValue.storeableValue)
}

public func == <T: RawRepresentable where T.RawValue: StoreableValueConvertible>(left: String, right: T?) -> FilterStatement {
    return Expression.equal(left, right?.rawValue.storeableValue)
}


public func != <T: RawRepresentable where T.RawValue: StoreableValueConvertible>(left: String, right: T) -> FilterStatement {
    return Expression.notEqual(left, right.rawValue.storeableValue)
}

public func != <T: RawRepresentable where T.RawValue: StoreableValueConvertible>(left: String, right: T?) -> FilterStatement {
    return Expression.notEqual(left, right?.rawValue.storeableValue)
}


// MARK: - Connectives

public func &&(left: FilterStatement, right: FilterStatement) -> FilterStatement {
    return Connective.conjunction(left, right)
}

public func ||(left: FilterStatement, right: FilterStatement) -> FilterStatement {
    return Connective.disjunction(left, right)
}

// MARK: - Negations

public prefix func !(filter: FilterStatement) -> FilterStatement {
    return filter.negated()
}


