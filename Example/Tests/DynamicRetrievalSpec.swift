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
        
        let database = SwiftyDB(databaseName: "test_database")
        
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
            
            context("is successful when") {
                it("is stored") {
                    expect(try! database.addObject(dynamicObject)).notTo(beNil())
                }
                
                it("is retrieved") {
                    expect(try! database.objectsForType(DynamicTestClass.self)).notTo(beNil())
                    expect(try! database.objectsForType(DynamicTestClass.self).count) == 1
                }
            }
            
            
            context("contains all data when retrieved") {
                try! database.addObject(dynamicObject)
                
                let retrievedDynamicObject = try! database.objectsForType(DynamicTestClass.self, matchingFilters: ["primaryKey": dynamicObject.primaryKey]).first!
                
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
            }
        }
    }
}
