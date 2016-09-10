//
//  Equatable.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 28/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

@testable import SwiftyDB

func ==(left: StoreableValue?, right: StoreableValue?) -> Bool {
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
    case (.Equal(let property, let value), .Equal(let otherProperty, let otherValue)):
        return property == otherProperty && value == otherValue
    case (.NotEqual(let property, let value), .NotEqual(let otherProperty, let otherValue)):
        return property == otherProperty && value == otherValue
    case (.Less(let property, let value), .Less(let otherProperty, let otherValue)):
        return property == otherProperty && value == otherValue
    case (.LessOrEqual(let property, let value), .LessOrEqual(let otherProperty, let otherValue)):
        return property == otherProperty && value == otherValue
    case (.Greater(let property, let value), .Greater(let otherProperty, let otherValue)):
        return property == otherProperty && value == otherValue
    case (.GreaterOrEqual(let property, let value), .GreaterOrEqual(let otherProperty, let otherValue)):
        return property == otherProperty && value == otherValue
    case (.ContainedIn(let property, let values), .ContainedIn(let otherProperty, let otherValues)):
        return property == otherProperty && values.elementsEqual(otherValues, isEquivalent: ==)
    case (.NotContainedIn(let property, let values), .NotContainedIn(let otherProperty, let otherValues)):
        return property == otherProperty && values.elementsEqual(otherValues, isEquivalent: ==)
    case (.Between(let property, let lower, let upper), .Between(let otherProperty, let otherLower, let otherUpper)):
        return property == otherProperty && lower == otherLower && upper == otherUpper
    case (.NotBetween(let property, let lower, let upper), .NotBetween(let otherProperty, let otherLower, let otherUpper)):
        return property == otherProperty && lower == otherLower && upper == otherUpper
    case (.Like(let property, let value), .Like(let otherProperty, let otherValue)):
        return property == otherProperty && value == otherValue
    case (.NotLike(let property, let value), .NotLike(let otherProperty, let otherValue)):
        return property == otherProperty && value == otherValue
    default:
        return false
    }
}

extension Expression: Equatable {}
