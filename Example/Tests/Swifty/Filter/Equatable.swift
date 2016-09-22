//
//  Equatable.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 28/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

@testable import SwiftyDB

func ==(left: StorableValue?, right: StorableValue?) -> Bool {
    if let leftString = left as? String {
        if let rightString = right as? String {
            return leftString == rightString
        }
        
        return false
    }
    
    if let leftInt = left as? Int64 {
        if let rightInt = right as? Int64 {
            return leftInt == rightInt
        }
        
        return false
    }
    
    if let leftDouble = left as? Double {
        if let rightDouble = right as? Double {
            return leftDouble == rightDouble
        }
        
        return false
    }
    
    return left == nil && right == nil
}

func ==(left: Expression, right: Expression) -> Bool {
    switch (left, right) {
    case (.equal(let property, let value), .equal(let otherProperty, let otherValue)):
        return property == otherProperty && value == otherValue
        
    case (.notEqual(let property, let value), .notEqual(let otherProperty, let otherValue)):
        return property == otherProperty && value == otherValue
        
    case (.less(let property, let value), .less(let otherProperty, let otherValue)):
        return property == otherProperty && value == otherValue
        
    case (.lessOrEqual(let property, let value), .lessOrEqual(let otherProperty, let otherValue)):
        return property == otherProperty && value == otherValue
        
    case (.greater(let property, let value), .greater(let otherProperty, let otherValue)):
        return property == otherProperty && value == otherValue
        
    case (.greaterOrEqual(let property, let value), .greaterOrEqual(let otherProperty, let otherValue)):
        return property == otherProperty && value == otherValue
        
    case (.containedIn(let property, let values), .containedIn(let otherProperty, let otherValues)):
        return property == otherProperty && values.elementsEqual(otherValues, isEquivalent: ==)
        
    case (.notContainedIn(let property, let values), .notContainedIn(let otherProperty, let otherValues)):
        return property == otherProperty && values.elementsEqual(otherValues, isEquivalent: ==)
        
    case (.between(let property, let lower, let upper), .between(let otherProperty, let otherLower, let otherUpper)):
        return property == otherProperty && lower == otherLower && upper == otherUpper
        
    case (.notBetween(let property, let lower, let upper), .notBetween(let otherProperty, let otherLower, let otherUpper)):
        return property == otherProperty && lower == otherLower && upper == otherUpper
        
    case (.like(let property, let value), .like(let otherProperty, let otherValue)):
        return property == otherProperty && value == otherValue
        
    case (.notLike(let property, let value), .notLike(let otherProperty, let otherValue)):
        return property == otherProperty && value == otherValue
    default:
        return false
    }
}

extension Expression: Equatable {}
