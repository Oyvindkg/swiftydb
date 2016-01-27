//
//  DynamicRetrievalSpec.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 13/01/16.
//

import Quick
import Nimble
import SwiftyDB
import TinySQLite

class DynamicRetrievalSpec: SwiftyDBSpec {
    override func spec() {
        super.spec()
        
        
        describe("Dynamic class") {
            /* Create an object and overwrite property values to make sure tye are properly assigned upon retrieval */
            let dynamicObject = DynamicTestClass()
            dynamicObject.string = "not default value"
            dynamicObject.nsstring = "not default value"
            dynamicObject.int = 123
            dynamicObject.uint = 123
            dynamicObject.number = 123
            dynamicObject.data = dynamicObject.string.dataUsingEncoding(NSUTF8StringEncoding)!
            dynamicObject.date = NSDate(timeIntervalSince1970: 123123)
            dynamicObject.bool = true
            dynamicObject.float = 123
            dynamicObject.double = 123
            dynamicObject.array = ["1"]
            dynamicObject.dictionary = ["1":1]
            dynamicObject.optionalArray = [1]
//            dynamicObject.optionalDictionary = ["1":12]
            
            context("is successful when") {
                let database = SwiftyDB(databaseName: "test_database")
                
                it("is stored") {
                    expect(database.addObject(dynamicObject).isSuccess).to(beTrue())
                }
                
                
                it("is retrieved") {
                    expect(database.objectsForType(DynamicTestClass.self).isSuccess).to(beTrue())
                    expect(database.objectsForType(DynamicTestClass.self).value?.count) == 1
                }
            }
            
            
            context("contains all data when retrieved") {
                let database = SwiftyDB(databaseName: "test_database")
                
                database.addObject(dynamicObject)
                
                let retrievedDynamicObject = database.objectsForType(DynamicTestClass.self, matchingFilter: ["primaryKey": dynamicObject.primaryKey]).value!.first!
                
                it("should contain equal String values") {
                    expect(retrievedDynamicObject.string == dynamicObject.string).to(beTrue())
                }
                it("should contain equal NSString values") {
                    expect(retrievedDynamicObject.nsstring == dynamicObject.nsstring).to(beTrue())
                }
                it("should contain equal NSNumber values") {
                    expect(retrievedDynamicObject.number == dynamicObject.number).to(beTrue())
                }
                it("should contain equal Int values") {
                    expect(retrievedDynamicObject.int == dynamicObject.int).to(beTrue())
                }
                it("should contain equal UInt values") {
                    expect(retrievedDynamicObject.uint == dynamicObject.uint).to(beTrue())
                }
                it("should contain equal Bool values") {
                    expect(retrievedDynamicObject.bool == dynamicObject.bool).to(beTrue())
                }
                it("should contain equal Float values") {
                    expect(retrievedDynamicObject.float == dynamicObject.float).to(beTrue())
                }
                it("should contain equal Double values") {
                    expect(retrievedDynamicObject.double == dynamicObject.double).to(beTrue())
                }
                it("should contain equal NSDate values") {
                    expect(retrievedDynamicObject.date.isEqualToDate(dynamicObject.date)).to(beTrue())
                }
                it("should contain equal NSData values") {
                    expect(retrievedDynamicObject.data.isEqualToData(dynamicObject.data)).to(beTrue())
                }
                it("should contain equal NSArray values") {
                    expect(retrievedDynamicObject.array == dynamicObject.array).to(beTrue())
                }
                it("should contain equal optional NSArray values") {
                    expect(retrievedDynamicObject.optionalArray == dynamicObject.optionalArray).to(beTrue())
                }
                it("should contain equal NSDictionary values") {
                     expect(retrievedDynamicObject.dictionary == dynamicObject.dictionary).to(beTrue())
                }
                it("should contain equal optional NSDictionary values") {
                    expect(retrievedDynamicObject.optionalDictionary == dynamicObject.optionalDictionary).to(beTrue())
                }
            }
        }
    }
}
