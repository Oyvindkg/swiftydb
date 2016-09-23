//
//  SQLiteQueryTests.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 30/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import TinySQLite

@testable import SwiftyDB

class SQLiteQueryTests: XCTestCase {

    func testTheProvidedQueryIsReturned() {
        let query = "This is a query"
        
        XCTAssertEqual(SQLiteQuery(query: query, parameters: []).query, query)
    }
    
    func testTheProvidedParametersAreReturned() {
        let query = "This is a query"
        let parameters: [SQLiteValue?] = ["param1", 2]
        
        let queryParameters = SQLiteQuery(query: query, parameters: parameters).parameters
        
        XCTAssert(queryParameters[0] is String)
        XCTAssertEqual(queryParameters[0] as! String, parameters[0] as! String, "The parameters should not be shuffled")
        
        XCTAssert(queryParameters[1] is Int)
        XCTAssertEqual(queryParameters[1] as! Int, parameters[1] as! Int, "The parameters should not be shuffled")
    }

}
