//
//  Database.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 21/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

protocol BackingDatabase {
    
    mutating func add<T: Storable>(objects: [T]) throws
    
    mutating func get<Query>(using query: Query) throws -> [Query.Subject] where Query : StorableQuery
    
    mutating func delete(using query: AnyQuery) throws
}

extension BackingDatabase {
    
    mutating func add<T: Storable>(_ object: T) throws {
        try add(objects: [object])
    }
    
    mutating func add<T: Storable>(objects: T...) throws {
        try add(objects: objects)
    }
}
