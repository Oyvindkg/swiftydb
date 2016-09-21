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

public func << <T: StoreableValueConvertible where T: ForwardIndexType>(left: String, right: Range<T>) -> FilterStatement {
    return Expression.between(left, right.startIndex.storeableValue, right.endIndex.storeableValue)
}

public func !< <T: StoreableValueConvertible where T: ForwardIndexType>(left: String, right: Range<T>) -> FilterStatement {
    return Expression.notBetween(left, right.startIndex.storeableValue, right.endIndex.storeableValue)
}

/* Contained */

public func << <T: StoreableValueConvertible>(left: String, right: [T?]) -> FilterStatement {
    return Expression.containedIn(left, right.map { $0?.storeableValue })
}

public func << (left: String, right: [StoreableValue?]) -> FilterStatement {
    return Expression.containedIn(left, right)
}

public func !< <T: StoreableValueConvertible>(left: String, right: [T?]) -> FilterStatement {
    return Expression.notContainedIn(left, right.map { $0?.storeableValue })
}

public func !< (left: String, right: [StoreableValue?]) -> FilterStatement {
    return Expression.notContainedIn(left, right)
}

/* Like */

public func ~= (left: String, right: String) -> FilterStatement {
    return Expression.like(left, right.storeableValue)
}

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


