//
//  BackingDatabaseTests.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 01/05/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import Nimble

@testable import SwiftyDB



public class BackingDatabaseTests: XCTestCase {
    
    func testAddMultipleObjectsCallsAddObjects() {
        var database = TestBackingDatabase(testCase: self)

        let sansa = Stark(name: "Sansa", weight: 60, age: 13)
        
        try! database.add(objects: sansa)
        
        database.manager.expect(function: "add(objects:)")
        database.manager.verify()
    }
    
    func testAddSingleObjectsCallsAddObjects() {
        var database = TestBackingDatabase(testCase: self)
        
        let sansa = Stark(name: "Sansa", weight: 60, age: 13)
        
        try! database.add(sansa)
        
        database.manager.expect(function: "add(objects:)")
        database.manager.verify()
    }
}
