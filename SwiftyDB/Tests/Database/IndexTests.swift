//
//  IndexTests.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 01/05/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import Nimble

@testable import SwiftyDB

public class IndexTests: XCTestCase {
    
    func testIndexOnPropertiesSetsProperties() {
        let emptyIndex = Index.on()
        let index = Index.on("name", "age", "weight")
        let otherIndex = Index.on(["name", "age", "weight"])
        
        expect(emptyIndex.properties).to(haveCount(0))
        expect(index.properties).to(contain("name", "age", "weight"))
        expect(otherIndex.properties).to(contain("name", "age", "weight"))
    }
    
    func testWhereSetsTheFilters() {
        let index = Index.on("age").where("name" == "Sansa")
        
        expect(index.filter).notTo(beNil())
    }
}
