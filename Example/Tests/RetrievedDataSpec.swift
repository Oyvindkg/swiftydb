//
//  RetrievedDataSpec.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 13/01/16.
//

import Quick
import Nimble
import SwiftyDB
import TinySQLite

class RetrievedDataSpec: SwiftyDBSpec {
    override func spec() {
        super.spec()
        
        let database = SwiftyDB(databaseName: "test_database")
        
        describe("Datatypes retrieved matches datatypes stored") {
            let object = TestClass()
            database.addObject(object)
            
            let data = database.dataForType(TestClass.self).value!.first!
            
            context("Text types matches") {
                it("should return String") {
                    expect(data["string"] is String).to(beTrue())
                }
                it("should return NSString") {
                    expect(data["nsstring"] is NSString).to(beTrue())
                }
                it("should return Character") {
                    expect(data["character"] is Character).to(beTrue())
                }
            }
            
            context("NSObject types matches") {
                it("should return NSDate") {
                    expect(data["date"] is NSDate).to(beTrue())
                }
                it("should return NSData") {
                    expect(data["data"] is NSData).to(beTrue())
                }
                it("should return NSNumber") {
                    expect(data["number"] is NSNumber).to(beTrue())
                }
            }
            
            context("Numeric types matches") {
                it("should return Int") {
                    expect(data["int"] is Int).to(beTrue())
                }
                it("should return Int8") {
                    expect(data["int8"] is Int8).to(beTrue())
                }
                it("should return Int16") {
                    expect(data["int16"] is Int16).to(beTrue())
                }
                it("should return Int32") {
                    expect(data["int32"] is Int32).to(beTrue())
                }
                it("should return Int64") {
                    expect(data["int64"] is Int64).to(beTrue())
                }
                it("should return UInt") {
                    expect(data["uint"] is UInt).to(beTrue())
                }
                it("should return UInt8") {
                    expect(data["uint8"] is UInt8).to(beTrue())
                }
                it("should return UInt16") {
                    expect(data["uint16"] is UInt16).to(beTrue())
                }
                it("should return UInt32") {
                    expect(data["uint32"] is UInt32).to(beTrue())
                }
                it("should return UInt64") {
                    expect(data["uint64"] is UInt64).to(beTrue())
                }
                
                it("should return Bool") {
                    expect(data["bool"] is Bool).to(beTrue())
                }
                
                it("should return Float") {
                    expect(data["float"] is Float).to(beTrue())
                }
                it("should return Double") {
                    expect(data["double"] is Double).to(beTrue())
                }
            
                it("should return NSArray") {
                    expect(data["array"]! is NSArray).to(beTrue())
                }
                
                it("should return NSDictionary") {
                    expect(data["dictionary"]! is NSDictionary).to(beTrue())
                }
            }
        }
    }
}
