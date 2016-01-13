//
//  DatabaseManipulationSpec.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 13/01/16.
//

import Quick
import Nimble
import SwiftyDB
import TinySQLite

class DatabaseManipulationSpec: SwiftyDBSpec {
    
    override func spec() {
        super.spec()
        
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
    }
}