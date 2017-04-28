//
//  ConnectivesTests.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 28/04/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import Nimble

@testable import SwiftyDB

public class ConnectivesTests: XCTestCase {
    
    func testNegatedConjunctionIsADisjunctionOfTheNegatedOperands() {
        let statement: FilterStatement        = "age" == 11 && "name" == "Arya"
        let negatedStatement: FilterStatement = "age" != 11 || "name" != "Arya"
        
        expect(statement.negated() as? Connective) == negatedStatement as! Connective
    }
    
    func testNegatedDisjunctionIsAConjunctionOfTheNegatedOperands() {
        let statement: FilterStatement        = "age" != 11 || "name" != "Arya"
        let negatedStatement: FilterStatement = "age" == 11 && "name" == "Arya"
        
        expect(statement.negated() as? Connective) == negatedStatement as! Connective
    }
}


extension Connective: Equatable {}

public func ==(lhs: Connective, rhs: Connective) -> Bool {
    return lhs.deparameterizedStatement == rhs.deparameterizedStatement
}
