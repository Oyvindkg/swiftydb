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
public func !< (property: String, array: [StoreableValue?]) -> FilterStatement {
    return Expression.notContainedIn(property, array)
}


/**
 A property's value matches a provided pattern
 
 * `%` matches any sequence of characters
 * `_` matches any single character

 - parameters:
    - property: the name of a property
    - pattern:  the pattern used for matching
 
 - returns: a `FilterStatement`
 */
public func ~= (property: String, pattern: String) -> FilterStatement {
    return Expression.like(property, pattern.storeableValue)
}

/**
 A property's value does not match a provided pattern
 
 * `%` matches any sequence of characters
 * `_` matches any single character
 
 - parameters:
    - property: the name of a property
    - pattern:  the pattern used for matching
 
 - returns: a `FilterStatement`
 */
public func !~ (property: String, pattern: String) -> FilterStatement {
    return Expression.notLike(property, pattern.storeableValue)
}

/**
 A property's value is equal to the provided storable object
 
 - parameters:
    - property: the name of a property
    - object:   the storable object
 
 - returns: a `FilterStatement`
 */
public func == <T: Storeable>(property: String, object: T) -> FilterStatement {
    let reader = Mapper.readerForObject(object)
    
    return Expression.equal(property, reader.identifierValue)
}

/**
 A property's value is equal to the provided storable object
 
 - parameters:
    - property: the name of a property
    - object:   the storable object
 
 - returns: a `FilterStatement`
 */
public func == <T: Storeable>(property: String, object: T?) -> FilterStatement {
    var reader: Reader? = nil
    
    if let object = object {
        reader = Mapper.readerForObject(object)
    }
    
    return Expression.equal(property, reader?.identifierValue)
}


/**
 A property's value is equal to the provided value
 
 - parameters:
    - property: the name of a property
    - value:    the value to be compared
 
 - returns: a `FilterStatement`
 */
public func == <T: StoreableValueConvertible>(property: String, value: T) -> FilterStatement {
    return Expression.equal(property, value.storeableValue)
}

/**
 A property's value is equal to the provided value
 
 - parameters:
    - property: the name of a property
    - value:    the value to be compared
 
 - returns: a `FilterStatement`
 */
public func == <T: StoreableValueConvertible>(property: String, value: T?) -> FilterStatement {
    return Expression.equal(property, value?.storeableValue)
}


/**
 A property's value is not equal to the provided value
 
 - parameters:
    - property: the name of a property
    - value:    the value to be compared
 
 - returns: a `FilterStatement`
 */
public func != <T: Storeable>(property: String, value: T) -> FilterStatement {
    let reader = Mapper.readerForObject(value)
    
    return Expression.notEqual(property, reader.identifierValue)
}

/**
 A property's value is not equal to the provided storable object
 
 - parameters:
    - property: name of a property
    - object:   a storable object
 
 - returns: a `FilterStatement`
 */
public func != <T: Storeable>(property: String, object: T?) -> FilterStatement {
    guard object != nil else {
        return Expression.notEqual(property, nil)
    }
    
    let reader = Mapper.readerForObject(object!)
    
    return Expression.notEqual(property, reader.identifierValue)
}

/**
 A property's value is not equal to the provided value
 
 - parameters:
    - property: the name of a property
    - value:    the value to be compared
 
 - returns: a `FilterStatement`
 */
public func != <T: StoreableValueConvertible>(property: String, value: T) -> FilterStatement {
    return Expression.notEqual(property, value.storeableValue)
}

/**
 A property's value is not equal to the provided value
 
 - parameters:
    - property: the name of a property
    - value:    the value to be compared
 
 - returns: a `FilterStatement`
 */
public func != <T: StoreableValueConvertible>(property: String, value: T?) -> FilterStatement {
    return Expression.notEqual(property, value?.storeableValue)
}


/**
 A property's value is less than the provided value
 
 - parameters:
    - property: the name of a property
    - value:    the value to be compared
 
 - returns: a `FilterStatement`
 */
public func < <T: StoreableValueConvertible>(property: String, value: T) -> FilterStatement {
    return Expression.less(property, value.storeableValue)
}

/**
 A property's value is greater than the provided value
 
 - parameters:
    - property: the name of a property
    - value:    the value to be compared
 
 - returns: a `FilterStatement`
 */
public func > <T: StoreableValueConvertible>(property: String, value: T) -> FilterStatement {
    return Expression.greater(property, value.storeableValue)
}

/**
 A property's value is less than or equal to the provided value
 
 - parameters:
    - property: the name of a property
    - value:    the value to be compared
 
 - returns: a `FilterStatement`
 */
public func <= <T: StoreableValueConvertible>(left: String, right: T) -> FilterStatement {
    return Expression.lessOrEqual(left, right.storeableValue)
}

/**
 A property's value is greater than or equal to the provided value
 
 - parameters:
    - property: the name of a property
    - value:    the value to be compared
 
 - returns: a `FilterStatement`
 */
public func >= <T: StoreableValueConvertible>(property: String, value: T) -> FilterStatement {
    return Expression.greaterOrEqual(property, value.storeableValue)
}


// MARK: RawRepresentable

/**
 A property's value is equal to the provided RawRepresentable
 
 - parameters:
    - property: the name of a property
    - value:    the value to be compared
 
 - returns: a `FilterStatement`
 */
public func == <T: RawRepresentable where T.RawValue: StoreableValueConvertible>(property: String, value: T) -> FilterStatement {
    return Expression.equal(property, value.rawValue.storeableValue)
}

/**
 A property's value is equal to the provided RawRepresentable
 
 - parameters:
    - property: the name of a property
    - value:    the value to be compared
 
 - returns: a `FilterStatement`
 */
public func == <T: RawRepresentable where T.RawValue: StoreableValueConvertible>(property: String, value: T?) -> FilterStatement {
    return Expression.equal(property, value?.rawValue.storeableValue)
}

/**
 A property's value is not equal to the provided RawRepresentable
 
 - parameters:
    - property: the name of a property
    - value:    the value to be compared
 
 - returns: a `FilterStatement`
 */
public func != <T: RawRepresentable where T.RawValue: StoreableValueConvertible>(property: String, value: T) -> FilterStatement {
    return Expression.notEqual(property, value.rawValue.storeableValue)
}

/**
 A property's value is not equal to the provided RawRepresentable
 
 - parameters:
    - property: the name of a property
    - value:    the value to be compared
 
 - returns: a `FilterStatement`
 */
public func != <T: RawRepresentable where T.RawValue: StoreableValueConvertible>(property: String, value: T?) -> FilterStatement {
    return Expression.notEqual(property, value?.rawValue.storeableValue)
}


// MARK: - Connectives

/**
 Both the left and right filter statement must be true
 
 - parameters:
    - left:     a filter statement
    - right:    an other filter statement
 
 - returns: a `FilterStatement`
 */
public func &&(left: FilterStatement, right: FilterStatement) -> FilterStatement {
    return Connective.conjunction(left, right)
}

/**
 The left or right filter statement must be true
 
 - parameters:
 - left:    a filter statement
 - right:   an other filter statement
 
 - returns: a `FilterStatement`
 */
public func ||(left: FilterStatement, right: FilterStatement) -> FilterStatement {
    return Connective.disjunction(left, right)
}

// MARK: - Negations

/**
 Negate the provided filter statement
 
 - parameters:
    - filter: a filter statement
 
 - returns: a `FilterStatement`
 */
public prefix func !(filter: FilterStatement) -> FilterStatement {
    return filter.negated()
}


