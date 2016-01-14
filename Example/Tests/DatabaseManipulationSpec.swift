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
                    expect(database.addObject(object).isSuccess).to(beTrue())
                    expect(database.dataForType(TestClass.self, matchingFilters: filters).data?.count) == 1
                }
            }
            
            context("object is deleted") {
                it("should not contain the object after deletion") {
                    expect(database.deleteObjectsForType(TestClass.self, matchingFilters: filters).isSuccess).to(beTrue())
                    expect(database.dataForType(TestClass.self, matchingFilters: filters).data?.count) == 0
                }
            }
            
            context("object is updated") {
                it("should update existing objects") {
                    database.addObject(object)
                    
                    object.string = "Updated string"
                    
                    expect(database.addObject(object).isSuccess).to(beTrue())
                    expect(database.dataForType(TestClass.self, matchingFilters: filters).data?.count) == 1
                    
                    if let stringValue = database.dataForType(TestClass.self, matchingFilters: filters).data?.first?["string"] as? String {
                        expect(stringValue == "Updated string").to(beTrue())
                    }
                }
            }
            
            context("object is not updated if it should not") {
                it("should fail to add same object twice") {
                    database.addObject(object)
                    expect(database.addObject(object, update: false).isSuccess).to(beFalse())
                }
            }
        }
    }
}