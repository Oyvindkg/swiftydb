//
//  Column.DatatypeTests.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 30/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

import XCTest

@testable import SwiftyDB


class ColumnDatatypeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testReturnsTextTypeForStrings() {
        let datatype = Column.Datatype(value: "string")
        
        XCTAssertEqual(datatype, .text)
    }
    
    func testReturnsTextTypeForCharacters() {
        let datatype = Column.Datatype(value: Character("s"))
        
        XCTAssertEqual(datatype, .text)
    }
    
    func testReturnsRealTypeForDoubles() {
        let datatype = Column.Datatype(value: 1.3)
        
        XCTAssertEqual(datatype, .real)
    }
    
    func testReturnsRealTypeForFloats() {
        let datatype = Column.Datatype.init(value: Float(1.3))
        
        XCTAssertEqual(datatype, .real)
    }
    
    func testReturnsIntegerTypeForIntegers() {
        let int = Column.Datatype(value: Int32(1))
        let int8 = Column.Datatype(value: Int8(1))
        let int16 = Column.Datatype(value: Int8(1))
        let int64 = Column.Datatype(value: Int64(1))
        
        XCTAssertEqual(int, .integer)
        XCTAssertEqual(int8, .integer)
        XCTAssertEqual(int16, .integer)
        XCTAssertEqual(int64, .integer)
    }
    
    func testReturnsIntegerTypeForSomeUIntegers() {
        let int32 = Column.Datatype(value: UInt32(1))
        let int8 = Column.Datatype(value: UInt8(1))
        let int16 = Column.Datatype(value: UInt16(1))
        let int64 = Column.Datatype(value: UInt64(1))
        
        XCTAssertEqual(int32, .integer)
        XCTAssertEqual(int8, .integer)
        XCTAssertEqual(int16, .integer)
        XCTAssertEqual(int64, nil)
    }
    
    func testReturnsIntegerTypeForBools() {
        let type = Column.Datatype(value: false)
        
        XCTAssertEqual(type, .integer)
    }
    
    func testReturnsNiForUnsignedLongLong() {
        let uint64 = Column.Datatype(value: UInt64(1))
        
        XCTAssertEqual(uint64, nil)
    }
    
    func testRealRawValueIsReal() {
        XCTAssertEqual(Column.Datatype.real.rawValue, "REAL")
    }
    
    func testIntegerRawValueIsInteger() {
        XCTAssertEqual(Column.Datatype.integer.rawValue, "INTEGER")
    }
    
    func testTextRawValueIsText() {
        XCTAssertEqual(Column.Datatype.text.rawValue, "TEXT")
    }
}
