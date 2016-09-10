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
        
        expect(datatype).to(equal(SQLiteDatatype.Text))
    }
    
    func testReturnsTextTypeForCharacters() {
        let datatype = SQLiteDatatype.init(value: Character("s"))
        
        expect(datatype).to(equal(SQLiteDatatype.Text))
    }
    
    func testReturnsRealTypeForDoubles() {
        let datatype = SQLiteDatatype.init(value: 1.3)
        
        expect(datatype).to(equal(SQLiteDatatype.Real))
    }
    
    func testReturnsRealTypeForFloats() {
        let datatype = SQLiteDatatype.init(value: Float(1.3))
        
        expect(datatype).to(equal(SQLiteDatatype.Real))
    }
    
    func testReturnsIntegerTypeForIntegers() {
        let int = SQLiteDatatype.init(value: 1)
        let int8 = SQLiteDatatype.init(value: Int8(1))
        let int16 = SQLiteDatatype.init(value: Int8(1))
        let int64 = SQLiteDatatype.init(value: Int64(1))
        
        expect(int).to(equal(SQLiteDatatype.Integer))
        expect(int8).to(equal(SQLiteDatatype.Integer))
        expect(int16).to(equal(SQLiteDatatype.Integer))
        expect(int64).to(equal(SQLiteDatatype.Integer))
    }
    
    func testReturnsIntegerTypeForBools() {
        let type = SQLiteDatatype.init(value: false)
        
        expect(type).to(equal(SQLiteDatatype.Integer))
    }
    
    func testReturnsNiForUnsignedLongLong() {
        let uint64 = SQLiteDatatype.init(value: UInt64(1))
        
        expect(uint64).to(beNil())
    }
    
    func testRealRawValueIsReal() {
        expect(SQLiteDatatype.Real.rawValue).to(equal("REAL"))
    }
    
    func testIntegerRawValueIsInteger() {
        expect(SQLiteDatatype.Integer.rawValue).to(equal("INTEGER"))
    }
    
    func testTextRawValueIsText() {
        expect(SQLiteDatatype.Text.rawValue).to(equal("TEXT"))
    }
}