//
//  FilterOperatorsTest.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 28/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import Nimble

@testable import SwiftyDB


infix operator << {}


class FilterOperatorsTests: XCTestCase {
    
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
    
    
    func testEqualOperatorCreatesEqualExpressionWithTheProvidedValues() {
        let filter: FilterStatement = property == stringValue
        
        let expression = Expression.Equal(property, stringValue)
        
        expect(filter as? SwiftyDB.Expression).to(equal(expression))
    }
    
    func testNotEqualOperatorCreatesNotEqualExpressionWithTheProvidedValues() {
        let filter: FilterStatement = property != stringValue
        
        let expression = Expression.NotEqual(property, stringValue)
        
        expect(filter as? SwiftyDB.Expression).to(equal(expression))
    }
    
    func testLikeOperatorCreatesLikeExpressionWithTheProvidedValues() {
        let filter: FilterStatement = property ~= stringValue
        
        let expression = Expression.Like(property, stringValue)
        
        expect(filter as? SwiftyDB.Expression).to(equal(expression))
    }
    
    func testNotLikeOperatorCreatesNotLikeExpressionWithTheProvidedValues() {
        let filter: FilterStatement = property !~ stringValue
        
        let expression = Expression.NotLike(property, stringValue)
        
        expect(filter as? SwiftyDB.Expression).to(equal(expression))
    }
    
    func testLessThanOperatorCreatesLessThanExpressionWithTheProvidedValues() {
        let filter: FilterStatement = property < stringValue
        
        let expression = Expression.Less(property, stringValue)
        
        expect(filter as? SwiftyDB.Expression).to(equal(expression))
    }
    
    func testGreaterThanOperatorCreatesGreaterThanExpressionWithTheProvidedValues() {
        let filter: FilterStatement = property > stringValue
        
        let expression = Expression.Greater(property, stringValue)
        
        expect(filter as? SwiftyDB.Expression).to(equal(expression))
    }
    
    func testLessThanOrEqualOperatorCreatesLessThanOrEqualExpressionWithTheProvidedValues() {
        let filter: FilterStatement = property <= stringValue
        
        let expression = Expression.LessOrEqual(property, stringValue)
        
        expect(filter as? SwiftyDB.Expression).to(equal(expression))
    }
    
    func testGreaterThanOrEqualOperatorCreatesGreaterThanOrEqualExpressionWithTheProvidedValues() {
        let filter: FilterStatement = property >= stringValue
        
        let expression = Expression.GreaterOrEqual(property, stringValue)
        
        expect(filter as? SwiftyDB.Expression).to(equal(expression))
    }
    
    func testInOperatorCreatesBetweenExpressionForRanges() {
        let filter: FilterStatement = property << (intValue..<otherIntValue)
        
        let expression = Expression.Between(property, intValue, otherIntValue)
        
        expect(filter as? SwiftyDB.Expression).to(equal(expression))
    }
    
    func testNotInOperatorCreatesNotBetweenExpressionForRanges() {
        let filter: FilterStatement = property !< (intValue..<otherIntValue)
        
        let expression = Expression.NotBetween(property, intValue, otherIntValue)
        
        expect(filter as? SwiftyDB.Expression).to(equal(expression))
    }
    
    func testInOperatorCreatesInExpressionForArrays() {
        let filter: FilterStatement = property << [stringValue]
        
        let expression = Expression.ContainedIn(property, [stringValue])
        
        expect(filter as? SwiftyDB.Expression).to(equal(expression))
    }
    
    func testNotInOperatorCreatesNotInExpressionForArrays() {
        let filter: FilterStatement = property !< [stringValue]
        
        let expression = Expression.NotContainedIn(property, [stringValue])
        
        expect(filter as? SwiftyDB.Expression).to(equal(expression))
    }
    
    func testAndOperatorCreatesConjunction() {
        let expression: FilterStatement      = property != stringValue
        let otherExpression: FilterStatement = property == intValue
        
        let conjunction: FilterStatement = expression && otherExpression
        
        expect(self.isConjunction(conjunction as! Connective)).to(beTrue())
    }
    
    func testOrOperatorCreatedDisjunction() {
        let expression: FilterStatement      = property != stringValue
        let otherExpression: FilterStatement = property == intValue
        
        let disjunction: FilterStatement = expression || otherExpression
        
        expect(self.isConjunction(disjunction as! Connective)).to(beFalse())
    }
    
    func testAndOperatorIsEvaluatedBeforeOr() {
        let expression: FilterStatement      = property != stringValue
        let otherExpression: FilterStatement = property == intValue
        
        let disjunction: FilterStatement = expression && otherExpression || expression
        
        expect(self.isConjunction(disjunction as! Connective)).to(beFalse())
    }
    
    
    private func isConjunction(connective: Connective) -> Bool {
        switch connective {
        case .Conjunction:
            return true
        default:
            return false
        }
    }
}