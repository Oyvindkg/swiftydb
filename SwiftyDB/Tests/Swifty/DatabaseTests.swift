//
//  DatabaseTests.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 30/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import Nimble
import PromiseKit

@testable import SwiftyDB


/** High-level testing of the database making sure properties are added and retreived correctly */
class DatabaseTests: XCTestCase {

    var configuration = Configuration(name: "database_test")
    
    var database = Database(name: "database_test")
    
    var lady: Wolf {
        return Wolf(name: "Lady", age: 5)
    }
    
    var sansa: Stark {
        let sansa = Stark(name: "Sansa",   weight: 50, age: 14, wolf: lady)
        
        let arya  = Stark(name: "Arya",    weight: 45, age: 10)
        let brand = Stark(name: "Brandon", weight: 40, age: 9)
        
        sansa.siblings = [arya, brand]
        
        return sansa
    }
    
    override func setUp() {
        super.setUp()
        
        try? FileManager.default.removeItem(atPath: configuration.location.path)
        
        self.database = Database(configuration: configuration)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAddingObjectsDoesNotThrowError() {
        waitUntil { done in
            _ = self.database.add(self.lady).then {
                done()
            }
        }
    }
    
    func testAddingNestedObjectsDoesNotThrowError() {
        waitUntil { done in
            _ = self.database.add(self.sansa).then {
                done()
            }
        }
    }
    
    func testRetreivingObjectsDoesNotThrowError() {
        waitUntil { done in
            _ = firstly {
                self.database.add(self.lady)
            }.then {
                self.database.get(Wolf.self)
            }.then { _ in
                done()
            }
        }
    }

    func testRetreivingNestedObjectsDoesNotThrowError() {
        waitUntil { done in
            _ = firstly {
                self.database.add(self.sansa)
            }.then {
                self.database.get(Stark.self)
            }.then { _ in
                done()
            }
        }
    }
}


// MARK: - Property retrieval tests

extension DatabaseTests {
    
