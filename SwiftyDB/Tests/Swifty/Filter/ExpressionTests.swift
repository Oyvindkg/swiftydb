//
//  Expression.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 29/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import Nimble

@testable import SwiftyDB


class ExpressionTests: XCTestCase {
    fileprivate let property      = "name"
    fileprivate let stringValue   = "John"
    fileprivate let intValue      = 0
    fileprivate let otherIntValue = 10
    
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testEqualNegationIsNotEqual() {
        let equal = Expression.equal(property, intValue)
        
        if case .notEqual(let negatedProperty, let negatedValue) = equal.negated() {
            expect(negatedProperty) == property
            expect(negatedValue as? Int) == intValue
        } else {
            fail()
        }
    }
    
    func testNotEqualNegationIsEqual() {
        let notEqual = Expression.notEqual(property, intValue)
        
        if case .equal(let negatedProperty, let negatedValue) = notEqual.negated() {
            expect(negatedProperty) == property
            expect(negatedValue as? Int) == intValue
        } else {
            fail()
        }
    }
    
    func testLessNegationIsGreaterOrEqual() {
        let less = Expression.less(property, intValue)
        
        if case .greaterOrEqual(let negatedProperty, let negatedValue) = less.negated() {
            expect(negatedProperty) == property
            expect(negatedValue as? Int) == intValue
        } else {
            fail()
        }
    }
    
    func testGreaterNegationIsLessOrEqual() {
        let greater = Expression.greater(property, intValue)
        
        if case .lessOrEqual(let negatedProperty, let negatedValue) = greater.negated() {
            expect(negatedProperty) == property
            expect(negatedValue as? Int) == intValue
        } else {
            fail()
        }
    }
    
    func testLessOrEqualNegationIsGreater() {
        let lessOrEqual = Expression.lessOrEqual(property, intValue)
        
        if case .greater(let negatedProperty, let negatedValue) = lessOrEqual.negated() {
            expect(negatedProperty) == property
            expect(negatedValue as? Int) == intValue
        } else {
            fail()
        }
    }
    
    func testGreaterOrEqualNegationIsLess() {
        let greaterOrEqual = Expression.greaterOrEqual(property, intValue)
        
        if case .less(let negatedProperty, let negatedValue) = greaterOrEqual.negated() {
            expect(negatedProperty) == property
            expect(negatedValue as? Int) == intValue
        } else {
            fail()
        }
    }
    
    func testContainedInNegationIsNotContainedIn() {
        let containedIn = Expression.containedIn(property, [intValue])
        
        if case .notContainedIn(let negatedProperty, let negatedValue) = containedIn.negated() {
            expect(negatedProperty) == property
            expect(negatedValue as? [Int]) == [intValue]
        } else {
            fail()
        }
    }
    
    func testNotContainedInNegationIsContainedIn() {
        let notContainedIn = Expression.notContainedIn(property, [intValue])
        
        if case .containedIn(let negatedProperty, let negatedValue) = notContainedIn.negated() {
            expect(negatedProperty) == property
            expect(negatedValue as? [Int]) == [intValue]
        } else {
            fail()
        }
    }
    
    func testBetweenNegationIsNotBetween() {
        let between = Expression.between(property, intValue, otherIntValue)
        
        if case .notBetween(let negatedProperty, let minNegatedValue, let maxNegatedValue) = between.negated() {
            expect(negatedProperty) == property
            expect(minNegatedValue as? Int) == intValue
            expect(maxNegatedValue as? Int) == otherIntValue
        } else {
            fail()
        }
    }
    
    func testNotBetweenNegationIsBetween() {
        let notBetween = Expression.notBetween(property, intValue, otherIntValue)
        
        if case .between(let negatedProperty, let minNegatedValue, let maxNegatedValue) = notBetween.negated() {
            expect(negatedProperty) == property
            expect(minNegatedValue as? Int) == intValue
            expect(maxNegatedValue as? Int) == otherIntValue
        } else {
            fail()
        }
    }
    
    func testLikeNegationIsNotLike() {
        let like = Expression.like(property, stringValue)
        
        if case .notLike(let negatedProperty, let negatedPattern) = like.negated() {
            expect(negatedProperty) == property
            expect(negatedPattern) == stringValue
        } else {
            fail()
        }
    }
    
    func testNotLikeNegationIsLike() {
        let notLike = Expression.notLike(property, stringValue)
        
        if case .like(let negatedProperty, let negatedPattern) = notLike.negated() {
            expect(negatedProperty) == property
            expect(negatedPattern) == stringValue
        } else {
            fail()
        }
    }
}
