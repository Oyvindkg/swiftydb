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
    
    func add<T>(objects: [T]) -> Promise<Void> where T : Storable {
        return Promise(value: Void())
    }

    func get<T>(using query: Query<T>) -> Promise<[T]> where T : Storable {
        return Promise(value: [])
    }
    
//    func get<T : Storable>(_ type: T.Type) -> GetQuery<T> {
//        return GetQuery(database: self)
//    }
//    
    
    func delete<T>(using query: Query<T>) -> Promise<Void> where T : Storable {
        return Promise(value: Void())
    }
}
