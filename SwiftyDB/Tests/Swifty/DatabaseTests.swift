//
//  DatabaseTests.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 28/04/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import Nimble

@testable import SwiftyDB

struct TestBackingDatabase: BackingDatabase {
    
    let manager: FunctionCallManager
    
    init(testCase: XCTestCase) {
        manager = FunctionCallManager(testCase: testCase)
    }
    
    mutating func get<Query>(using query: Query) throws -> [Query.Subject] where Query : StorableQuery {
        manager.calledFunction(withParameters: query)
        
        return []
    }
    
    mutating func add<T>(objects: [T]) throws where T : Storable {
        manager.calledFunction(withParameters: objects)
    }
    
    mutating func delete(using query: AnyQuery) throws {
        manager.calledFunction(withParameters: query)
    }
}

public class DatabaseTests: XCTestCase {
    
    let configuration = Database.Configuration(name: "Westeros")
    var backingDatabase: TestBackingDatabase!
    
    
    public override func setUp() {
        super.setUp()
        
        backingDatabase = TestBackingDatabase(testCase: self)
    }
    
    public override func tearDown() {
        backingDatabase = nil
        
        super.tearDown()
    }
    
    func testInitWithNameUsesTheDefaultConfiguration() {
        let database = Database(name: "Westeros")
        
        expect(database.configuration.name) == "Westeros"
        expect(database.configuration.directory) == FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        expect(database.configuration.mode.rawValue) == Database.Mode.normal.rawValue
    }
    
    func testAddsSingleObjectsUsingTheBackingDatabase() {
        let database = Database(database: backingDatabase, configuration: configuration)
        
        waitUntil { done in
            _ = database.add(Wolf(name: "Lady", age: 6)).then {
                done()
            }
        }
        
        let objects = backingDatabase.manager.lastCall(toFunction: "add(objects:)")!.parameters[0] as! [Wolf]
        
        expect(objects).to(haveCount(1))
    }
    
    
    func testAddsArraysObjectsUsingTheBackingDatabase() {
        let database = Database(database: backingDatabase, configuration: configuration)
        
        let wolves = [
            Wolf(name: "Lady", age: 6),
            Wolf(name: "Ghost", age: 6)
        ]
        
        waitUntil { done in
            _ = database.add(objects: wolves).then {
                done()
            }
        }
        
        let objects = backingDatabase.manager.lastCall(toFunction: "add(objects:)")!.parameters[0] as! [Wolf]
        
        expect(objects).to(haveCount(2))
    }
    
    func testAddsMultipleObjectsUsingTheBackingDatabase() {
        let database = Database(database: backingDatabase, configuration: configuration)
        
        let lady  = Wolf(name: "Lady", age: 6)
        let ghost = Wolf(name: "Ghost", age: 6)
        
        waitUntil { done in
            _ = database.add(objects: lady, ghost).then {
                done()
            }
        }
        
        let objects = backingDatabase.manager.lastCall(toFunction: "add(objects:)")!.parameters[0] as! [Wolf]
        
        expect(objects).to(haveCount(2))
    }
    
    func testGetTypeQueriesTheBackingDatabase() {
        let database = Database(database: backingDatabase, configuration: configuration)
        
        waitUntil { done in
            _ = database.get(Stark.self).then { _ in
                done()
            }
        }
        
        let query = backingDatabase.manager.lastCall(toFunction: "get(using:)")!.parameters[0] as! AnyQuery
        
        expect(query.type is Stark.Type) == true
        expect(query.filter).to(beNil())
        expect(query.limit).to(beNil())
        expect(query.skip).to(beNil())
        
        guard case .none = query.order else {
            return fail()
        }
    }
    
    func testGetUsingQueryPassesTheQueryToTheBackingDatabase() {
        let database = Database(database: backingDatabase, configuration: configuration)
        
        let query = Query.get(Stark.self).where("age" < 10).limit(to: 5).skip(0).order(by: "name", ascending: false)
        
        waitUntil { done in
            _ = database.get(using: query).then { _ in
                done()
            }
        }
        
        let executedQuery = backingDatabase.manager.lastCall(toFunction: "get(using:)")!.parameters[0] as! AnyQuery
        
        guard case .descending(let property) = query.order else {
            return fail()
        }
        
        expect(executedQuery.type is Stark.Type) == true
        expect(String(describing: executedQuery.filter)) == String(describing: query.filter)
        expect(executedQuery.limit) == query.limit
        expect(executedQuery.skip) == query.skip
        expect(property) == "name"
    }
    
    func testDeleteTypeQueriesTheBackingDatabase() {
        let database = Database(database: backingDatabase, configuration: configuration)
        
        waitUntil { done in
            _ = database.delete(Stark.self).then { _ in
                done()
            }
        }
        
        let query = backingDatabase.manager.lastCall(toFunction: "delete(using:)")!.parameters[0] as! AnyQuery
        
        expect(query.type is Stark.Type) == true
        expect(query.filter).to(beNil())
    }
    
    func testDeleteUsingQueryPassesTheQueryToTheBackingDatabase() {
        let database = Database(database: backingDatabase, configuration: configuration)
        
        let query = Query.delete(Stark.self).where("age" < 10)
        
        waitUntil { done in
            _ = database.delete(using: query).then { _ in
                done()
            }
        }
        
        let executedQuery = backingDatabase.manager.lastCall(toFunction: "delete(using:)")!.parameters[0] as! AnyQuery

        expect(executedQuery.type is Stark.Type) == true
        expect(String(describing: executedQuery.filter)) == String(describing: query.filter)
    }
    
}
