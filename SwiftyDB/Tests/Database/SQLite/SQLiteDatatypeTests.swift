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
        
        XCTAssertEqual(datatype, .text)
    }
    
    func testReturnsTextTypeForCharacters() {
        let datatype = SQLiteDatatype(value: Character("s"))
        
        XCTAssertEqual(datatype, .text)
    }
    
    func testReturnsRealTypeForDoubles() {
        let datatype = SQLiteDatatype(value: 1.3)
        
        XCTAssertEqual(datatype, .real)
    }
    
    func testReturnsRealTypeForFloats() {
        let datatype = SQLiteDatatype.init(value: Float(1.3))
        
        XCTAssertEqual(datatype, .real)
    }
    
    func testReturnsIntegerTypeForIntegers() {
        let int = SQLiteDatatype(value: Int32(1))
        let int8 = SQLiteDatatype(value: Int8(1))
        let int16 = SQLiteDatatype(value: Int8(1))
        let int64 = SQLiteDatatype(value: Int64(1))
        
        XCTAssertEqual(int, .integer)
        XCTAssertEqual(int8, .integer)
        XCTAssertEqual(int16, .integer)
        XCTAssertEqual(int64, .integer)
    }
    
    func testReturnsIntegerTypeForSomeUIntegers() {
        let int32 = SQLiteDatatype(value: UInt32(1))
        let int8 = SQLiteDatatype(value: UInt8(1))
        let int16 = SQLiteDatatype(value: UInt16(1))
        let int64 = SQLiteDatatype(value: UInt64(1))
        
        XCTAssertEqual(int32, .integer)
        XCTAssertEqual(int8, .integer)
        XCTAssertEqual(int16, .integer)
        XCTAssertEqual(int64, nil)
    }
    
    func testReturnsIntegerTypeForBools() {
        let type = SQLiteDatatype(value: false)
        
        XCTAssertEqual(type, .integer)
    }
    
    func testReturnsNiForUnsignedLongLong() {
        let uint64 = SQLiteDatatype(value: UInt64(1))
        
        XCTAssertEqual(uint64, nil)
    }
    
    func testRealRawValueIsReal() {
        XCTAssertEqual(SQLiteDatatype.real.rawValue, "REAL")
    }
    
    func testIntegerRawValueIsInteger() {
        XCTAssertEqual(SQLiteDatatype.integer.rawValue, "INTEGER")
    }
    
    func testTextRawValueIsText() {
        XCTAssertEqual(SQLiteDatatype.text.rawValue, "TEXT")
    }
}
