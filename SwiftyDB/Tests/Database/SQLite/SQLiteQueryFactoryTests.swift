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
    
    var queryFactory = SQLiteQueryFactory()
    var reader = ObjectMapper.read(type: Stark.self)
    
    override func setUp() {
        super.setUp()
        
        reader = ObjectMapper.read(type: Stark.self)
        queryFactory = SQLiteQueryFactory()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Create table
    
    func testCreateTableUsesTextTypeForStringValues() {
        let query = SQLiteQueryFactory.createTableQuery(for: reader)
        
        XCTAssert(query.query.contains("\"name\" TEXT"), "String properties should be defined as text")
    }
    
    func testCreateTableUsesRealTypeForDoubleValues() {
        let query = SQLiteQueryFactory.createTableQuery(for: reader)
        
        XCTAssert(query.query.contains("\"weight\" REAL"), "Double properties should be defined as real")
    }
    
    func testCreateTableUsesIntegerTypeForIntegerValues() {
        let query = SQLiteQueryFactory.createTableQuery(for: reader)
        
        XCTAssert(query.query.contains("\"age\" INTEGER"), "Int properties should be defined as integers")
    }
    
    func testCreateTableUsesTextTypeForStorableType() {
        let query = SQLiteQueryFactory.createTableQuery(for: reader)
        
        XCTAssert(query.query.contains("\"wolf\" TEXT"), "Storable properties should be defined as text")
    }
    
    func testCreateTableUsesReaderTypeAsTableName() {
        let query = SQLiteQueryFactory.createTableQuery(for: reader)
        
        XCTAssert(query.query.contains("TABLE \"\(Stark.name)"), "The table name should be the escaped name of the type")
    }
    
    func testCreateTableAssignsIdentifierAsPrimaryKey() {
        let identifier          = (reader.type as! Identifiable.Type).identifier()
        let identifierDatatype  = Column.Datatype(type: reader.propertyTypes[identifier]!)!
        
        let query = SQLiteQueryFactory.createTableQuery(for: reader)
        
        XCTAssert(query.query.contains("\"\(identifier)\" \(identifierDatatype.rawValue) PRIMARY KEY"), "The identifier should be defined as the primary key")
    }
    
    
    // MARK: - Insert
    
    func testInsertQueryUpdatesExistingValueIfPresent() {
        let query = SQLiteQueryFactory.insertQuery(for: reader, replaceIfExists: true)

        XCTAssert(query.query.contains("INSERT OR REPLACE"), "Existing objects should be replaced")
    }
    
    func testInsertUsesReaderTypeAsTableName() {
        let query = SQLiteQueryFactory.insertQuery(for: reader, replaceIfExists: true)
        
        XCTAssert(query.query.contains("INTO \"\(Stark.self)\""), "Should insert into the correct table")
    }
    
    func testInsertUpdatesAllStorablePropertiesInTheReader() {
        let lady  = Wolf(name: "Lady", age: 3)
        let sansa = Stark(name: "Sansa", weight: 50, age: 14, wolf: lady)
        
        let reader = ObjectMapper.read(sansa)
        
        let query = SQLiteQueryFactory.insertQuery(for: reader, replaceIfExists: true)
        
        XCTAssert(query.query.contains("\"age\""), "All properties should be updated")
        XCTAssert(query.query.contains("\"name\""), "All properties should be updated")
        XCTAssert(query.query.contains("\"weight\""), "All properties should be updated")
    }
    
    
    func testInsertDefinesCorrectNumberOfPlaceholders() {
        let lady  = Wolf(name: "Lady", age: 3)
        let sansa = Stark(name: "Sansa", weight: 50, age: 14, wolf: lady)
        
        let reader = ObjectMapper.read(sansa)
        
        let query = SQLiteQueryFactory.insertQuery(for: reader, replaceIfExists: true)
        
        XCTAssert(query.query.contains(":age"), "All properties should be parameterized")
        XCTAssert(query.query.contains(":name"), "All properties should be parameterized")
        XCTAssert(query.query.contains(":weight"), "All properties should be parameterized")
    }
    
    func testSelectQueryIsCorrect() {
        
        let query = Query.get(Stark.self)
                         .where("age" < 10 && "name" != "Brandon")
                         .limit(to: 2)
                         .skip(1)
                         .order(by: "weight", ascending: true)
        
        let expectedQuery = "SELECT * FROM \"Stark\" WHERE (\"age\" < ? AND \"name\" != ?) ORDER BY \"weight\" ASC LIMIT ? OFFSET ?"
        
        let sqliteQuery = SQLiteQueryFactory.selectQuery(for: Stark.self, filter: query.filter as? SQLiteFilterStatement, order: query.order, limit: query.limit, offset: query.skip)
 
        expect(sqliteQuery.query) == expectedQuery
    }
    
    func testCreateIndexQueryIsCorrect() {
        
        let index = Index.on("age", "name").where("age" << [10, 11, 13])
        
        let name = IndexingUtilities.name(of: index, for: Stark.self)
        
        let expectedQuery = "CREATE INDEX \"\(name)\" ON \"Stark\" (\"age\", \"name\") WHERE \"age\" IN (10,11,13)"
        
        let sqliteQuery = SQLiteQueryFactory.createIndexQuery(for: index, for: Stark.self)

        expect(sqliteQuery.query) == expectedQuery
    }
    
    func testDeleteQueryIsCorrect() {
        
        let query = Query.get(Stark.self).where("age" < 10 && "name" != "Brandon")
        
        let expectedQuery = "DELETE FROM \"Stark\" WHERE (\"age\" < ? AND \"name\" != ?)"
        
        let sqliteQuery = SQLiteQueryFactory.deleteQuery(for: Stark.self, filter: query.filter as! SQLiteFilterStatement)
        
        expect(sqliteQuery.query) == expectedQuery
    }
}
