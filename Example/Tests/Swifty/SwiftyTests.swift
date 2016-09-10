//
//  SwiftyTests.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 30/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import Nimble

@testable import SwiftyDB


/** Component testing the database */
class SwiftyTests: XCTestCase {

    var swifty = Swifty(name: "database_test")
    
    override func setUp() {
        super.setUp()
        
        self.swifty = Swifty(name: "database_test")
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
            
            expect(result.errorMessage).to(beNil())
            
            self.swifty.get(Stark.self).filter("name" == "Sansa") { result in
                let retrievedSansa = result.value!.first!
                
                
                expect(retrievedSansa.age).to(equal(sansa.age))
                expect(retrievedSansa.name).to(equal(sansa.name))
                expect(retrievedSansa.weight).to(equal(sansa.weight))
                
                expect(retrievedSansa.wolf).to(equal(lady))
                
                expect(retrievedSansa.siblings).to(haveCount(2))
                
                /** The order is not guaranteed ATM */
                expect(retrievedSansa.siblings?[0]).to(equal(arya))
                expect(retrievedSansa.siblings?[1]).to(equal(brand))
            }
        }
    }
    
    func testStringsAreStoredAndRetrievedSuccessfully() {
        let object = TestClass()
        
        swifty.add(object) { result in
            
            self.swifty.get(TestClass.self).filter("number" == object.number) { result in
                
                let retrievedObject = result.value!.first!
                
                expect(retrievedObject.string).to(equal(object.string))
                expect(retrievedObject.character).to(equal(object.character))
                expect(retrievedObject.bool).to(equal(object.bool))
                
                expect(retrievedObject.int).to(equal(object.int))
                expect(retrievedObject.int8).to(equal(object.int8))
                expect(retrievedObject.int16).to(equal(object.int16))
                expect(retrievedObject.int32).to(equal(object.int32))
                expect(retrievedObject.int64).to(equal(object.int64))
                
                expect(retrievedObject.uint).to(equal(object.uint))
                expect(retrievedObject.uint8).to(equal(object.uint8))
                expect(retrievedObject.uint16).to(equal(object.uint16))
                expect(retrievedObject.uint32).to(equal(object.uint32))
                expect(retrievedObject.uint64).to(equal(object.uint64))
                
                expect(retrievedObject.double).to(equal(object.double))
                expect(retrievedObject.float).to(equal(object.float))
                
                expect(retrievedObject.data).to(equal(object.data))
                expect(retrievedObject.number).to(equal(object.number))
                expect(retrievedObject.date.timeIntervalSince1970).to(beCloseTo(object.date.timeIntervalSince1970, within: 0.0005))
                
                expect(retrievedObject.storeable).to(equal(object.storeable))
                expect(retrievedObject.storeableSet).to(equal(object.storeableSet))
                expect(retrievedObject.storeableArray).to(equal(object.storeableArray))
                
                expect(retrievedObject.stringArray).to(equal(object.stringArray))
                expect(retrievedObject.intArray).to(equal(object.intArray))
                expect(retrievedObject.doubleArray).to(equal(object.doubleArray))
                
                
                
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
                
                expect(retrievedObject.optionalStoreable).to(equal(object.optionalStoreable))
                expect(retrievedObject.optionalStoreableSet).to(equal(object.optionalStoreableSet))
                expect(retrievedObject.optionalStoreableArray).to(equal(object.optionalStoreableArray))
                
                expect(retrievedObject.optionalStringArray).to(equal(object.optionalStringArray))
                expect(retrievedObject.optionalIntArray).to(equal(object.optionalIntArray))
                expect(retrievedObject.optionalDoubleArray).to(equal(object.optionalDoubleArray))
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