    func testStringIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
                }.then {
                    self.database.get(TestClass.self) as Promise<[TestClass]>
                }.then { objects -> Void in
                    expect(objects.first?.string) == object.string
                    
                    done()
            }
        }
    }
    
    func testCharacterIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
                }.then {
                    self.database.get(TestClass.self) as Promise<[TestClass]>
                }.then { objects -> Void in
                    expect(objects.first?.character) == object.character
                    
                    done()
            }
        }
    }
    
    func testBooleanIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
                }.then {
                    self.database.get(TestClass.self) as Promise<[TestClass]>
                }.then { objects -> Void in
                    expect(objects.first?.bool) == object.bool
                    
                    done()
            }
        }
    }
    
    func testIntIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
                }.then {
                    self.database.get(TestClass.self) as Promise<[TestClass]>
                }.then { objects -> Void in
                    expect(objects.first?.int) == object.int
                    
                    done()
            }
        }
    }
    
    func testInt8IsRetreivedCorrectly() {
        
        let object = TestClass()
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
                }.then {
                    self.database.get(TestClass.self) as Promise<[TestClass]>
                }.then { objects -> Void in
                    expect(objects.first?.int8) == object.int8
                    
                    done()
            }
        }
    }
    
    func testInt16IsRetreivedCorrectly() {
        
        let object = TestClass()
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
                }.then {
                    self.database.get(TestClass.self) as Promise<[TestClass]>
                }.then { objects -> Void in
                    expect(objects.first?.int16) == object.int16
                    
                    done()
            }
        }
    }
    
    func testInt32IsRetreivedCorrectly() {
        
        let object = TestClass()
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
                }.then {
                    self.database.get(TestClass.self) as Promise<[TestClass]>
                }.then { objects -> Void in
                    expect(objects.first?.int32) == object.int32
                    
                    done()
            }
        }
    }
    
    func testInt64IsRetreivedCorrectly() {
        
        let object = TestClass()
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
                }.then {
                    self.database.get(TestClass.self) as Promise<[TestClass]>
                }.then { objects -> Void in
                    expect(objects.first?.int64) == object.int64
                    
                    done()
            }
        }
    }
    
    func testUIntIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
                }.then {
                    self.database.get(TestClass.self) as Promise<[TestClass]>
                }.then { objects -> Void in
                    expect(objects.first?.uint) == object.uint
                    
                    done()
            }
        }
    }
    
    func testUInt8IsRetreivedCorrectly() {
        
        let object = TestClass()
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
                }.then {
                    self.database.get(TestClass.self) as Promise<[TestClass]>
                }.then { objects -> Void in
                    expect(objects.first?.uint8) == object.uint8
                    
                    done()
            }
        }
    }
    
    func testUInt16IsRetreivedCorrectly() {
        
        let object = TestClass()
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
                }.then {
                    self.database.get(TestClass.self) as Promise<[TestClass]>
                }.then { objects -> Void in
                    expect(objects.first?.uint16) == object.uint16
                    
                    done()
            }
        }
    }
    
    func testUInt32IsRetreivedCorrectly() {
        
        let object = TestClass()
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
                }.then {
                    self.database.get(TestClass.self) as Promise<[TestClass]>
                }.then { objects -> Void in
                    expect(objects.first?.uint32) == object.uint32
                    
                    done()
            }
        }
    }
    
    func testUInt64IsRetreivedCorrectly() {
        
        let object = TestClass()
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
                }.then {
                    self.database.get(TestClass.self) as Promise<[TestClass]>
                }.then { objects -> Void in
                    expect(objects.first?.uint64) == object.uint64
                    
                    done()
            }
        }
    }
    
    func testFloatIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
                }.then {
                    self.database.get(TestClass.self) as Promise<[TestClass]>
                }.then { objects -> Void in
                    expect(objects.first?.float) == object.float
                    
                    done()
            }
        }
    }
    
    func testDoubleIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
                }.then {
                    self.database.get(TestClass.self) as Promise<[TestClass]>
                }.then { objects -> Void in
                    expect(objects.first?.double) == object.double
                    
                    done()
            }
        }
    }
    
    func testDateIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
                }.then {
                    self.database.get(TestClass.self) as Promise<[TestClass]>
                }.then { objects -> Void in
                    expect(objects.first?.date.timeIntervalSince(object.date)) == 0 ± 0.001
                    
                    done()
            }
        }
    }
    
    func testDataIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
                }.then {
                    self.database.get(TestClass.self) as Promise<[TestClass]>
                }.then { objects -> Void in
                    expect(objects.first?.data) == object.data
                    
                    done()
            }
        }
    }
    
    func testNumberIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
                }.then {
                    self.database.get(TestClass.self) as Promise<[TestClass]>
                }.then { objects -> Void in
                    expect(objects.first?.number) == object.number
                    
                    done()
            }
        }
    }
    
    func testStorableArrayIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
                }.then {
                    self.database.get(TestClass.self) as Promise<[TestClass]>
                }.then { objects -> Void in
                    expect(objects.first?.storableArray) == object.storableArray
                    
                    done()
            }
        }
    }
    
    func testStorableIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
                }.then {
                    self.database.get(TestClass.self) as Promise<[TestClass]>
                }.then { objects -> Void in
                    expect(objects.first?.storable) == object.storable
                    
                    done()
            }
        }
    }
    
    func testStorableSetIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
                }.then {
                    self.database.get(TestClass.self) as Promise<[TestClass]>
                }.then { objects -> Void in
                    expect(objects.first?.storableSet) == object.storableSet
                    
                    done()
            }
        }
    }
    
    func testStringArrayIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
                }.then {
                    self.database.get(TestClass.self) as Promise<[TestClass]>
                }.then { objects -> Void in
                    expect(objects.first?.stringArray) == object.stringArray
                    
                    done()
            }
        }
    }
    
    func testIntArrayIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
                }.then {
                    self.database.get(TestClass.self) as Promise<[TestClass]>
                }.then { objects -> Void in
                    expect(objects.first?.intArray) == object.intArray
                    
                    done()
            }
        }
    }
    
    func testDoubleArrayIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
                }.then {
                    self.database.get(TestClass.self) as Promise<[TestClass]>
                }.then { objects -> Void in
                    expect(objects.first?.doubleArray) == object.doubleArray
                    
                    done()
            }
        }
    }
    
    
}



