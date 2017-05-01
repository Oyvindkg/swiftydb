//
//  ReaderOperatorTests.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 01/05/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import Nimble

@testable import SwiftyDB

public class ReaderOperatorTests: XCTestCase {
    
    var reader: Reader!
    
    public override func setUp() {
        super.setUp()
    
        reader = Reader(type: Stark.self)
    }
    
    public override func tearDown() {
        reader = nil
        
        super.tearDown()
    }
    
    func testValueOperatorsUpdateReader() {
        
        var name: String           = "Arya"
        var optionalName: String?  = "Arya"
        var unwrappedName: String! = "Arya"

        name          <- reader["name"]
        optionalName  <- reader["optionalName"]
        unwrappedName <- reader["unwrappedName"]
        
        expect(self.reader.storableValues["name"] as? String) == name
        expect(self.reader.storableValues["optionalName"] as? String) == optionalName
        expect(self.reader.storableValues["unwrappedName"] as? String) == unwrappedName
        expect(self.reader.propertyTypes).to(haveCount(3))
    }
    
    func testNilValuesDoesNotUpdateReaderValues() {
        
        var optionalName: String?
        var unwrappedName: String!
        
        optionalName  <- reader["optionalName"]
        unwrappedName <- reader["unwrappedName"]
        
        expect(self.reader.storableValues).to(haveCount(0))
        expect(self.reader.propertyTypes).to(haveCount(2))
    }
    
    func testValueArrayOperatorsUpdateReader() {
        var names: [String]           = ["Arya"]
        var optionalNames: [String]?  = ["Arya"]
        var unwrappedNames: [String]! = ["Arya"]
        
        names          <- reader["names"]
        optionalNames  <- reader["optionalNames"]
        unwrappedNames <- reader["unwrappedNames"]
        
        expect(self.reader.storableValues["names"] as? String) == "[\"Arya\"]"
        expect(self.reader.storableValues["optionalNames"] as? String) == "[\"Arya\"]"
        expect(self.reader.storableValues["unwrappedNames"] as? String) == "[\"Arya\"]"
        expect(self.reader.propertyTypes).to(haveCount(3))
    }
    
    func testValueSetOperatorsUpdateReader() {
        var names: Set<String>           = ["Arya"]
        var optionalNames: Set<String>?  = ["Arya"]
        var unwrappedNames: Set<String>! = ["Arya"]
        
        names          <- reader["names"]
        optionalNames  <- reader["optionalNames"]
        unwrappedNames <- reader["unwrappedNames"]
        
        expect(self.reader.storableValues["names"] as? String) == "[\"Arya\"]"
        expect(self.reader.storableValues["optionalNames"] as? String) == "[\"Arya\"]"
        expect(self.reader.storableValues["unwrappedNames"] as? String) == "[\"Arya\"]"
        expect(self.reader.propertyTypes).to(haveCount(3))
    }
    
    func testValueDictionaryOperatorsUpdateReader() {
        var names: [String: String]           = ["name": "Arya"]
        var optionalNames: [String: String]?  = ["name": "Arya"]
        var unwrappedNames: [String: String]! = ["name": "Arya"]
        
        names          <- reader["names"]
        optionalNames  <- reader["optionalNames"]
        unwrappedNames <- reader["unwrappedNames"]
        
        expect(self.reader.storableValues["names"] as? String) == "{\"name\":\"Arya\"}"
        expect(self.reader.storableValues["optionalNames"] as? String) == "{\"name\":\"Arya\"}"
        expect(self.reader.storableValues["unwrappedNames"] as? String) == "{\"name\":\"Arya\"}"
        expect(self.reader.propertyTypes).to(haveCount(3))
    }
    
    func testMappableOperatorsUpdateReader() {
        
        var stark: Stark           = Stark(name: "Arya", weight: 50, age: 11)
        var optionalStark: Stark?  = Stark(name: "Arya", weight: 50, age: 11)
        var unwrappedStark: Stark! = Stark(name: "Arya", weight: 50, age: 11)
        
        stark          <- reader["stark"]
        optionalStark  <- reader["optionalStark"]
        unwrappedStark <- reader["unwrappedStark"]
        
        expect(self.reader.mappables["stark"]).notTo(beNil())
        expect(self.reader.mappables["optionalStark"]).notTo(beNil())
        expect(self.reader.mappables["unwrappedStark"]).notTo(beNil())
        expect(self.reader.propertyTypes).to(haveCount(3))
    }
    
    func testMappableArrayOperatorsUpdateReader() {
        
        var starks: [Stark]           = [Stark(name: "Arya", weight: 50, age: 11)]
        var optionalStarks: [Stark]?  = [Stark(name: "Arya", weight: 50, age: 11)]
        var unwrappedStarks: [Stark]! = [Stark(name: "Arya", weight: 50, age: 11)]
        
        starks          <- reader["starks"]
        optionalStarks  <- reader["optionalStarks"]
        unwrappedStarks <- reader["unwrappedStarks"]
        
        expect(self.reader.mappableArrays["starks"]).notTo(beNil())
        expect(self.reader.mappableArrays["optionalStarks"]).notTo(beNil())
        expect(self.reader.mappableArrays["unwrappedStarks"]).notTo(beNil())
        expect(self.reader.propertyTypes).to(haveCount(3))
    }
    
    func testMappableSetOperatorsUpdateReader() {
        
        var starks: Set<Stark>           = [Stark(name: "Arya", weight: 50, age: 11)]
        var optionalStarks: Set<Stark>?  = [Stark(name: "Arya", weight: 50, age: 11)]
        var unwrappedStarks: Set<Stark>! = [Stark(name: "Arya", weight: 50, age: 11)]
        
        starks          <- reader["starks"]
        optionalStarks  <- reader["optionalStarks"]
        unwrappedStarks <- reader["unwrappedStarks"]
        
        expect(self.reader.mappableArrays["starks"]).notTo(beNil())
        expect(self.reader.mappableArrays["optionalStarks"]).notTo(beNil())
        expect(self.reader.mappableArrays["unwrappedStarks"]).notTo(beNil())
        expect(self.reader.propertyTypes).to(haveCount(3))
    }
    
    func testNilMappableSetOperatorsUpdateReader() {
        
        var optionalStarks: Set<Stark>?  = nil
        var unwrappedStarks: Set<Stark>! = nil
        
        optionalStarks  <- reader["optionalStarks"]
        unwrappedStarks <- reader["unwrappedStarks"]
        
        expect(self.reader.mappableArrays["optionalStarks"]).to(beNil())
        expect(self.reader.mappableArrays["unwrappedStarks"]).to(beNil())
        expect(self.reader.propertyTypes).to(haveCount(2))
    }
}
