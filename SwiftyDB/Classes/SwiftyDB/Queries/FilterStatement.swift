//
//  Query.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 21/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

public protocol FilterStatement {
    /** Negate the statement (similar to the `!` operator) */
    func negated() -> Self
}

/** An expression comparing a property to a value */
internal enum Expression: FilterStatement {
    case Equal(String, StoreableValue?)
    case NotEqual(String, StoreableValue?)
    
    case Less(String, StoreableValue)
    case GreaterOrEqual(String, StoreableValue)
    
    case Greater(String, StoreableValue)
    case LessOrEqual(String, StoreableValue)
    
    case ContainedIn(String, [StoreableValue?])
    case NotContainedIn(String, [StoreableValue?])
    
    case Between(String, StoreableValue, StoreableValue)
    case NotBetween(String, StoreableValue, StoreableValue)
    
    case Like(String, String)
    case NotLike(String, String)
    
    func negated() -> Expression {
        switch self {
        case .Equal(let property, let value):
            return .NotEqual(property, value)
        case .NotEqual(let property, let value):
            return .Equal(property, value)
            
        case .Less(let property, let value):
            return .GreaterOrEqual(property, value)
        case LessOrEqual(let property, let value):
            return .Greater(property, value)
            
        case .Greater(let property, let value):
            return .LessOrEqual(property, value)
        case .GreaterOrEqual(let property, let value):
            return .Less(property, value)
            
        case .ContainedIn(let property, let values):
            return .NotContainedIn(property, values)
        case .NotContainedIn(let property, let values):
            return .ContainedIn(property, values)
            
        case .Between(let property, let value, let otherValue):
            return .NotBetween(property, value, otherValue)
        case .NotBetween(let property, let value, let otherValue):
            return .Between(property, value, otherValue)
            
        case .Like(let property, let pattern):
            return .NotLike(property, pattern)
        case .NotLike(let property, let pattern):
            return .Like(property, pattern)
        }
    }
}

/** Combines two expressions or connectives */
internal enum Connective: FilterStatement {
    case Conjunction(FilterStatement, FilterStatement)
    case Disjunction(FilterStatement, FilterStatement)
    
    func negated() -> Connective {
        switch self {
        case .Conjunction(let operand, let otherOperand):
            return Connective.Disjunction(operand.negated(), otherOperand.negated())
        case .Disjunction(let operand, let otherOperand):
            return Connective.Conjunction(operand.negated(), otherOperand.negated())
        }
    }
}