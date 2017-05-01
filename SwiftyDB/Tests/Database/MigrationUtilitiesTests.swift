//
//  MigrationUtilitiesTests.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 01/05/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import Nimble

@testable import SwiftyDB

public class MigrationUtilitiesTests: XCTestCase {
    
    func testTypeInformationContainsCorrectProperties() {
        
        let information = MigrationUtilities.typeInformationFor(type: Stark.self)
        
        expect(information.properties).to(contain("name", "age", "weight", "wolf", "siblings"))
        expect(information.properties).to(haveCount(5))
    }
    
    func testTypeInformationContainsIdentifier() {
        let information = MigrationUtilities.typeInformationFor(type: Stark.self)
        
        expect(information.identifierName) == "name"
    }
    
    func testTypeInformationContainsCorrectName() {
        let information = MigrationUtilities.typeInformationFor(type: Stark.self)
        
        expect(information.name) == "Stark"
    }
    
    func testPropertiesAreCorrect() {
        let properties = MigrationUtilities.properties(for: Stark.self)
        
        expect(properties).to(contain("name", "age", "weight", "wolf", "siblings"))
        expect(properties).to(haveCount(5))
    }
    
    func testSameTypeInformationIsEqual() {
        let information = MigrationUtilities.typeInformationFor(type: Stark.self)
        
        expect(information) == information
    }
    
    func testTypeInformationWithDifferentNameIsNotEqual() {
        var information = MigrationUtilities.typeInformationFor(type: Stark.self)
        
        information.name = "Something else"
        
        expect(information) != MigrationUtilities.typeInformationFor(type: Stark.self)
    }
    
    func testTypeInformationWithDifferentPropertiesIsNotEqual() {
        var information = MigrationUtilities.typeInformationFor(type: Stark.self)
        
        information.properties = ["Something else"]
        
        expect(information) != MigrationUtilities.typeInformationFor(type: Stark.self)
    }
    
    func testTypeInformationWithDifferentIdentifierNameIsNotEqual() {
        var information = MigrationUtilities.typeInformationFor(type: Stark.self)
        
        information.identifierName = "Something else"
        
        expect(information) != MigrationUtilities.typeInformationFor(type: Stark.self)
    }
}
