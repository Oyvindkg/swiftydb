//
//  Database.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 21/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

protocol DatabaseType {
    
    func add<T: Storable>(objects: [T]) throws
    
    func get<T: Storable>(query: Query<T>, nested: Bool) throws -> [T]
    
    func delete<T: Storable>(query: Query<T>) throws
    
    func migrate(type: Storable.Type, fromTypeInformation typeInformation: TypeInformation) throws -> UInt
    
    func create(index: _IndexType) throws
}

protocol DatabaseRetrieverType {
    func get(query: _QueryType, nested: Bool) throws -> [Writer]
}

protocol DatabaseInserterType {
    func add(readers: [Reader]) throws
}

protocol DatabaseDeleterType {
    func delete(query: _QueryType) throws
}

