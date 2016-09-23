//
//  Expression.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 29/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest

@testable import SwiftyDB

func fail() {
    XCTAssert(false)
}

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
        
        if case .notEqual(_,_) = equal.negated() {
            return
        }
        
        fail()
    }
    
    func testNotEqualNegationIsEqual() {
        let equal = Expression.notEqual(property, intValue)
        
        if case .equal(_,_) = equal.negated() {
            return
        }
        
        fail()
    }
    
    func testLessNegationIsGreaterOrEqual() {
        let equal = Expression.less(property, intValue)
        
        if case .greaterOrEqual(_,_) = equal.negated() {
            return
        }
        
        fail()
    }
    
    func testGreaterNegationIsLessOrEqual() {
        let equal = Expression.greater(property, intValue)
        
        if case .lessOrEqual(_,_) = equal.negated() {
            return
        }
        
        fail()
    }
    
    func testLessOrEqualNegationIsGreater() {
        let equal = Expression.lessOrEqual(property, intValue)
        
        if case .greater(_,_) = equal.negated() {
            return
        }
        
        fail()
    }
    
    func testGreaterOrEqualNegationIsLess() {
        let equal = Expression.greaterOrEqual(property, intValue)
        
        if case .less(_,_) = equal.negated() {
            return
        }
        
        fail()
    }
    
    func testContainedInNegationIsNotContainedIn() {
        let equal = Expression.containedIn(property, [intValue])
        
        if case .notContainedIn(_,_) = equal.negated() {
            return
        }
        
        fail()
    }
    
    func testNotContainedInNegationIsContainedIn() {
        let equal = Expression.notContainedIn(property, [intValue])
        
        if case .containedIn(_,_) = equal.negated() {
            return
        }
        
        fail()
    }
    
    func testBetweenNegationIsNotBetween() {
        let equal = Expression.between(property, intValue, otherIntValue)
        
        if case .notBetween(_,_,_) = equal.negated() {
            return
        }
        
        fail()
    }
    
    func testNotBetweenNegationIsBetween() {
        let equal = Expression.notBetween(property, intValue, otherIntValue)
        
        if case .between(_,_,_) = equal.negated() {
            return
        }
        
        fail()
    }
    
    func testLikeNegationIsNotLike() {
        let equal = Expression.like(property, stringValue)
        
        if case .notLike(_,_) = equal.negated() {
            return
        }
        
        fail()
    }
    
    func testNotLikeNegationIsLike() {
        let equal = Expression.notLike(property, stringValue)
        
        if case .like(_,_) = equal.negated() {
            return
        }
        
        fail()
    }
}
