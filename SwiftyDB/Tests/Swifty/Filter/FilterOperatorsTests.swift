//
//  FilterOperatorsTest.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 28/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest

@testable import SwiftyDB


infix operator <<


class FilterOperatorsTests: XCTestCase {
    
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
    
    
    func testEqualOperatorCreatesEqualExpressionWithTheProvidedValues() {
        let filter: FilterStatement = property == stringValue
        
        let expression = Expression.equal(property, stringValue)
        
        XCTAssert(filter as! SwiftyDB.Expression == expression)
    }
    
    func testNotEqualOperatorCreatesNotEqualExpressionWithTheProvidedValues() {
        let filter: FilterStatement = property != stringValue
        
        let expression = Expression.notEqual(property, stringValue)
        
        XCTAssert(filter as! SwiftyDB.Expression == expression)
    }
    
    func testLikeOperatorCreatesLikeExpressionWithTheProvidedValues() {
        let filter: FilterStatement = property ~= stringValue
        
        let expression = Expression.like(property, stringValue)
        
        XCTAssert(filter as! SwiftyDB.Expression == expression)
    }
    
    func testNotLikeOperatorCreatesNotLikeExpressionWithTheProvidedValues() {
        let filter: FilterStatement = property !~ stringValue
        
        let expression = Expression.notLike(property, stringValue)
        
        XCTAssert(filter as! SwiftyDB.Expression == expression)
    }
    
    func testLessThanOperatorCreatesLessThanExpressionWithTheProvidedValues() {
        let filter: FilterStatement = property < stringValue
        
        let expression = Expression.less(property, stringValue)
        
        XCTAssert(filter as! SwiftyDB.Expression == expression)
    }
    
    func testGreaterThanOperatorCreatesGreaterThanExpressionWithTheProvidedValues() {
        let filter: FilterStatement = property > stringValue
        
        let expression = Expression.greater(property, stringValue)
        
        XCTAssert(filter as! SwiftyDB.Expression == expression)
    }
    
    func testLessThanOrEqualOperatorCreatesLessThanOrEqualExpressionWithTheProvidedValues() {
        let filter: FilterStatement = property <= stringValue
        
        let expression = Expression.lessOrEqual(property, stringValue)
        
        XCTAssert(filter as! SwiftyDB.Expression == expression)
    }
    
    func testGreaterThanOrEqualOperatorCreatesGreaterThanOrEqualExpressionWithTheProvidedValues() {
        let filter: FilterStatement = property >= stringValue
        
        let expression = Expression.greaterOrEqual(property, stringValue)
        
        XCTAssert(filter as! SwiftyDB.Expression == expression)
    }
    
    func testInOperatorCreatesBetweenExpressionForRanges() {
        let filter: FilterStatement = property << (intValue..<otherIntValue)
        
        let expression = Expression.between(property, intValue, otherIntValue)
        
        XCTAssert(filter as! SwiftyDB.Expression == expression)
    }
    
    func testNotInOperatorCreatesNotBetweenExpressionForRanges() {
        let filter: FilterStatement = property !< (intValue..<otherIntValue)
        
        let expression = Expression.notBetween(property, intValue, otherIntValue)
        
        XCTAssert(filter as! SwiftyDB.Expression == expression)
    }
    
    func testInOperatorCreatesInExpressionForArrays() {
        let filter: FilterStatement = property << [stringValue]
        
        let expression = Expression.containedIn(property, [stringValue])
        
        XCTAssert(filter as! SwiftyDB.Expression == expression)
    }
    
    func testNotInOperatorCreatesNotInExpressionForArrays() {
        let filter: FilterStatement = property !< [stringValue]
        
        let expression = Expression.notContainedIn(property, [stringValue])
        
        XCTAssert(filter as! SwiftyDB.Expression == expression)
    }
    
    func testAndOperatorCreatesConjunction() {
        let expression: FilterStatement      = property != stringValue
        let otherExpression: FilterStatement = property == intValue
        
        let conjunction: FilterStatement = expression && otherExpression
        
        XCTAssert(self.isConjunction(conjunction as! Connective))
    }
    
    func testOrOperatorCreatedDisjunction() {
        let expression: FilterStatement      = property != stringValue
        let otherExpression: FilterStatement = property == intValue
        
        let disjunction: FilterStatement = expression || otherExpression
        
        XCTAssert(!self.isConjunction(disjunction as! Connective))
    }
    
    func testAndOperatorIsEvaluatedBeforeOr() {
        let expression: FilterStatement      = property != stringValue
        let otherExpression: FilterStatement = property == intValue
        
        let disjunction: FilterStatement = expression && otherExpression || expression
        
        XCTAssert(!self.isConjunction(disjunction as! Connective))
    }
    
    
    fileprivate func isConjunction(_ connective: Connective) -> Bool {
        switch connective {
        case .conjunction:
            return true
        default:
            return false
        }
    }
}
