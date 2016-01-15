//
//  AsynchronousSpec.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 13/01/16.
//

import Quick
import Nimble
import SwiftyDB
import TinySQLite

class AsynchronousSpec: SwiftyDBSpec {
    
    override func spec() {
        super.spec()
        
        let database = SwiftyDB(databaseName: "test_database")
        
        
        
        describe("Asynchronous calls") {
            context("Adding data to the database") {
                
                it("Should add objects") {
                    var result: Result<Bool>?
                    database.asyncAddObjects([TestClass()]) { (res) -> Void in
                        result = res
                    }
                    
                    expect(result?.isSuccess).toEventually(beTrue())
                    expect(result?.value != nil).toEventually(beTrue())
                }
                
                
                it("Should add object") {
                    var result: Result<Bool>?
                    database.asyncAddObject(TestClass()) { (res) -> Void in
                        result = res
                    }
                    
                    expect(result?.isSuccess).toEventually(beTrue())
                    expect(result?.value != nil).toEventually(beTrue())
                }
            }
            
            context("Should retrieve data") {
                
                it("Should retrieve data") {
                    let object = TestClass()
                    database.addObject(object)
                    
                    var result: Result<[[String: SQLiteValue?]]>?
                    database.asyncDataForType(TestClass.self, matchingFilters: ["primaryKey": object.primaryKey]) { res in
                        result = res
                    }
                    
                    expect(result?.isSuccess).toEventually(beTrue())
                    expect(result?.value != nil).toEventually(beTrue())
                }
                
                it("Should retrieve object") {
                    let object = DynamicTestClass()
                    database.addObject(object)
                    
                    var result: Result<[DynamicTestClass]>?
                    database.asyncObjectsForType(DynamicTestClass.self, matchingFilters: ["primaryKey": object.primaryKey]) { res in
                        result = res
                    }
                    
                    expect(result?.isSuccess).toEventually(beTrue())
                    expect(result?.value != nil).toEventually(beTrue())
                }
            }
            
            context("Should delete object") {
                let object = TestClass()
                database.addObject(object)
                
                var result: Result<Bool>?
                database.asyncDeleteObjectsForType(TestClass.self, matchingFilters: ["primaryKey": object.primaryKey]) { res in
                    result = res
                }
                
                it("Should retrieve object") {
                    expect(result?.isSuccess).toEventually(beTrue())
                    expect(result?.value != nil).toEventually(beTrue())
                }
            }
        }
    }
}