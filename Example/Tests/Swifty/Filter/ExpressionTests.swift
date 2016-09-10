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
    private let property             = "name"
    private let stringValue          = "John"
    private let intValue: Int64      = 0
    private let otherIntValue: Int64 = 10
    
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testEqualNegationIsNotEqual() {
        let equal: SwiftyDB.Expression = .Equal(property, intValue)
        
        if case .NotEqual(_,_) = equal.negated() {
            return
        }
        
        fail()
    }
    
    func testNotEqualNegationIsEqual() {
        let equal: SwiftyDB.Expression = .NotEqual(property, intValue)
        
        if case .Equal(_,_) = equal.negated() {
            return
        }
        
        fail()
    }
    
    func testLessNegationIsGreaterOrEqual() {
        let equal: SwiftyDB.Expression = .Less(property, intValue)
        
        if case .GreaterOrEqual(_,_) = equal.negated() {
            return
        }
        
        fail()
    }
    
    func testGreaterNegationIsLessOrEqual() {
        let equal: SwiftyDB.Expression = .Greater(property, intValue)
        
        if case .LessOrEqual(_,_) = equal.negated() {
            return
        }
        
        fail()
    }
    
    func testLessOrEqualNegationIsGreater() {
        let equal: SwiftyDB.Expression = .LessOrEqual(property, intValue)
        
        if case .Greater(_,_) = equal.negated() {
            return
        }
        
        fail()
    }
    
    func testGreaterOrEqualNegationIsLess() {
        let equal: SwiftyDB.Expression = .GreaterOrEqual(property, intValue)
        
        if case .Less(_,_) = equal.negated() {
            return
        }
        
        fail()
    }
    
    func testContainedInNegationIsNotContainedIn() {
        let equal: SwiftyDB.Expression = .ContainedIn(property, [intValue])
        
        if case .NotContainedIn(_,_) = equal.negated() {
            return
        }
        
        fail()
    }
    
    func testNotContainedInNegationIsContainedIn() {
        let equal: SwiftyDB.Expression = .NotContainedIn(property, [intValue])
        
        if case .ContainedIn(_,_) = equal.negated() {
            return
        }
        
        fail()
    }
    
    func testBetweenNegationIsNotBetween() {
        let equal: SwiftyDB.Expression = .Between(property, intValue, otherIntValue)
        
        if case .NotBetween(_,_,_) = equal.negated() {
            return
        }
        
        fail()
    }
    
    func testNotBetweenNegationIsBetween() {
        let equal: SwiftyDB.Expression = .NotBetween(property, intValue, otherIntValue)
        
        if case .Between(_,_,_) = equal.negated() {
            return
        }
        
        fail()
    }
    
    func testLikeNegationIsNotLike() {
        let equal: SwiftyDB.Expression = .Like(property, stringValue)
        
        if case .NotLike(_,_) = equal.negated() {
            return
        }
        
        fail()
    }
    
    func testNotLikeNegationIsLike() {
        let equal: SwiftyDB.Expression = .NotLike(property, stringValue)
        
        if case .Like(_,_) = equal.negated() {
            return
        }
        
        fail()
    }
}