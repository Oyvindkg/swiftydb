//
//  SwiftyTests.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 30/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest

@testable import SwiftyDB


/** Component testing the database */
class SwiftyTests: XCTestCase {

    var configuration: ConfigurationProtocol = {
        var configuration = Configuration(name: "database_test")
        
        configuration.mode = .sandbox
        
        return configuration
    }()
    
    var swifty = Swifty(name: "sad")
    
    override func setUp() {
        super.setUp()
        
        self.swifty = Swifty(configuration: configuration)
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testAddedObjectsAreRetrievedCorrectly() {
        let lady = Wolf(name: "Lady", age: 5)
        
        let arya = Stark(name: "Arya", weight: 45, age: 10)
        let brand = Stark(name: "Brandon", weight: 40, age: 9)
        let sansa = Stark(name: "Sansa", weight: 50, age: 14, wolf: lady)

        sansa.siblings = [arya, brand]
        
        
        
        swifty.add(sansa) { result in
            
            XCTAssertNil(result.errorMessage)
            
            self.swifty.get(Stark.self).filter("name" == "Sansa") { result in
                let retrievedSansa = result.value!.first!
                
                XCTAssertNil(result.errorMessage)
                
                XCTAssertEqual(retrievedSansa.age, sansa.age)
                XCTAssertEqual(retrievedSansa.name, sansa.name)
                XCTAssertEqual(retrievedSansa.weight, sansa.weight)
                
                XCTAssertEqual(retrievedSansa.wolf, sansa.wolf)
                
                XCTAssertEqual(retrievedSansa.siblings!.count, sansa.siblings!.count)
                
                /** The order is not guaranteed ATM */
                XCTAssertEqual(retrievedSansa.siblings![0], arya)
                XCTAssertEqual(retrievedSansa.siblings![1], brand)
            }
        }
    }
    
    func testStringsAreStoredAndRetrievedSuccessfully() {
        let object = TestClass()
        
        swifty.add(object) { result in
            
            self.swifty.get(TestClass.self).filter("number" == object.number) { result in
                
                let retrievedObject = result.value!.first!
                
                XCTAssertEqual(retrievedObject.string, object.string)
                XCTAssertEqual(retrievedObject.character, object.character)
                XCTAssertEqual(retrievedObject.bool, object.bool)
                
                XCTAssertEqual(retrievedObject.int, object.int)
                XCTAssertEqual(retrievedObject.int8, object.int8)
                XCTAssertEqual(retrievedObject.int16, object.int16)
                XCTAssertEqual(retrievedObject.int32, object.int32)
                XCTAssertEqual(retrievedObject.int64, object.int64)
                
                XCTAssertEqual(retrievedObject.uint, object.uint)
                XCTAssertEqual(retrievedObject.uint8, object.uint8)
                XCTAssertEqual(retrievedObject.uint16, object.uint16)
                XCTAssertEqual(retrievedObject.uint32, object.uint32)
                XCTAssertEqual(retrievedObject.uint64, object.uint64)
                
                XCTAssertEqual(retrievedObject.double, object.double)
                XCTAssertEqual(retrievedObject.float, object.float)
                
                XCTAssertEqual(retrievedObject.data, object.data)
                XCTAssertLessThan(abs(retrievedObject.date.timeIntervalSinceNow - object.date.timeIntervalSinceNow), 0.0005)
                XCTAssertEqual(retrievedObject.number, object.number)
                
                XCTAssertEqual(retrievedObject.storable, object.storable)
                XCTAssertEqual(retrievedObject.storableSet, object.storableSet)
                XCTAssertEqual(retrievedObject.storableArray, object.storableArray)
                
                XCTAssertEqual(retrievedObject.stringArray, object.stringArray)
                XCTAssertEqual(retrievedObject.intArray, object.intArray)
                XCTAssertEqual(retrievedObject.doubleArray, object.doubleArray)
                
                /*
                expect(retrievedObject.optionalString).to(equal(object.optionalString))
                expect(retrievedObject.optionalCharacter).to(equal(object.optionalCharacter))
                expect(retrievedObject.optionalBool).to(equal(object.optionalBool))
                
                expect(retrievedObject.optionalInt).to(equal(object.optionalInt))
                expect(retrievedObject.optionalInt8).to(equal(object.optionalInt8))
                expect(retrievedObject.optionalInt16).to(equal(object.optionalInt16))
                expect(retrievedObject.optionalInt32).to(equal(object.optionalInt32))
                expect(retrievedObject.optionalInt64).to(equal(object.optionalInt64))
                
                expect(retrievedObject.optionalUint).to(equal(object.optionalUint))
                expect(retrievedObject.optionalUint8).to(equal(object.optionalUint8))
                expect(retrievedObject.optionalUint16).to(equal(object.optionalUint16))
                expect(retrievedObject.optionalUint32).to(equal(object.optionalUint32))
                expect(retrievedObject.optionalUint64).to(equal(object.optionalUint64))
                
                expect(retrievedObject.optionalDouble).to(equal(object.optionalDouble))
                expect(retrievedObject.optionalFloat).to(equal(object.optionalFloat))
                
                expect(retrievedObject.optionalData).to(equal(object.optionalData))
                expect(retrievedObject.optionalNumber).to(equal(object.optionalNumber))
                
                expect(retrievedObject.optionalDate!.timeIntervalSince1970).to(beCloseTo(object.optionalDate!.timeIntervalSince1970, within: 0.0005))
                
                expect(retrievedObject.optionalStorable).to(equal(object.optionalStorable))
                expect(retrievedObject.optionalStorableSet).to(equal(object.optionalStorableSet))
                expect(retrievedObject.optionalStorableArray).to(equal(object.optionalStorableArray))
                
                expect(retrievedObject.optionalStringArray).to(equal(object.optionalStringArray))
                expect(retrievedObject.optionalIntArray).to(equal(object.optionalIntArray))
                expect(retrievedObject.optionalDoubleArray).to(equal(object.optionalDoubleArray))
                */
            }
        }
    }
}

func ==(left: Wolf, right: Wolf) -> Bool {
    return left.age == right.age && left.name == right.name
}

extension Wolf: Equatable {}


func ==(left: Stark, right: Stark) -> Bool {
    return left.age == right.age && left.name == right.name && left.weight == right.weight
}

extension Stark: Equatable {}
