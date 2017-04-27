//
//  MockDatabase.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 29/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import PromiseKit

@testable import SwiftyDB

struct ObjectDatabaseMock: ObjectDatabase {
    /**
     Add objects to the database
     
     - parameters:
     - objects:          the objects to be added
     - resultHandler:    an optional result handler
     */
    func add<T>(objects: [T]) -> Promise<Void> where T : Storable {
        return Promise(value: Void())
    }

    /**
     Delete objects for the provided type
     
     - parameters:
     - type:             type of the objects to be deleted
     - resultHandler:    an optional result handler
     */
    func delete(using query: AnyQuery) -> Promise<Void> {
        return Promise(value: Void())
    }

    /**
     Get objects for the provided type
     
     - parameters:
     - query:            query to be executed
     - resultHandler:    an optional result handler
     */
    func get<Query>(using query: Query) -> Promise<[Query.Subject]> where Query : StorableQuery {
        return Promise(value: [])
    }
    
}