//MARK: - Optional property retrieval tests

extension DatabaseTests {
    
    func testOptionalStringIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
                }.then {
                    self.database.get(TestClass.self) as Promise<[TestClass]>
                }.then { objects -> Void in
                    expect(objects.first?.optionalString) == object.optionalString
                    
                    done()
            }
        }
    }
    
    func testOptionalCharacterIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
                }.then {
                    self.database.get(TestClass.self) as Promise<[TestClass]>
                }.then { objects -> Void in
                    expect(objects.first?.optionalCharacter) == object.optionalCharacter
                    
                    done()
            }
        }
    }
    
    func testOptionalBooleanIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
                }.then {
                    self.database.get(TestClass.self) as Promise<[TestClass]>
                }.then { objects -> Void in
                    expect(objects.first?.optionalBool) == object.optionalBool
                    
                    done()
            }
        }
    }
    
    func testOptionalIntIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
                }.then {
                    self.database.get(TestClass.self) as Promise<[TestClass]>
                }.then { objects -> Void in
                    expect(objects.first?.optionalInt) == object.optionalInt
                    
                    done()
            }
        }
    }
    
    func testOptionalInt8IsRetreivedCorrectly() {
        
        let object = TestClass()
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
                }.then {
                    self.database.get(TestClass.self) as Promise<[TestClass]>
                }.then { objects -> Void in
                    expect(objects.first?.optionalInt8) == object.optionalInt8
                    
                    done()
            }
        }
    }
    
    func testOptionalInt16IsRetreivedCorrectly() {
        
        let object = TestClass()
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
                }.then {
                    self.database.get(TestClass.self) as Promise<[TestClass]>
                }.then { objects -> Void in
                    expect(objects.first?.optionalInt16) == object.optionalInt16
                    
                    done()
            }
        }
    }
    
    func testOptionalInt32IsRetreivedCorrectly() {
        
        let object = TestClass()
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
                }.then {
                    self.database.get(TestClass.self) as Promise<[TestClass]>
                }.then { objects -> Void in
                    expect(objects.first?.optionalInt32) == object.optionalInt32
                    
                    done()
            }
        }
    }
    
    func testOptionalInt64IsRetreivedCorrectly() {
        
        let object = TestClass()
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
                }.then {
                    self.database.get(TestClass.self) as Promise<[TestClass]>
                }.then { objects -> Void in
                    expect(objects.first?.optionalInt64) == object.optionalInt64
                    
                    done()
            }
        }
    }
    
    func testOptionalUIntIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
            }.then {
                self.database.get(TestClass.self) as Promise<[TestClass]>
            }.then { objects -> Void in
                expect(objects.first?.optionalUint) == object.optionalUint
                    
                done()
            }
        }
    }
    
    func testOptionalUInt8IsRetreivedCorrectly() {
        
        let object = TestClass()
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
            }.then {
                self.database.get(TestClass.self) as Promise<[TestClass]>
            }.then { objects -> Void in
                expect(objects.first?.optionalUint8) == object.optionalUint8
                    
                done()
            }
        }
    }
    
    func testOptionalUInt16IsRetreivedCorrectly() {
        
        let object = TestClass()
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
            }.then {
                self.database.get(TestClass.self) as Promise<[TestClass]>
            }.then { objects -> Void in
                expect(objects.first?.optionalUint16) == object.optionalUint16
                
                done()
            }
        }
    }
    
    func testOptionalUInt32IsRetreivedCorrectly() {
        
        let object = TestClass()
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
            }.then {
                self.database.get(TestClass.self) as Promise<[TestClass]>
            }.then { objects -> Void in
                expect(objects.first?.optionalUint32) == object.optionalUint32
                    
                done()
            }
        }
    }
    
    func testOptionalUInt64IsRetreivedCorrectly() {
        
        let object = TestClass()
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
            }.then {
                self.database.get(TestClass.self) as Promise<[TestClass]>
            }.then { objects -> Void in
                expect(objects.first?.optionalUint64) == object.optionalUint64
                
                done()
            }
        }
    }
    
    func testOptionalFloatIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
                }.then {
                    self.database.get(TestClass.self) as Promise<[TestClass]>
                }.then { objects -> Void in
                    expect(objects.first?.optionalFloat) == object.optionalFloat
                    
                    done()
            }
        }
    }
    
    func testOptionalDoubleIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
                }.then {
                    self.database.get(TestClass.self) as Promise<[TestClass]>
                }.then { objects -> Void in
                    expect(objects.first?.optionalDouble) == object.optionalDouble
                    
                    done()
            }
        }
    }
    
    func testOptionalDateIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
                }.then {
                    self.database.get(TestClass.self) as Promise<[TestClass]>
                }.then { objects -> Void in
                    expect(objects.first?.optionalDate?.timeIntervalSince(object.optionalDate!)) == 0 ± 0.001
                    
                    done()
            }
        }
    }
    
    func testOptionalDataIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
                }.then {
                    self.database.get(TestClass.self) as Promise<[TestClass]>
                }.then { objects -> Void in
                    expect(objects.first?.optionalData) == object.optionalData
                    
                    done()
            }
        }
    }
    
    func testOptionalNumberIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
                }.then {
                    self.database.get(TestClass.self) as Promise<[TestClass]>
                }.then { objects -> Void in
                    expect(objects.first?.optionalNumber) == object.optionalNumber
                    
                    done()
            }
        }
    }
    
    func testOptionalStorableArrayIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
                }.then {
                    self.database.get(TestClass.self) as Promise<[TestClass]>
                }.then { objects -> Void in
                    expect(objects.first?.optionalStorableArray) == object.optionalStorableArray
                    
                    done()
            }
        }
    }
    
    func testOptionalStorableIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
                }.then {
                    self.database.get(TestClass.self) as Promise<[TestClass]>
                }.then { objects -> Void in
                    expect(objects.first?.optionalStorable) == object.optionalStorable
                    
                    done()
            }
        }
    }
    
    func testOptionalStorableSetIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
                }.then {
                    self.database.get(TestClass.self) as Promise<[TestClass]>
                }.then { objects -> Void in
                    expect(objects.first?.optionalStorableSet) == object.optionalStorableSet
                    
                    done()
            }
        }
    }
    
    func testOptionalStringArrayIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
                }.then {
                    self.database.get(TestClass.self) as Promise<[TestClass]>
                }.then { objects -> Void in
                    expect(objects.first?.optionalStringArray) == object.optionalStringArray
                    
                    done()
            }
        }
    }
    
    func testOptionalIntArrayIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
                }.then {
                    self.database.get(TestClass.self) as Promise<[TestClass]>
                }.then { objects -> Void in
                    expect(objects.first?.optionalIntArray) == object.optionalIntArray
                    
                    done()
            }
        }
    }
    
    func testOptionalDoubleArrayIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
            }.then {
                self.database.get(TestClass.self) as Promise<[TestClass]>
            }.then { objects -> Void in
                expect(objects.first?.optionalDoubleArray) == object.optionalDoubleArray
                
                done()
            }
        }
    }
}


// MARK: - Complete object retrieval tests

extension DatabaseTests {
    
    func testAddedObjectsAreRetrievedCorrectly() {
        
        waitUntil { done in
            _ = firstly {
                self.database.add(self.sansa)
            }.then {
                self.database.get(Stark.self).where("name" == "Sansa")
            }.then { starks in
                return starks.first!
            }.then { retrievedSansa -> Void in
                expect(retrievedSansa) == self.sansa
                
                done()
            }
        }
    }
}

func ==(left: Wolf, right: Wolf) -> Bool {
    return left.age == right.age && left.name == right.name
}

extension Wolf: Equatable {}


func ==(left: Stark, right: Stark) -> Bool {
    return left.age == right.age && left.name == right.name && left.weight == right.weight && left.wolf == right.wolf && left.siblings ?? [] == right.siblings ?? []
}

extension Stark: Equatable {}
