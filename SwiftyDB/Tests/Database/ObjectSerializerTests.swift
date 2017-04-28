//
//  ObjectSerializerTests.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 28/04/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import Nimble

@testable import SwiftyDB

public class ObjectSerializerTests: XCTestCase {
    
    func testReturnsOneReaderForUnnestedObjects() {
        let lady = Wolf(name: "Lady", age: 5)
        
        expect(ObjectSerializer.readers(for: lady)).to(haveCount(1))
    }
    
    func testReturnsOneReaderPerObjectForNestedObjects() {
        let lady = Wolf(name: "Lady", age: 5)
        let arya = Stark(name: "Arya", weight: 50, age: 11)
        
        let sansa = Stark(name: "Sansa", weight: 60, age: 13, wolf: lady)
        
        sansa.siblings = [arya]
        
        expect(ObjectSerializer.readers(for: sansa)).to(haveCount(3))
    }

    func testCorrectlyReadsProperties() {
        let lady = Wolf(name: "Lady", age: 5)
        
        let reader = ObjectSerializer.readers(for: lady).first!
        
        expect(reader.storableValues).to(haveCount(2))
        expect(reader.storableValues["name"] as? String) == "Lady"
        expect(reader.storableValues["age"] as? Int)  == 5
    }
    
    func testCorrectlyReadsStorableProperties() {
        let lady = Wolf(name: "Lady", age: 5)
        
        let sansa = Stark(name: "Sansa", weight: 60, age: 13, wolf: lady)
        
        let wolfReaders = ObjectSerializer.readers(for: sansa).filter { $0.type == Wolf.self }
        
        let reader = wolfReaders.first!
        
        expect(reader.storableValues["name"] as? String) == "Lady"
        expect(reader.storableValues["age"] as? Int)  == 5
    }
    
    func testCorrectlyReadsStorableArrayProperties() {
        let arya  = Stark(name: "Arya", weight: 50, age: 11)
        let brand = Stark(name: "Brandon", weight: 50, age: 9)
        let sansa = Stark(name: "Sansa", weight: 60, age: 13)
        
        sansa.siblings = [arya, brand]
        
        let readers = ObjectSerializer.readers(for: sansa)
        
        expect(readers[1].storableValues["name"] as? String) == "Arya"
        expect(readers[1].storableValues["age"] as? Int)     == 11
        expect(readers[1].storableValues["weight"] as? Double)  == 50
        
        expect(readers[2].storableValues["name"] as? String) == "Brandon"
        expect(readers[2].storableValues["age"] as? Int)     == 9
        expect(readers[2].storableValues["weight"] as? Double)  == 50
    }
    
    func testReturnsNoReadersForNilParameters() {
        let missingStark: Stark? = nil
        
        expect(ObjectSerializer.readers(for: missingStark)).to(haveCount(0))
    }
}
