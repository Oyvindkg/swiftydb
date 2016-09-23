//
//  SQLiteQueryFactoryTests.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 29/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest


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
        
        XCTAssert(query.query.contains("'name' TEXT"), "String properties should be defined as text")
    }
    
    func testCreateTableUsesRealTypeForDoubleValues() {
        let query = sut.createTableQueryForReader(reader)
        
        XCTAssert(query.query.contains("'weight' REAL"), "Double properties should be defined as real")
    }
    
    func testCreateTableUsesIntegerTypeForIntegerValues() {
        let query = sut.createTableQueryForReader(reader)
        
        XCTAssert(query.query.contains("'age' INTEGER"), "Int properties should be defined as integers")
    }
    
    func testCreateTableUsesTextTypeForStorableType() {
        let query = sut.createTableQueryForReader(reader)
        
        XCTAssert(query.query.contains("'wolf' TEXT"), "Storable properties should be defined as text")
    }
    
    func testCreateTableUsesReaderTypeAsTableName() {
        let query = sut.createTableQueryForReader(reader)
        
        XCTAssert(query.query.contains("TABLE '\(Stark.self)'"), "The table name should be the escaped name of the type")
    }
    
    func testCreateTableAssignsIdentifierAsPrimaryKey() {
        let identifier          = (reader.type as! Identifiable.Type).identifier()
        let identifierDatatype  = SQLiteDatatype(type: reader.types[identifier]!)!
        
        let query = sut.createTableQueryForReader(reader)
        
        XCTAssert(query.query.contains("'\(identifier)' \(identifierDatatype.rawValue) PRIMARY KEY"), "The identifier should be defined as the primary key")
    }
    
    
    // MARK: - Insert
    
    func testInsertQueryUpdatesExistingValueIfPresent() {
        let query = sut.insertQueryForReader(reader)

        XCTAssert(query.query.contains("INSERT OR REPLACE"), "Existing objects should be replaced")
    }
    
    func testInsertUsesReaderTypeAsTableName() {
        let query = sut.insertQueryForReader(reader)
        
        XCTAssert(query.query.contains("INTO '\(Stark.self)'"), "Should insert into the correct table")
    }
    
    func testInsertUpdatesAllStorablePropertiesInTheReader() {
        let lady  = Wolf(name: "Lady", age: 3)
        let sansa = Stark(name: "Sansa", weight: 50, age: 14, wolf: lady)
        
        let reader = Mapper.readerForObject(sansa)
        
        let query = sut.insertQueryForReader(reader)
        
        XCTAssert(query.query.contains("'age'"), "All properties should be updated")
        XCTAssert(query.query.contains("'name'"), "All properties should be updated")
        XCTAssert(query.query.contains("'weight'"), "All properties should be updated")
    }
    
    
    func testInsertDefinesCorrectNumberOfPlaceholders() {
        let lady  = Wolf(name: "Lady", age: 3)
        let sansa = Stark(name: "Sansa", weight: 50, age: 14, wolf: lady)
        
        let reader = Mapper.readerForObject(sansa)
        
        let query = sut.insertQueryForReader(reader)
        
        XCTAssert(query.query.contains("':age'"), "All properties should be parameterized")
        XCTAssert(query.query.contains("':name'"), "All properties should be parameterized")
        XCTAssert(query.query.contains("':weight'"), "All properties should be parameterized")
    }
}
