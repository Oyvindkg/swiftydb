// https://github.com/Quick/Quick

import Quick
import Nimble
import SwiftyDB
import TinySQLite

class SwiftyDBSpec: QuickSpec {
    
    override func spec() {
        
        let documentsDir : String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
        let path = documentsDir+"/test_database.sqlite"
        try? NSFileManager.defaultManager().removeItemAtPath(path)
        
        let database = SwiftyDB(databaseName: "test_database")
        
        describe("Data in database is updated") {
            let object = TestClass()
            object.primaryKey = 123
            object.string = "First string"
            
            let filters: [String: SQLiteValue?] = ["primaryKey": object.primaryKey]
            
            context("object is added") {
                it("should contain the object after it is added") {
                    expect(try? database.addObject(object)).notTo(beNil())
                    expect(try? database.dataForType(TestClass.self, matchingFilters: filters).count) == 1
                }
            }
            
            context("object is deleted") {
                it("should not contain the object after deletion") {
                    expect(try? database.deleteObjectsForType(TestClass.self, matchingFilters: filters)).notTo(beNil())
                    expect(try? database.dataForType(TestClass.self, matchingFilters: filters).count) == 0
                }
            }
            
            context("object is updated") {
                it("should update existing objects") {
                    try! database.addObject(object)
                    
                    object.string = "Updated string"
                    
                    expect(try? database.addObject(object)).notTo(beNil())
                    expect(try? database.dataForType(TestClass.self, matchingFilters: filters).count) == 1
                    
                    if let stringValue = try? database.dataForType(TestClass.self, matchingFilters: filters).first!["string"] as? String {
                        expect(stringValue == "Updated string").to(beTrue())
                    }
                }
            }
            
            context("object is not updated if it should not") {
                it("should fail to add same object twice") {
                    try! database.addObject(object)
                    expect(try? database.addObject(object, update: false)).to(beNil())
                }
            }
        }
        
        
        
        describe("Datatypes retrieved matches datatypes stored") {
            let object = TestClass()
            try! database.addObject(object)
            
            let data = try! database.dataForType(TestClass.self).first!
            
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
                it("should return Float80") {
                    expect(data["float80"] is Float80).to(beTrue())
                }
                it("should return Double") {
                    expect(data["double"] is Double).to(beTrue())
                }
            }
        }
        
        describe("Dynamic classes are retrieved properly as objects") {
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
            
            it("is stored properly") {
                expect(try? database.addObject(dynamicObject)).notTo(beNil())
            }
            
            it("is retrieved properly") {
                expect(try? database.objectsForType(DynamicTestClass.self)).notTo(beNil())
                expect(try? database.objectsForType(DynamicTestClass.self).count) == 1
            }
            
            context("All data is present in the retrieved object") {
                expect(try? database.addObject(dynamicObject)).notTo(beNil())
                
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
