//
//  StorablePropertiesTest.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 28/04/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import Nimble

@testable import SwiftyDB

public class StorablePropertiesTest: XCTestCase {
    
    func testStringIsConvertedCorrectly() {
        let original = "To be, or not to be, that is the question"
        
        expect(String(rawValue: original.rawValue)) == original
    }
    
    func testCharacterIsConvertedCorrectly() {
        let original = "The slings and arrows of outrageous fortune".characters.first!
        
        expect(Character(rawValue: original.rawValue)) == original
    }
    
    func testBoolIsConvertedCorrectly() {
        expect(Bool(rawValue: true.rawValue)) == true
        expect(Bool(rawValue: false.rawValue)) == false
    }
    
    func testDoubleIsConvertedCorrectly() {
        let min = Double.leastNormalMagnitude
        let max = Double.greatestFiniteMagnitude
        
        expect(Double(rawValue: min.rawValue)) == min
        expect(Double(rawValue: max.rawValue)) == max
        expect(Double(rawValue: Double.infinity)) == Double.infinity
    }
    
    func testFloatIsConvertedCorrectly() {
        let min = Float.leastNormalMagnitude
        let max = Float.greatestFiniteMagnitude
        
        expect(Float(rawValue: min.rawValue)) == min
        expect(Float(rawValue: max.rawValue)) == max
    }
    
    func testIntIsConvertedCorrectly() {
        let min = Int.min
        let max = Int.max
        
        expect(Int(rawValue: min.rawValue)) == min
        expect(Int(rawValue: max.rawValue)) == max
    }
    
    func testInt8IsConvertedCorrectly() {
        let min = Int8.min
        let max = Int8.max
        
        expect(Int8(rawValue: min.rawValue)) == min
        expect(Int8(rawValue: max.rawValue)) == max
    }
    
    func testInt16IsConvertedCorrectly() {
        let min = Int16.min
        let max = Int16.max
        
        expect(Int16(rawValue: min.rawValue)) == min
        expect(Int16(rawValue: max.rawValue)) == max
    }
    
    func testInt32IsConvertedCorrectly() {
        let min = Int32.min
        let max = Int32.max
        
        expect(Int32(rawValue: min.rawValue)) == min
        expect(Int32(rawValue: max.rawValue)) == max
    }
    
    func testInt64IsConvertedCorrectly() {
        let min = Int64.min
        let max = Int64.max
        
        expect(Int64(rawValue: min.rawValue)) == min
        expect(Int64(rawValue: max.rawValue)) == max
    }
    
    func testUIntIsConvertedCorrectly() {
        let min = UInt.min
        let max = UInt.max
        
        expect(UInt(rawValue: "Hello")).to(beNil())
        expect(UInt(rawValue: min.rawValue)) == min
        expect(UInt(rawValue: max.rawValue)) == max
    }
    
    func testUInt8IsConvertedCorrectly() {
        let min = UInt8.min
        let max = UInt8.max
        
        expect(UInt8(rawValue: min.rawValue)) == min
        expect(UInt8(rawValue: max.rawValue)) == max
    }
    
    func testUInt16IsConvertedCorrectly() {
        let min = UInt16.min
        let max = UInt16.max
        
        expect(UInt16(rawValue: min.rawValue)) == min
        expect(UInt16(rawValue: max.rawValue)) == max
    }
    
    func testUInt32IsConvertedCorrectly() {
        let min = UInt32.min
        let max = UInt32.max
        
        expect(UInt32(rawValue: min.rawValue)) == min
        expect(UInt32(rawValue: max.rawValue)) == max
    }
    
    func testUInt64IsConvertedCorrectly() {
        let min = UInt64.min
        let max = UInt64.max
        
        expect(UInt64(rawValue: "Hello")).to(beNil())
        expect(UInt64(rawValue: min.rawValue)) == min
        expect(UInt64(rawValue: max.rawValue)) == max
    }
    
    func testDateIsConvertedCorrectly() {
        let original = Date(timeIntervalSince1970: 10000)
        
        expect(Date(rawValue: original.rawValue)?.timeIntervalSince1970) == 10000 ± 0.0005
        expect(Date(rawValue: "Or to take Arms against a Sea of troubles")).to(beNil())
    }
    
    func testDataIsConvertedCorrectly() {
        let original = "Whether 'tis nobler in the mind to suffer".data(using: .utf8)!
        
        expect(Data(rawValue: original.rawValue)) == original
        expect(Data(rawValue: "Å")).to(beNil())
    }
    
    func testUUIDIsConvertedCorrectly() {
        let original = UUID()
        
        expect(UUID(rawValue: original.rawValue)) == original
        expect(UUID(rawValue: "12")).to(beNil())
    }
}
