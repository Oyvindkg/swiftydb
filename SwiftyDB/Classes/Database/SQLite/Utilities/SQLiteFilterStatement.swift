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
    var parameters: [StorableValue?] { get }
}

extension Expression: SQLiteFilterStatement {
    var statement: String {
        switch self {
        case .equal(let property, _):
            return "\(property) = ?"
        case .notEqual(let property, _):
            return "\(property) != ?"
            
        case .less(let property, _):
            return "\(property) < ?"
        case .lessOrEqual(let property, _):
            return "\(property) <= ?"
            
        case .greater(let property, _):
            return "\(property) > ?"
        case .greaterOrEqual(let property, _):
            return "\(property) >= ?"
            
        case .containedIn(let property, let values):
            let placeholders = values.map { _ in "?" }.joinWithSeparator(",")
            
            return "\(property) IN (\(placeholders))"
        case .notContainedIn(let property, let values):
            let placeholders = values.map { _ in "?" }.joinWithSeparator(",")
            
            return "\(property) NOT IN (\(placeholders))"
            
        case .between(let property, _, _):
            return "\(property) BETWEEN ? AND ?"
        case .notBetween(let property, _, _):
            return "\(property) NOT BETWEEN ? AND ?"
            
        case .like(let property, _):
            return "\(property) LIKE ?"
        case .notLike(let property, _):
            return "\(property) NOT LIKE ?"
        }
    }
    
    var parameters: [StorableValue?] {
        switch self {
        case .equal(_, let value):
            return [value]
        case .notEqual(_, let value):
            return [value]
            
        case .less(_, let value):
            return [value]
        case .lessOrEqual(_, let value):
            return [value]
            
        case .greater(_, let value):
            return [value]
        case .greaterOrEqual(_, let value):
            return [value]
            
        case .containedIn(_, let values):
            return values
        case .notContainedIn(_, let values):
            return values
            
        case .between(_, let lower, let upper):
            return [lower, upper]
        case .notBetween(_, let lower, let upper):
            return [lower, upper]
            
        case .like(_, let value):
            return [value]
        case .notLike(_, let value):
            return [value]
        }
    }
}

extension Connective: SQLiteFilterStatement {
    var statement: String {
        switch self {
        case .conjunction(let operand, let otherOperand):
            let operandExpression = (operand as! SQLiteFilterStatement).statement
            let otherOperandExpression = (otherOperand as! SQLiteFilterStatement).statement
            
            return "(\(operandExpression) AND \(otherOperandExpression))"
        case .disjunction(let operand, let otherOperand):
            let operandExpression = (operand as! SQLiteFilterStatement).statement
            let otherOperandExpression = (otherOperand as! SQLiteFilterStatement).statement
            
            return "(\(operandExpression) OR \(otherOperandExpression))"
        }
    }
    
    var parameters: [StorableValue?] {
        switch self {
        case .conjunction(let operand, let otherOperand):
            let operandParameters = (operand as! SQLiteFilterStatement).parameters
            let otherOperandParameters = (otherOperand as! SQLiteFilterStatement).parameters
            
            return operandParameters + otherOperandParameters
        case .disjunction(let operand, let otherOperand):
            let operandParameters = (operand as! SQLiteFilterStatement).parameters
            let otherOperandParameters = (otherOperand as! SQLiteFilterStatement).parameters
            
            return operandParameters + otherOperandParameters
        }
    }
}
