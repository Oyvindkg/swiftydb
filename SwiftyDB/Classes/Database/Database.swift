//
//  Database.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 21/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

protocol DatabaseType {
    func add<T: Storeable>(objects: [T]) throws
    
    func get<T: Storeable>(query: Query<T>, nested: Bool) throws -> [T]
    
    func delete<T: Storeable>(query: Query<T>) throws
    
    func migrate(type: Storeable.Type, fromTypeInformation typeInformation: TypeInformation) throws
    
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

