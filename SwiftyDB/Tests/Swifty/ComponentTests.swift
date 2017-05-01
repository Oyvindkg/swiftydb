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


/* High-level testing of the database making sure properties are added and retreived correctly */
class ComponentTests: XCTestCase {

    var configuration = Database.Configuration(name: "database_test")
    
    var database = Database(name: "database_test")
    
    var lady: Wolf {
        return Wolf(name: "Lady", age: 5)
    }
    
    var sansa: Stark {
        let sansa = Stark(name: "Sansa",   weight: 50, age: 14)
        
        let arya  = Stark(name: "Arya",    weight: 45, age: 10)
        let brand = Stark(name: "Brandon", weight: 40, age: 9)
        
        sansa.siblings = [arya, brand]
        sansa.wolf     = lady
        
        return sansa
    }
    
    override func setUp() {
        super.setUp()
        
        try? FileManager.default.removeItem(atPath: configuration.location.path)
        
        self.database = Database(configuration: configuration)
    }
    
    override func tearDown() {
        try? FileManager.default.removeItem(atPath: configuration.location.path)
        
        super.tearDown()
    }
    
    fileprivate func addAndRetrieve<T: Storable>(_ object: T) -> Promise<T> {
        let reader = ObjectMapper.read(object)
        
        let query = Query.get(T.self).where(T.identifier() == reader.identifierValue as? String)
        
        return firstly {
            self.database.add(object)
        }.then {
            self.database.get(using: query)
        }.then { retreivedObjects -> T in
            return retreivedObjects.first!
        }
    }
}


// MARK: - Storable properties

extension ComponentTests {
    
    func testStorablePropertyIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        object.storableProperty          = "To be, or not to be, that is the question"
        object.optionalStorableProperty  = "To be, or not to be, that is the question"
        object.unwrappedStorableProperty = "To be, or not to be, that is the question"
        
        waitUntil { done in
            _ = self.addAndRetrieve(object).then { retreivedObject -> Void in
                expect(retreivedObject.storableProperty) == object.storableProperty
                expect(retreivedObject.optionalStorableProperty) == object.optionalStorableProperty
                expect(retreivedObject.unwrappedStorableProperty) == object.unwrappedStorableProperty
                done()
            }
        }
    }
    
    func testNilStorablePropertyIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        object.optionalStorableProperty  = nil
        object.unwrappedStorableProperty = nil
        
        waitUntil { done in
            _ = self.addAndRetrieve(object).then { retreivedObject -> Void in
                expect(retreivedObject.optionalStorableProperty).to(beNil())
                expect(retreivedObject.unwrappedStorableProperty).to(beNil())
                done()
            }
        }
    }
    
    
    func testStorablePropertyArrayIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        object.storablePropertyArray          = [1,2,3,4,5,6]
        object.optionalStorablePropertyArray  = [1,2,3,4,5,6]
        object.unwrappedStorablePropertyArray = [1,2,3,4,5,6]
        
        waitUntil { done in
            _ = self.addAndRetrieve(object).then { retreivedObject -> Void in
                expect(retreivedObject.storablePropertyArray) == object.storablePropertyArray
                expect(retreivedObject.optionalStorablePropertyArray) == object.optionalStorablePropertyArray
                expect(retreivedObject.unwrappedStorablePropertyArray) == object.unwrappedStorablePropertyArray
                done()
            }
        }
    }
    
    func testNilStorablePropertyArrayIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        object.optionalStorablePropertyArray  = nil
        object.unwrappedStorablePropertyArray = nil
        
        waitUntil { done in
            _ = self.addAndRetrieve(object).then { retreivedObject -> Void in
                expect(retreivedObject.optionalStorablePropertyArray).to(beNil())
                expect(retreivedObject.unwrappedStorablePropertyArray).to(beNil())
                done()
            }
        }
    }
    
    
    func testStorablePropertySetIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        object.storablePropertySet          = [1,2,3,4,5,6]
        object.optionalStorablePropertySet  = [1,2,3,4,5,6]
        object.unwrappedStorablePropertySet = [1,2,3,4,5,6]
        
        waitUntil { done in
            _ = self.addAndRetrieve(object).then { retreivedObject -> Void in
                expect(retreivedObject.storablePropertySet) == object.storablePropertySet
                expect(retreivedObject.optionalStorablePropertySet) == object.optionalStorablePropertySet
                expect(retreivedObject.unwrappedStorablePropertySet) == object.unwrappedStorablePropertySet
                done()
            }
        }
    }
    
    func testNilStorablePropertySetIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        object.optionalStorablePropertySet  = nil
        object.unwrappedStorablePropertySet = nil
        
        waitUntil { done in
            _ = self.addAndRetrieve(object).then { retreivedObject -> Void in
                expect(retreivedObject.optionalStorablePropertySet).to(beNil())
                expect(retreivedObject.unwrappedStorablePropertySet).to(beNil())
                done()
            }
        }
    }
    
    
    func testStorablePropertyDictionaryIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        object.storablePropertyDictionary          = ["To be": 1]
        object.optionalStorablePropertyDictionary  = ["To be": 2]
        object.unwrappedStorablePropertyDictionary = ["To be": 3]
        
        waitUntil { done in
            _ = self.addAndRetrieve(object).then { retreivedObject -> Void in
                expect(retreivedObject.storablePropertyDictionary) == object.storablePropertyDictionary
                expect(retreivedObject.optionalStorablePropertyDictionary) == object.optionalStorablePropertyDictionary
                expect(retreivedObject.unwrappedStorablePropertyDictionary) == object.unwrappedStorablePropertyDictionary
                done()
            }
        }
    }
    
    func testNilStorablePropertyDictionaryIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        object.optionalStorablePropertyDictionary  = nil
        object.unwrappedStorablePropertyDictionary = nil
        
        waitUntil { done in
            _ = self.addAndRetrieve(object).then { retreivedObject -> Void in
                expect(retreivedObject.optionalStorablePropertyDictionary).to(beNil())
                expect(retreivedObject.unwrappedStorablePropertyDictionary).to(beNil())
                done()
            }
        }
    }
}


