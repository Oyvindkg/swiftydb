//
//  SimpleQueryTests.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 01/05/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import Nimble

@testable import SwiftyDB

public class SimpleQueryTests: XCTestCase {

    func testDefaultOrderValueIsNone() {
        let query = SimpleQuery(type: Stark.self)
        
        var isNone = false
        
        if case .none = query.order {
            isNone = true
        }
        
        expect(isNone) == true
    }
    
    func testDefaultSkipIsNil() {
        let query = SimpleQuery(type: Stark.self)
        
        expect(query.skip).to(beNil())
    }
    
    func testDefaultLimitIsNil() {
        let query = SimpleQuery(type: Stark.self)
        
        expect(query.limit).to(beNil())
    }
    
    func testDefaultFilterIsNil() {
        let query = SimpleQuery(type: Stark.self)
        
        expect(query.filter).to(beNil())
    }
    
    func testTypeIsTheProvidedType() {
        let query = SimpleQuery(type: Stark.self)
        
        expect(query.type == Stark.self) == true
    }
    
    func testFilterIsTheProvidedFilter() {
        let filter: FilterStatement? = "name" == "sansa"
        
        let query = SimpleQuery(type: Stark.self, filter: filter)
        
        expect(String(describing: query.filter)) == String(describing: filter)
    }
    
    func testLimitIsTheProvidedLimit() {
        let query = SimpleQuery(type: Stark.self, limit: 5)
        
        expect(query.limit) == 5
    }
    
    func testSkipIsTheProvidedSkip() {
        let query = SimpleQuery(type: Stark.self, skip: 3)
        
        expect(query.skip) == 3
    }
}
