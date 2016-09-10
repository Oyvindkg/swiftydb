//
//  SQLiteQueryTests.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 30/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import Nimble
import TinySQLite

@testable import SwiftyDB

class SQLiteQueryTests: XCTestCase {

    func testTheProvidedQueryIsReturned() {
        let query = "This is a query"
        
        expect(SQLiteQuery(query: query, parameters: []).query).to(equal(query))
    }
    
    func testTheProvidedParametersAreReturned() {
        let query = "This is a query"
        let parameters: [SQLiteValue?] = ["param1", 2]
        
        let queryParameters = SQLiteQuery(query: query, parameters: parameters).parameters
        
        expect(queryParameters[0] as? String).to(equal(parameters[0] as? String))
        expect(queryParameters[1] as? Int).to(equal(parameters[1] as? Int))
    }

}