// MARK: - Storables

extension ComponentTests {
    
    func testStorableIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        object.storable          = sansa
        object.optionalStorable  = sansa
        object.unwrappedStorable = sansa
        
        waitUntil { done in
            _ = self.addAndRetrieve(object).then { retreivedObject -> Void in
                expect(retreivedObject.storable) == object.storable
                expect(retreivedObject.optionalStorable) == object.optionalStorable
                expect(retreivedObject.unwrappedStorable) == object.unwrappedStorable
                done()
            }
        }
    }
    
    func testNilStorableIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        object.optionalStorable  = nil
        object.unwrappedStorable = nil
        
        waitUntil { done in
            _ = self.addAndRetrieve(object).then { retreivedObject -> Void in
                expect(retreivedObject.optionalStorable).to(beNil())
                expect(retreivedObject.unwrappedStorable).to(beNil())
                done()
            }
        }
    }
    
    func testStorableArrayIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        object.storableArray          = [sansa]
        object.optionalStorableArray  = [sansa]
        object.unwrappedStorableArray = [sansa]
        
        waitUntil { done in
            _ = self.addAndRetrieve(object).then { retreivedObject -> Void in
                expect(retreivedObject.storableArray) == object.storableArray
                expect(retreivedObject.optionalStorableArray) == object.optionalStorableArray
                expect(retreivedObject.unwrappedStorableArray) == object.unwrappedStorableArray
                done()
            }
        }
    }
    
    func testNilStorableArrayIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        object.optionalStorableArray  = nil
        object.unwrappedStorableArray = nil
        
        waitUntil { done in
            _ = self.addAndRetrieve(object).then { retreivedObject -> Void in
                expect(retreivedObject.optionalStorableArray).to(beNil())
                expect(retreivedObject.unwrappedStorableArray).to(beNil())
                done()
            }
        }
    }
    
    func testStorableSetIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        object.storableSet          = [sansa]
        object.optionalStorableSet  = [sansa]
        object.unwrappedStorableSet = [sansa]
        
        waitUntil { done in
            _ = self.addAndRetrieve(object).then { retreivedObject -> Void in
                expect(retreivedObject.storableSet) == object.storableSet
                expect(retreivedObject.optionalStorableSet) == object.optionalStorableSet
                expect(retreivedObject.unwrappedStorableSet) == object.unwrappedStorableSet
                done()
            }
        }
    }
    
    func testNilStorableSetIsRetreivedCorrectly() {
        
        let object = TestClass()
        
        object.optionalStorableSet  = nil
        object.unwrappedStorableSet = nil
        
        waitUntil { done in
            _ = self.addAndRetrieve(object).then { retreivedObject -> Void in
                expect(retreivedObject.optionalStorableSet).to(beNil())
                expect(retreivedObject.unwrappedStorableSet).to(beNil())
                done()
            }
        }
    }
}
