//
//  SQLiteFilterStatement.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 29/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

protocol SQLiteFilterStatement: FilterStatement {
    var statement: String { get }
    var parameters: [StoreableValue?] { get }
}

extension Expression: SQLiteFilterStatement {
    var statement: String {
        switch self {
        case .Equal(let property, _):
            return "\(property) = ?"
        case .NotEqual(let property, _):
            return "\(property) != ?"
            
        case .Less(let property, _):
            return "\(property) < ?"
        case LessOrEqual(let property, _):
            return "\(property) <= ?"
            
        case .Greater(let property, _):
            return "\(property) > ?"
        case .GreaterOrEqual(let property, _):
            return "\(property) >= ?"
            
        case .ContainedIn(let property, let values):
            let placeholders = values.map { _ in "?" }.joinWithSeparator(",")
            
            return "\(property) IN (\(placeholders))"
        case .NotContainedIn(let property, let values):
            let placeholders = values.map { _ in "?" }.joinWithSeparator(",")
            
            return "\(property) NOT IN (\(placeholders))"
            
        case .Between(let property, _, _):
            return "\(property) BETWEEN ? AND ?"
        case .NotBetween(let property, _, _):
            return "\(property) NOT BETWEEN ? AND ?"
            
        case .Like(let property, _):
            return "\(property) LIKE ?"
        case .NotLike(let property, _):
            return "\(property) NOT LIKE ?"
        }
    }
    
    var parameters: [StoreableValue?] {
        switch self {
        case .Equal(_, let value):
            return [value]
        case .NotEqual(_, let value):
            return [value]
            
        case .Less(_, let value):
            return [value]
        case LessOrEqual(_, let value):
            return [value]
            
        case .Greater(_, let value):
            return [value]
        case .GreaterOrEqual(_, let value):
            return [value]
            
        case .ContainedIn(_, let values):
            return values
        case .NotContainedIn(_, let values):
            return values
            
        case .Between(_, let lower, let upper):
            return [lower, upper]
        case .NotBetween(_, let lower, let upper):
            return [lower, upper]
            
        case .Like(_, let value):
            return [value]
        case .NotLike(_, let value):
            return [value]
        }
    }
}

extension Connective: SQLiteFilterStatement {
    var statement: String {
        switch self {
        case .Conjunction(let operand, let otherOperand):
            let operandExpression = (operand as! SQLiteFilterStatement).statement
            let otherOperandExpression = (otherOperand as! SQLiteFilterStatement).statement
            
            return "(\(operandExpression) AND \(otherOperandExpression))"
        case .Disjunction(let operand, let otherOperand):
            let operandExpression = (operand as! SQLiteFilterStatement).statement
            let otherOperandExpression = (otherOperand as! SQLiteFilterStatement).statement
            
            return "(\(operandExpression) OR \(otherOperandExpression))"
        }
    }
    
    var parameters: [StoreableValue?] {
        switch self {
        case .Conjunction(let operand, let otherOperand):
            let operandParameters = (operand as! SQLiteFilterStatement).parameters
            let otherOperandParameters = (otherOperand as! SQLiteFilterStatement).parameters
            
            return operandParameters + otherOperandParameters
        case .Disjunction(let operand, let otherOperand):
            let operandParameters = (operand as! SQLiteFilterStatement).parameters
            let otherOperandParameters = (otherOperand as! SQLiteFilterStatement).parameters
            
            return operandParameters + otherOperandParameters
        }
    }
}
