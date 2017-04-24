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
    
    mutating func delete<Query>(using query: Query) throws where Query : StorableQuery
    
    mutating func migrate(type: Storable.Type, fromTypeInformation typeInformation: TypeInformation) throws -> UInt
    
    mutating func createIndex(with indexer: Indexer) throws
}

extension BackingDatabase {
    
    mutating func add<T: Storable>(_ object: T) throws {
        try add(objects: [object])
    }
    
    mutating func add<T: Storable>(objects: T...) throws {
        try add(objects: objects)
    }
}
