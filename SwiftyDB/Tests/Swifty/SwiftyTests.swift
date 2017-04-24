//
//  DatabaseTests.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 30/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest

@testable import SwiftyDB


/** Component testing the database */
class DatabaseTests: XCTestCase {

    var configuration = Configuration(name: "database_test")
    
    var database = Database(name: "database_test")
    
    override func setUp() {
        super.setUp()
        
        try? FileManager.default.removeItem(atPath: configuration.location.path)
        
        self.database = Database(configuration: configuration)
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testAddedObjectsAreRetrievedCorrectly() {
        let lady = Wolf(name: "Lady", age: 5)
        
        let arya  = Stark(name: "Arya", weight: 45, age: 10)
        let brand = Stark(name: "Brandon", weight: 40, age: 9)
        let sansa = Stark(name: "Sansa", weight: 50, age: 14, wolf: lady)

        sansa.siblings = [arya, brand]
        
        /* Add sansa */
        let addResult = try? database.executeAdd([sansa])
            
        XCTAssertNotNil(addResult)
        
        /* Get sansa */
        let getQuery: Query<Stark>  = database.get(Stark.self).where("name" == "Sansa")
        let getResult = try? database.executeGet(query: getQuery)
        
        XCTAssertNotNil(getResult)
        
        let retrievedSansa = getResult!.first!
        
        XCTAssertEqual(retrievedSansa.age, sansa.age)
        XCTAssertEqual(retrievedSansa.name, sansa.name)
        XCTAssertEqual(retrievedSansa.weight, sansa.weight)
        
        XCTAssertEqual(retrievedSansa.wolf, sansa.wolf)
        
        XCTAssertEqual(retrievedSansa.siblings!.count, sansa.siblings!.count)
        
        /** The order is not guaranteed ATM */
        XCTAssertEqual(retrievedSansa.siblings![0], arya)
        XCTAssertEqual(retrievedSansa.siblings![1], brand)
    }
    
    func testObjectsAreStoredAndRetrievedSuccessfully() {
        let object = TestClass()
        
        /* Add object */
        let addResult = try? database.executeAdd([object])
        
        XCTAssertNotNil(addResult)
        
        
        /* Get object */
        let getQuery: Query<TestClass> = database.get(TestClass.self).where("number" == object.number)
        
        let getResult = try? database.executeGet(query: getQuery)
        
        XCTAssertNotNil(getResult)
        
        let retrievedObject = getResult!.first!
        
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
        

        XCTAssertEqual(retrievedObject.optionalString, object.optionalString)
        XCTAssertEqual(retrievedObject.optionalCharacter, object.optionalCharacter)
        XCTAssertEqual(retrievedObject.optionalBool, object.optionalBool)
        
        XCTAssertEqual(retrievedObject.optionalInt, object.optionalInt)
        XCTAssertEqual(retrievedObject.optionalInt8, object.optionalInt8)
        XCTAssertEqual(retrievedObject.optionalInt16, object.optionalInt16)
        XCTAssertEqual(retrievedObject.optionalInt32, object.optionalInt32)
        XCTAssertEqual(retrievedObject.optionalInt64, object.optionalInt64)
        
        XCTAssertEqual(retrievedObject.optionalUint, object.optionalUint)
        XCTAssertEqual(retrievedObject.optionalUint8, object.optionalUint8)
        XCTAssertEqual(retrievedObject.optionalUint16, object.optionalUint16)
        XCTAssertEqual(retrievedObject.optionalUint32, object.optionalUint32)
        XCTAssertEqual(retrievedObject.optionalUint64, object.optionalUint64)
        
        XCTAssertEqual(retrievedObject.optionalDouble, object.optionalDouble)
        XCTAssertEqual(retrievedObject.optionalFloat, object.optionalFloat)
        
        XCTAssertEqual(retrievedObject.optionalData, object.optionalData)
        XCTAssertEqual(retrievedObject.optionalNumber, object.optionalNumber)
        
        XCTAssertLessThan(abs(retrievedObject.optionalDate!.timeIntervalSinceNow - object.optionalDate!.timeIntervalSinceNow), 0.0005)
        
        XCTAssertEqual(retrievedObject.optionalStorable, object.optionalStorable)
        XCTAssertEqual(retrievedObject.optionalStorableSet, object.optionalStorableSet)
        XCTAssertEqual(retrievedObject.optionalStorableArray!, object.optionalStorableArray!)
        
        XCTAssertEqual(retrievedObject.optionalStringArray!, object.optionalStringArray!)
        XCTAssertEqual(retrievedObject.optionalIntArray!, object.optionalIntArray!)
        XCTAssertEqual(retrievedObject.optionalDoubleArray!, object.optionalDoubleArray!)
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
