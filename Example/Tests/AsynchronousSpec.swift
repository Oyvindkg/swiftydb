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
        
        it("should add data") {
            expect(success).to(beTrue())
        }
    }
}