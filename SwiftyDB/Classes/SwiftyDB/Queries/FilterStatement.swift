//
//  Query.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 21/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

/** Represents some logical expression */
public protocol FilterStatement {
    
    /** Negate the statement (similar to the `!` operator) */
    func negated() -> Self
}

/** An expression comparing a property to a value */
internal enum Expression: FilterStatement {
    case equal(String, StorableValue?)
    case notEqual(String, StorableValue?)
    
    case less(String, StorableValue)
    case greaterOrEqual(String, StorableValue)
    
    case greater(String, StorableValue)
    case lessOrEqual(String, StorableValue)
    
    case containedIn(String, [StorableValue?])
    case notContainedIn(String, [StorableValue?])
    
    case between(String, StorableValue, StorableValue)
    case notBetween(String, StorableValue, StorableValue)
    
    case like(String, String)
    case notLike(String, String)
    
    func negated() -> Expression {
        switch self {
        case .equal(let property, let value):
            return .notEqual(property, value)
        case .notEqual(let property, let value):
            return .equal(property, value)
            
        case .less(let property, let value):
            return .greaterOrEqual(property, value)
        case .lessOrEqual(let property, let value):
            return .greater(property, value)
            
        case .greater(let property, let value):
            return .lessOrEqual(property, value)
        case .greaterOrEqual(let property, let value):
            return .less(property, value)
            
        case .containedIn(let property, let values):
            return .notContainedIn(property, values)
        case .notContainedIn(let property, let values):
            return .containedIn(property, values)
            
        case .between(let property, let value, let otherValue):
            return .notBetween(property, value, otherValue)
        case .notBetween(let property, let value, let otherValue):
            return .between(property, value, otherValue)
            
        case .like(let property, let pattern):
            return .notLike(property, pattern)
        case .notLike(let property, let pattern):
            return .like(property, pattern)
        }
    }
}

/** Combines two expressions or connectives */
internal enum Connective: FilterStatement {
    case conjunction(FilterStatement, FilterStatement)
    case disjunction(FilterStatement, FilterStatement)
    
    func negated() -> Connective {
        switch self {
        case .conjunction(let operand, let otherOperand):
            return .disjunction(operand.negated(), otherOperand.negated())
        case .disjunction(let operand, let otherOperand):
            return .conjunction(operand.negated(), otherOperand.negated())
        }
    }
}
