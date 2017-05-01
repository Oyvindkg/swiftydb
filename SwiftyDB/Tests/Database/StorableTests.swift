//
//  StorableTests.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 01/05/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import Nimble

@testable import SwiftyDB

public class StorableTests: XCTestCase {
    
    func testStorableNameIsClassName() {
        expect(Stark.name) == "Stark"
    }
    
    func testStorableArrayStorableTypIsElementType() {
        expect(Array<Stark>.storableType as? Stark.Type).notTo(beNil())
        expect(Array<String>.storableType).to(beNil())
    }
}
