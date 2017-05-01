//
//  SQLiteFilterStatement.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 29/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

extension StorableValue {
    var literalValue: String {
        switch self {
        case is String:
            return "'\(self)'"
        case is Double, is Int:
            return "\(self)"
        default:
            return "NULL"
        }
    }
}

protocol SQLiteFilterStatement: FilterStatement {
    
    /** A parameterized statement */
    var statement: String { get }
    
    /** Parameter values for the parameterized `statement`*/
    var parameters: [StorableValue?] { get }

    /** A statement without parameters. Some operations, such as creating indices, does not support parameters. */
    var deparameterizedStatement: String { get }
}

extension Expression: SQLiteFilterStatement {
    
    var statement: String {
        switch self {
        case .equal(let property, _):
            return "\"\(property)\" = ?"
        case .notEqual(let property, _):
            return "\"\(property)\" != ?"
            
        case .less(let property, _):
            return "\"\(property)\" < ?"
        case .lessOrEqual(let property, _):
            return "\"\(property)\" <= ?"
            
        case .greater(let property, _):
            return "\"\(property)\" > ?"
        case .greaterOrEqual(let property, _):
            return "\"\(property)\" >= ?"
            
        case .containedIn(let property, let values):
            let placeholders = values.map { _ in "?" }.joined(separator: ",")
            
            return "\"\(property) IN (\(placeholders))"
        case .notContainedIn(let property, let values):
            let placeholders = values.map { _ in "?" }.joined(separator: ",")
            
            return "\"\(property)\" NOT IN (\(placeholders))"
            
        case .between(let property, _, _):
            return "\"\(property)\" BETWEEN ? AND ?"
        case .notBetween(let property, _, _):
            return "\(property)\" NOT BETWEEN ? AND ?"
            
        case .like(let property, _):
            return "\"\(property)\" LIKE ?"
        case .notLike(let property, _):
            return "\"\(property)\" NOT LIKE ?"
        }
    }
    
    var deparameterizedStatement: String {
        switch self {
        case .equal(let property, let value):
            return "\"\(property)\" = \(value?.literalValue ?? "NULL")"
        case .notEqual(let property, let value):
            return "\"\(property)\" != \(value?.literalValue ?? "NULL")"
            
        case .less(let property, let value):
            return "\"\(property)\" < \(value.literalValue)"
        case .lessOrEqual(let property, let value):
            return "\"\(property)\" <= \(value.literalValue)"
            
        case .greater(let property, let value):
            return "\"\(property)\" > \(value.literalValue)"
        case .greaterOrEqual(let property, let value):
            return "\"\(property)\" >= \(value.literalValue)"
            
        case .containedIn(let property, let values):
            let placeholders = values.map { $0?.literalValue ?? "NULL" }.joined(separator: ",")
            
            return "\"\(property)\" IN (\(placeholders))"
        case .notContainedIn(let property, let values):
            let placeholders = values.map { $0?.literalValue ?? "NULL" }.joined(separator: ",")
            
            return "\"\(property)\" NOT IN (\(placeholders))"
            
        case .between(let property, let value, let otherValue):
            return "\"\(property)\" BETWEEN \(value.literalValue) AND \(otherValue.literalValue)"
        case .notBetween(let property, let value, let otherValue):
            return "\"\(property)\" NOT BETWEEN \(value.literalValue) AND \(otherValue.literalValue)"
            
        case .like(let property, let value):
            return "\"\(property)\" LIKE \(value.literalValue)"
        case .notLike(let property, let value):
            return "\"\(property)\" NOT LIKE \(value.literalValue)"
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
    
    var deparameterizedStatement: String {
        switch self {
        case .conjunction(let operand, let otherOperand):
            let operandExpression = (operand as! SQLiteFilterStatement).deparameterizedStatement
            let otherOperandExpression = (otherOperand as! SQLiteFilterStatement).deparameterizedStatement
            
            return "(\(operandExpression) AND \(otherOperandExpression))"
        case .disjunction(let operand, let otherOperand):
            let operandExpression = (operand as! SQLiteFilterStatement).deparameterizedStatement
            let otherOperandExpression = (otherOperand as! SQLiteFilterStatement).deparameterizedStatement
            
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
