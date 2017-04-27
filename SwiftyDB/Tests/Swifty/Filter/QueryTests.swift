//
//  QueryTests.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 29/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import Nimble

@testable import SwiftyDB


class QueryTests: XCTestCase {
    fileprivate let intValue    = 7
    
    
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
//    func testLimitIsSet() {
//        let query: Query<Stark, [Stark]> = Query(database: databaseMock!).limit(intValue)
//        
//        expect(query.limit).to(equal(intValue))
//    }
//    
//    func testOffsetIsSet() {
//        let query: Query<Stark, [Stark]> = Query(database: databaseMock!).offset(intValue)
//        
//        expect(query.offset).to(equal(intValue))
//    }
//    
//    func testFilterIsSet() {
//        let query: Query<Stark, [Stark]> = Query(database: databaseMock!).filter("name" == "Eddard")
//        
//        expect(query.filter as? SwiftyDB.Expression).to(equal(Expression.Equal("name", "Eddard")))
//    }
}
