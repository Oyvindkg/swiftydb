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
                var success = false
                
                waitUntil { done in
                    database.addObjects([TestClass()]) { (result) -> Void in
                        switch result {
                        case .Success:
                            success = true
                        case .Error:
                            success = false
                        }
                        done()
                    }
                }
                
                it("Should add objects") {
                    expect(success).to(beTrue())
                }
                
                success = false
                waitUntil { done in
                    database.addObject(TestClass()) { (result) -> Void in
                        switch result {
                        case .Success:
                            success = true
                        case .Error:
                            success = false
                        }
                        done()
                    }
                }
                
                it("Should add object") {
                    expect(success).to(beTrue())
                }
            }
            
            context("Should retrieve data") {
                let object = TestClass()
                try? database.addObject(object)
                
                var retrievedData: Any?
                waitUntil { done in
                    database.dataForType(TestClass.self, matchingFilters: ["primaryKey": object.primaryKey], withCompletionHandler: { (result) -> Void in
                        switch result {
                        case .Success(let data):
                            retrievedData = data
                        default:
                            break
                        }
                        done()
                    })
                }
                
                it("Should retrieve object") {
                    expect(retrievedData).notTo(beNil())
                }
            }
            
            context("Should delete object") {
                let object = TestClass()
                try? database.addObject(object)
                
                var success = false
                waitUntil { done in
                    database.deleteObjectsForType(TestClass.self, matchingFilters: ["primaryKey": object.primaryKey], withCompletionHandler: { (result) -> Void in
                        switch result {
                        case .Success:
                            success = true
                        case .Error:
                            success = false
                        }
                        done()
                    })
                }
                
                expect(success).to(beTrue())
            }
        }
    }
}