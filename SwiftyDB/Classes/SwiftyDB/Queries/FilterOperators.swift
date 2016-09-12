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
    return Expression.Between(left, right.startIndex.storeableValue, right.endIndex.storeableValue)
}

public func !< <T: StoreableValueConvertible where T: ForwardIndexType>(left: String, right: Range<T>) -> FilterStatement {
    return Expression.NotBetween(left, right.startIndex.storeableValue, right.endIndex.storeableValue)
}

/* Contained */

public func << <T: StoreableValueConvertible>(left: String, right: [T?]) -> FilterStatement {
    return Expression.ContainedIn(left, right.map { $0?.storeableValue })
}

public func << (left: String, right: [StoreableValue?]) -> FilterStatement {
    return Expression.ContainedIn(left, right)
}

public func !< <T: StoreableValueConvertible>(left: String, right: [T?]) -> FilterStatement {
    return Expression.NotContainedIn(left, right.map { $0?.storeableValue })
}

public func !< (left: String, right: [StoreableValue?]) -> FilterStatement {
    return Expression.NotContainedIn(left, right)
}

/* Like */

public func ~= (left: String, right: String) -> FilterStatement {
    return Expression.Like(left, right.storeableValue)
}

public func !~ (left: String, right: String) -> FilterStatement {
    return Expression.NotLike(left, right.storeableValue)
}


public func == <T: Storeable>(left: String, right: T) -> FilterStatement {
    let reader = Mapper.readerForObject(right)
    return Expression.Equal(left, reader.identifierValue)
}

public func == <T: Storeable>(left: String, right: T?) -> FilterStatement {
    var reader: Reader? = nil
    
    if let object = right {
        reader = Mapper.readerForObject(object)
    }
    
    return Expression.Equal(left, reader?.identifierValue)
}


public func == <T: StoreableValueConvertible>(left: String, right: T) -> FilterStatement {
    return Expression.Equal(left, right.storeableValue)
}

public func == <T: StoreableValueConvertible>(left: String, right: T?) -> FilterStatement {
    return Expression.Equal(left, right?.storeableValue)
}



public func != <T: Storeable>(left: String, right: T) -> FilterStatement {
    let reader = Mapper.readerForObject(right)
    return Expression.NotEqual(left, reader.identifierValue)
}

public func != <T: StoreableValueConvertible>(left: String, right: T) -> FilterStatement {
    return Expression.NotEqual(left, right.storeableValue)
}

public func != <T: StoreableValueConvertible>(left: String, right: T?) -> FilterStatement {
    return Expression.NotEqual(left, right?.storeableValue)
}


public func < <T: StoreableValueConvertible>(left: String, right: T) -> FilterStatement {
    return Expression.Less(left, right.storeableValue)
}

public func > <T: StoreableValueConvertible>(left: String, right: T) -> FilterStatement {
    return Expression.Greater(left, right.storeableValue)
}

public func <= <T: StoreableValueConvertible>(left: String, right: T) -> FilterStatement {
    return Expression.LessOrEqual(left, right.storeableValue)
}

public func >= <T: StoreableValueConvertible>(left: String, right: T) -> FilterStatement {
    return Expression.GreaterOrEqual(left, right.storeableValue)
}


// MARK: RawRepresentable

public func == <T: RawRepresentable where T.RawValue: StoreableValueConvertible>(left: String, right: T) -> FilterStatement {
    return Expression.Equal(left, right.rawValue.storeableValue)
}

public func == <T: RawRepresentable where T.RawValue: StoreableValueConvertible>(left: String, right: T?) -> FilterStatement {
    return Expression.Equal(left, right?.rawValue.storeableValue)
}


public func != <T: RawRepresentable where T.RawValue: StoreableValueConvertible>(left: String, right: T) -> FilterStatement {
    return Expression.NotEqual(left, right.rawValue.storeableValue)
}

public func != <T: RawRepresentable where T.RawValue: StoreableValueConvertible>(left: String, right: T?) -> FilterStatement {
    return Expression.NotEqual(left, right?.rawValue.storeableValue)
}


// MARK: - Connectives

public func &&(left: FilterStatement, right: FilterStatement) -> FilterStatement {
    return Connective.Conjunction(left, right)
}

public func ||(left: FilterStatement, right: FilterStatement) -> FilterStatement {
    return Connective.Disjunction(left, right)
}

// MARK: - Negations

public prefix func !(filter: FilterStatement) -> FilterStatement {
    return filter.negated()
}


