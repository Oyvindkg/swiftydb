//
//  SQLiteDatatypeTests.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 30/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

import XCTest

@testable import SwiftyDB


class SQLiteDatatypeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testReturnsTextTypeForStrings() {
        let datatype = SQLiteDatatype(value: "string")
        
        XCTAssert(datatype == .text)
    }
    
    func testReturnsTextTypeForCharacters() {
        let datatype = SQLiteDatatype(value: Character("s"))
        
        XCTAssert(datatype == .text)
    }
    
    func testReturnsRealTypeForDoubles() {
        let datatype = SQLiteDatatype(value: 1.3)
        
        XCTAssert(datatype == .real)
    }
    
    func testReturnsRealTypeForFloats() {
        let datatype = SQLiteDatatype.init(value: Float(1.3))
        
        XCTAssert(datatype == .real)
    }
    
    func testReturnsIntegerTypeForIntegers() {
        let int = SQLiteDatatype(value: 1)
        let int8 = SQLiteDatatype(value: Int8(1))
        let int16 = SQLiteDatatype(value: Int8(1))
        let int64 = SQLiteDatatype(value: Int64(1))
        
        XCTAssert(int == .integer)
        XCTAssert(int8 == .integer)
        XCTAssert(int16 == .integer)
        XCTAssert(int64 == .integer)
    }
    
    func testReturnsIntegerTypeForBools() {
        let type = SQLiteDatatype(value: false)
        
        XCTAssert(type == .integer)
    }
    
    func testReturnsNiForUnsignedLongLong() {
        let uint64 = SQLiteDatatype(value: UInt64(1))
        
        XCTAssert(uint64 == nil)
    }
    
    func testRealRawValueIsReal() {
        XCTAssert(SQLiteDatatype.real.rawValue == "REAL")
    }
    
    func testIntegerRawValueIsInteger() {
        XCTAssert(SQLiteDatatype.integer.rawValue == "INTEGER")
    }
    
    func testTextRawValueIsText() {
        XCTAssert(SQLiteDatatype.text.rawValue == "TEXT")
    }
}
