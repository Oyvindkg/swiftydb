//
//  SQLiteQueryFactoryTests.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 29/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import Nimble

@testable import SwiftyDB


class SQLiteQueryFactoryTests: XCTestCase {
    
    var sut = SQLiteQueryFactory()
    var reader = Mapper.readerForType(Stark.self)
    
    override func setUp() {
        super.setUp()
        
        reader = Mapper.readerForType(Stark.self)
        sut = SQLiteQueryFactory()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Create table
    
    func testCreateTableUsesTextTypeForStringValues() {
        let query = sut.createTableQueryForReader(reader)

        expect(query.query).to(contain("'name' TEXT"))
    }
    
    func testCreateTableUsesRealTypeForDoubleValues() {
        let query = sut.createTableQueryForReader(reader)
        
        expect(query.query).to(contain("'weight' REAL"))
    }
    
    func testCreateTableUsesIntegerTypeForIntegerValues() {
        let query = sut.createTableQueryForReader(reader)
        
        expect(query.query).to(contain("'age' INTEGER"))
    }
    
    func testCreateTableUsesTextTypeForStoreableType() {
        let query = sut.createTableQueryForReader(reader)
        
        expect(query.query).to(contain("'wolf' TEXT"))
    }
    
    func testCreateTableUsesReaderTypeAsTableName() {
        let query = sut.createTableQueryForReader(reader)
        
        expect(query.query).to(contain("TABLE '\(Stark.self)'"))
    }
    
    func testCreateTableAssignsIdentifierAsPrimaryKey() {
        let identifier          = (reader.type as! Identifiable.Type).identifier()
        let identifierDatatype  = SQLiteDatatype(type: reader.types[identifier]!)!
        
        let query = sut.createTableQueryForReader(reader)
        
        expect(query.query).to(contain("'\(identifier)' \(identifierDatatype.rawValue) PRIMARY KEY"))
    }
    
    
    // MARK: - Insert
    
    func testInsertQueryUpdatesExistingValueIfPresent() {
        let query = sut.insertQueryForReader(reader)

        expect(query.query).to(contain("INSERT OR REPLACE"))
    }
    
    func testInsertUsesReaderTypeAsTableName() {
        let query = sut.insertQueryForReader(reader)
        
        expect(query.query).to(contain("INTO '\(Stark.self)'"))
    }
    
    func testInsertUpdatesAllStoreablePropertiesInTheReader() {
        let lady  = Wolf(name: "Lady", age: 3)
        let sansa = Stark(name: "Sansa", weight: 50, age: 14, wolf: lady)
        
        let reader = Mapper.readerForObject(sansa)
        
        let query = sut.insertQueryForReader(reader)
        
        expect(query.query).to(contain("'age'", "'name'", "'weight'"))
    }
    
    
    func testInsertDefinesCorrectNumberOfPlaceholders() {
        let lady  = Wolf(name: "Lady", age: 3)
        let sansa = Stark(name: "Sansa", weight: 50, age: 14, wolf: lady)
        
        let reader = Mapper.readerForObject(sansa)
        
        let query = sut.insertQueryForReader(reader)
        
        expect(query.query).to(contain(":age", ":name", ":weight"))
    }
}