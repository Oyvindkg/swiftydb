//
//  ReaderTests.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 28/04/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import Nimble

@testable import SwiftyDB

public class ReaderTests: XCTestCase {
    
    func testSetCurrentValuePreservesTheStorableValueRepresentation() {
        let value = Date()
        
        let reader = Reader(type: Stark.self)
        
        
        reader["date"].setCurrent(value: value)
        
        expect(reader.storableValues["date"] as? Date.RawValue) == value.rawValue
        expect(reader.propertyTypes["date"] is Date.RawValue.Type) == true
    }
    
    func testSetCurrentValuesConvertsTheStorableValueRepresentationsToJSON() {
        let reader = Reader(type: Stark.self)
        
        reader["dates"].setCurrent(values: [10, 100])
        
        expect(reader.storableValues["dates"] as? String) == "[10,100]"
        expect(reader.propertyTypes["dates"] is Array<Int.RawValue>.Type) == true
    }
    
    func testSetCurrentValuesSetConvertsTheStorableValueRepresentationsToJSON() {
        let reader = Reader(type: Stark.self)
        
        reader["dates"].setCurrent(values: Set([10, 100]))
        
        expect(reader.storableValues["dates"] as? String) == "[100,10]"
        expect(reader.propertyTypes["dates"] is Array<Int.RawValue>.Type) == true
    }
    
    func testSetCurrentDictionaryConvertsTheStorableValueRepresentationsToJSON() {
        let reader = Reader(type: Stark.self)
        
        reader["dates"].setCurrent(dictionary: ["age": 10, "height": 100])
        
        expect(reader.storableValues["dates"] as? String) == "{\"age\":10,\"height\":100}"
        expect(reader.propertyTypes["dates"] is Dictionary<String.RawValue, Int.RawValue>.Type) == true
    }
    
    func testSetCurrentMappableReadsTheMappable() {
        let arya   = Stark(name: "Arya", weight: 50, age: 10)
        let reader = Reader(type: Stark.self)
        
        reader["sister"].setCurrent(mappable: arya)
        
        let sisterReader = reader.mappables["sister"]
        
        expect(sisterReader?.storableValues["name"] as? String) == "Arya"
        expect(sisterReader?.storableValues["weight"] as? Double) == 50
    }
    
    func testSetCurrentMappableStoresTheMappableType() {
        let arya   = Stark(name: "Arya", weight: 50, age: 10)
        let reader = Reader(type: Stark.self)
        
        reader["sister"].setCurrent(mappable: arya)
        
        expect(reader.propertyTypes["sister"] is Stark.Type) == true
    }
    
    func testSetCurrentMappableStoresTheMappablesIdentifierAsJSON() {
        let arya   = Stark(name: "Arya", weight: 50, age: 10)
        let reader = Reader(type: Stark.self)
        
        reader["sister"].setCurrent(mappable: arya)
        
        expect(reader.storableValues["sister"] as? String) == arya.name
    }
    
    func testSetCurrentMappablesReadsTheMappables() {
        let arya   = Stark(name: "Arya", weight: 50, age: 10)
        let reader = Reader(type: Stark.self)
        
        reader["siblings"].setCurrent(mappables: [arya])
        
        let siblingReaders = reader.mappableArrays["siblings"]
        
        expect(siblingReaders).to(haveCount(1))
        
        expect(siblingReaders?.first?.storableValues["name"] as? String) == "Arya"
        expect(siblingReaders?.first?.storableValues["weight"] as? Double) == 50
    }
    
    func testSetCurrentMappablesStoresTheMappablesType() {
        let arya   = Stark(name: "Arya", weight: 50, age: 10)
        let reader = Reader(type: Stark.self)
        
        reader["siblings"].setCurrent(mappables: [arya])
        
        expect(reader.propertyTypes["siblings"] is Array<Stark>.Type) == true
    }
    
    func testSetCurrentMappablesStoresTheMappableIdentifiersAsJSON() {
        let arya   = Stark(name: "Arya", weight: 50, age: 10)
        let reader = Reader(type: Stark.self)
        
        reader["siblings"].setCurrent(mappables: [arya])
        
        expect(reader.storableValues["siblings"] as? String) == "[\"Arya\"]"
    }
    
    func testNoValuesAreSetIfKeyIsNil() {
        let arya   = Stark(name: "Arya", weight: 50, age: 10)
        let reader = Reader(type: Stark.self)
        
        reader.setCurrent(value: "Value")
        reader.setCurrent(values: ["Value", "Values"])
        reader.setCurrent(values: Set<String>(arrayLiteral: "Value"))
        reader.setCurrent(mappable: arya)
        reader.setCurrent(mappables: [arya])
        reader.setCurrent(dictionary: ["Key": "Value"])
        
        expect(reader.storableValues).to(haveCount(0))
        expect(reader.mappableArrays).to(haveCount(0))
        expect(reader.mappables).to(haveCount(0))
        expect(reader.propertyTypes).to(haveCount(0))
    }
    
}
