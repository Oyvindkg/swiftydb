//
//  Expression.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 29/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest

@testable import SwiftyDB


class ExpressionTests: XCTestCase {
    fileprivate let property             = "name"
    fileprivate let stringValue          = "John"
    fileprivate let intValue: Int64      = 0
    fileprivate let otherIntValue: Int64 = 10
    
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testEqualNegationIsNotEqual() {
        let equal = Expression.equal(property, intValue)
        
        if case .notEqual(let negatedProperty, let negatedValue) = equal.negated() {
            XCTAssertEqual(negatedProperty, property)
            XCTAssertEqual(negatedValue as! Int64, intValue)
        } else {
            XCTFail()
        }
    }
    
    func testNotEqualNegationIsEqual() {
        let notEqual = Expression.notEqual(property, intValue)
        
        if case .equal(let negatedProperty, let negatedValue) = notEqual.negated() {
            XCTAssertEqual(negatedProperty, property)
            XCTAssertEqual(negatedValue as! Int64, intValue)
        } else {
            XCTFail()
        }
    }
    
    func testLessNegationIsGreaterOrEqual() {
        let less = Expression.less(property, intValue)
        
        if case .greaterOrEqual(let negatedProperty, let negatedValue) = less.negated() {
            XCTAssertEqual(negatedProperty, property)
            XCTAssertEqual(negatedValue as! Int64, intValue)
        } else {
            XCTFail()
        }
    }
    
    func testGreaterNegationIsLessOrEqual() {
        let greater = Expression.greater(property, intValue)
        
        if case .lessOrEqual(let negatedProperty, let negatedValue) = greater.negated() {
            XCTAssertEqual(negatedProperty, property)
            XCTAssertEqual(negatedValue as! Int64, intValue)
        } else {
            XCTFail()
        }
    }
    
    func testLessOrEqualNegationIsGreater() {
        let lessOrEqual = Expression.lessOrEqual(property, intValue)
        
        if case .greater(let negatedProperty, let negatedValue) = lessOrEqual.negated() {
            XCTAssertEqual(negatedProperty, property)
            XCTAssertEqual(negatedValue as! Int64, intValue)
        } else {
            XCTFail()
        }
    }
    
    func testGreaterOrEqualNegationIsLess() {
        let greaterOrEqual = Expression.greaterOrEqual(property, intValue)
        
        if case .less(let negatedProperty, let negatedValue) = greaterOrEqual.negated() {
            XCTAssertEqual(negatedProperty, property)
            XCTAssertEqual(negatedValue as! Int64, intValue)
        } else {
            XCTFail()
        }
    }
    
    func testContainedInNegationIsNotContainedIn() {
        let containedIn = Expression.containedIn(property, [intValue])
        
        if case .notContainedIn(let negatedProperty, let negatedValue) = containedIn.negated() {
            XCTAssertEqual(negatedProperty, property)
            XCTAssertEqual(negatedValue as! [Int64], [intValue])
        } else {
            XCTFail()
        }
    }
    
    func testNotContainedInNegationIsContainedIn() {
        let notContainedIn = Expression.notContainedIn(property, [intValue])
        
        if case .containedIn(let negatedProperty, let negatedValue) = notContainedIn.negated() {
            XCTAssertEqual(negatedProperty, property)
            XCTAssertEqual(negatedValue as! [Int64], [intValue])
        } else {
            XCTFail()
        }
    }
    
    func testBetweenNegationIsNotBetween() {
        let between = Expression.between(property, intValue, otherIntValue)
        
        if case .notBetween(let negatedProperty, let minNegatedValue, let maxNegatedValue) = between.negated() {
            XCTAssertEqual(negatedProperty, property)
            XCTAssertEqual(minNegatedValue as! Int64, intValue)
            XCTAssertEqual(maxNegatedValue as! Int64, otherIntValue)
        } else {
            XCTFail()
        }
    }
    
    func testNotBetweenNegationIsBetween() {
        let notBetween = Expression.notBetween(property, intValue, otherIntValue)
        
        if case .between(let negatedProperty, let minNegatedValue, let maxNegatedValue) = notBetween.negated() {
            XCTAssertEqual(negatedProperty, property)
            XCTAssertEqual(minNegatedValue as! Int64, intValue)
            XCTAssertEqual(maxNegatedValue as! Int64, otherIntValue)
        } else {
            XCTFail()
        }
    }
    
    func testLikeNegationIsNotLike() {
        let like = Expression.like(property, stringValue)
        
        if case .notLike(let negatedProperty, let negatedPattern) = like.negated() {
            XCTAssertEqual(negatedProperty, property)
            XCTAssertEqual(negatedPattern, stringValue)
        } else {
            XCTFail()
        }
    }
    
    func testNotLikeNegationIsLike() {
        let notLike = Expression.notLike(property, stringValue)
        
        if case .like(let negatedProperty, let negatedPattern) = notLike.negated() {
            XCTAssertEqual(negatedProperty, property)
            XCTAssertEqual(negatedPattern, stringValue)
        } else {
            XCTFail()
        }
    }
}
