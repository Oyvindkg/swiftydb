//
//  SQLiteDatatypeTests.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 30/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

import XCTest
import Nimble

@testable import SwiftyDB


class SQLiteDatatypeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testReturnsTextTypeForStrings() {
        let datatype = SQLiteDatatype.init(value: "string")
        
        expect(datatype).to(equal(SQLiteDatatype.text))
    }
    
    func testReturnsTextTypeForCharacters() {
        let datatype = SQLiteDatatype.init(value: Character("s"))
        
        expect(datatype).to(equal(SQLiteDatatype.text))
    }
    
    func testReturnsRealTypeForDoubles() {
        let datatype = SQLiteDatatype.init(value: 1.3)
        
        expect(datatype).to(equal(SQLiteDatatype.real))
    }
    
    func testReturnsRealTypeForFloats() {
        let datatype = SQLiteDatatype.init(value: Float(1.3))
        
        expect(datatype).to(equal(SQLiteDatatype.real))
    }
    
    func testReturnsIntegerTypeForIntegers() {
        let int = SQLiteDatatype.init(value: 1)
        let int8 = SQLiteDatatype.init(value: Int8(1))
        let int16 = SQLiteDatatype.init(value: Int8(1))
        let int64 = SQLiteDatatype.init(value: Int64(1))
        
        expect(int).to(equal(SQLiteDatatype.integer))
        expect(int8).to(equal(SQLiteDatatype.integer))
        expect(int16).to(equal(SQLiteDatatype.integer))
        expect(int64).to(equal(SQLiteDatatype.integer))
    }
    
    func testReturnsIntegerTypeForBools() {
        let type = SQLiteDatatype.init(value: false)
        
        expect(type).to(equal(SQLiteDatatype.integer))
    }
    
    func testReturnsNiForUnsignedLongLong() {
        let uint64 = SQLiteDatatype.init(value: UInt64(1))
        
        expect(uint64).to(beNil())
    }
    
    func testRealRawValueIsReal() {
        expect(SQLiteDatatype.real.rawValue).to(equal("REAL"))
    }
    
    func testIntegerRawValueIsInteger() {
        expect(SQLiteDatatype.integer.rawValue).to(equal("INTEGER"))
    }
    
    func testTextRawValueIsText() {
        expect(SQLiteDatatype.text.rawValue).to(equal("TEXT"))
    }
}
