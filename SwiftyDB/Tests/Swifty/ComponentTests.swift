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
class ComponentTests: XCTestCase {

    var configuration = Database.Configuration(name: "database_test")
    
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
            }.catch { error in
                print(error)
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
            }.catch {error in
                print(error)
            }
        }
    }
}


// MARK: - Property retrieval tests

extension ComponentTests {
    
    func testStringIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        object.string = "A different string"
        
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
        
        object.character = "Z"
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
                }.then {
                    self.database.get(TestClass.self) as Promise<[TestClass]>
                }.then { objects -> Void in
                    expect(objects.first?.character) == object.character
                    
                    done()
            }.catch { error in
                print(error)
            }
        }
    }
    
    func testBooleanIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        object.bool = !object.bool
        
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
    
    
    func testRawRepresentableIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        object.rawRepresentable = .third
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
            }.then {
                self.database.get(TestClass.self) as Promise<[TestClass]>
            }.then { objects -> Void in
                expect(objects.first?.rawRepresentable) == object.rawRepresentable
                
                done()
            }
        }
    }
    
    func testRawRepresentableArrayIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        object.rawRepresentableArray = [.first, .second, .first]
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
            }.then {
                self.database.get(TestClass.self) as Promise<[TestClass]>
            }.then { objects -> Void in
                expect(objects.first?.rawRepresentableArray) == object.rawRepresentableArray
                
                done()
            }
        }
    }
    
    func testRawRepresentableSetIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        object.rawRepresentableSet = [.first, .second]
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
            }.then {
                self.database.get(TestClass.self) as Promise<[TestClass]>
            }.then { objects -> Void in
                expect(objects.first?.rawRepresentableSet) == object.rawRepresentableSet
                
                done()
            }
        }
    }
    
    
    
    func testIntIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        object.int = 31238021
        
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
        
        object.int8 = 81
        
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
        
        object.int16 = 8431
        
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
        
        object.int32 = 8431
        
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
        
        object.int64 = 8431
        
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
        
        object.uint = 6147
        
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
        
        object.uint8 = 67
        
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
        
        object.uint16 = 6147
        
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
        
        object.uint32 = 6147
        
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
        
        object.uint64 = 6147
        
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
        
        object.float = 0.123212
        
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
        
        object.double = 0.123212
        
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
        
        object.date = Date(timeIntervalSince1970: Double(arc4random()))
        
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
        
        object.data = "A different string".data(using: .utf8)!
        
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
    
    func testStorableArrayIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        object.storableArray = [lady]
        
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
        
        object.storable = lady
        
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
        
        object.storableSet = [lady]
        
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
    
    func testStorablePropertyArrayIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        object.storablePropertyArray = ["A different string"]
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
            }.then {
                self.database.get(TestClass.self) as Promise<[TestClass]>
            }.then { objects -> Void in
                expect(objects.first?.storablePropertyArray) == object.storablePropertyArray
                
                done()
            }
        }
    }
    
    func testStorablePropertySetIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        object.storablePropertySet = ["A different string"]
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
            }.then {
                self.database.get(TestClass.self) as Promise<[TestClass]>
            }.then { objects -> Void in
                expect(objects.first?.storablePropertySet) == object.storablePropertySet
                
                done()
            }
        }
    }
    
    func testStorablePropertyDictionaryIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        object.storablePropertyDictionary = ["Thor": "Another! *throws cup*"]
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
                }.then {
                    self.database.get(TestClass.self) as Promise<[TestClass]>
                }.then { objects -> Void in
                    expect(objects.first?.storablePropertyDictionary) == object.storablePropertyDictionary
                    
                    done()
            }
        }
    }
}



//MARK: - Optional property retrieval tests

extension ComponentTests {
    
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
    
    func testOptionalRawRepresentableIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        object.optionalRawRepresentable = .third
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
            }.then {
                self.database.get(TestClass.self) as Promise<[TestClass]>
            }.then { objects -> Void in
                expect(objects.first?.optionalRawRepresentable) == object.optionalRawRepresentable
                
                done()
            }
        }
    }
    
    func testOptionalRawRepresentableArrayIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        object.optionalRawRepresentableArray = [.third, .second]
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
            }.then {
                self.database.get(TestClass.self) as Promise<[TestClass]>
            }.then { objects -> Void in
                expect(objects.first?.optionalRawRepresentableArray) == object.optionalRawRepresentableArray
                
                done()
            }
        }
    }
    
    func testOptionalRawRepresentableSetIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        object.optionalRawRepresentableSet = [.first, .third]
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
            }.then {
                self.database.get(TestClass.self) as Promise<[TestClass]>
            }.then { objects -> Void in
                expect(objects.first?.optionalRawRepresentableSet) == object.optionalRawRepresentableSet
                
                done()
            }
        }
    }
    
    func testOptionalIntIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        object.optionalInt = 2133
        
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
        
        object.optionalInt8 = 59
        
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
        
        object.optionalInt16 = 21323
        
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
        
        object.optionalInt32 = 21323
        
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
        
        object.optionalInt64 = 21323
        
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
        
        object.optionalUint = 21323
        
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
        
        object.optionalUint8 = 213
        
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
        
        object.optionalUint16 = 21323
        
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
        
        object.optionalUint32 = 21323
        
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
        
        object.optionalUint64 = 21323
        
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
        
        object.optionalFloat = 0.12312
        
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
        
        object.optionalDouble = 0.12312121
        
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
        
        object.optionalDate = Date(timeIntervalSince1970: Double(arc4random()))
        
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
        
        object.optionalData = "A different string".data(using: .utf8)!
        
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

    func testOptionalStorableArrayIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        object.optionalStorableArray = [lady, lady, lady]
        
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
        
        object.optionalStorable = lady
        
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
        
        object.optionalStorableSet = [lady]
        
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
    
    func testOptionalStorablePropertyArrayIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        object.optionalStorablePropertyArray = ["A different string"]
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
                }.then {
                    self.database.get(TestClass.self) as Promise<[TestClass]>
                }.then { objects -> Void in
                    expect(objects.first?.optionalStorablePropertyArray) == object.optionalStorablePropertyArray
                    
                    done()
            }
        }
    }
    
    func testOptionalStorablePropertySetIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        object.optionalStorablePropertySet = ["A different string"]
        
        waitUntil { done in
            _ = firstly {
                self.database.add(object)
                }.then {
                    self.database.get(TestClass.self) as Promise<[TestClass]>
                }.then { objects -> Void in
                    expect(objects.first?.optionalStorablePropertySet) == object.optionalStorablePropertySet
                    
                    done()
            }
        }
    }
}


// MARK: - Complete object retrieval tests

extension ComponentTests {
    
    func testAddedObjectsAreRetrievedCorrectly() {
        
        waitUntil { done in
            _ = firstly {
                self.database.add(self.sansa)
            }.then { _ -> Promise<[Stark]> in
                let query = Query.get(Stark.self).where("name" == "Sansa")
                
                return self.database.get(using: query)
            }.then { starks in
                return starks.first!
            }.then { retrievedSansa -> Void in
                expect(retrievedSansa) == self.sansa
                
                done()
            }
        }
    }
}

func ==(lhs: Wolf, rhs: Wolf) -> Bool {
    return lhs.age == rhs.age && lhs.name == rhs.name
}

extension Wolf: Equatable {}


func ==(lhs: Stark, rhs: Stark) -> Bool {
    return lhs.age == rhs.age && lhs.name == rhs.name && lhs.weight == rhs.weight && lhs.wolf == rhs.wolf && lhs.siblings ?? [] == rhs.siblings ?? []
}

extension Stark: Equatable {}
