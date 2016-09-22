//
//  Database.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 21/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

protocol Database {
    
    func add<T: Storable>(objects: [T]) throws
    
    func get<T: Storable>(query: Query<T>) throws -> [T]
    
    func delete<T: Storable>(query: Query<T>) throws
    
    func migrate(type: Storable.Type, fromTypeInformation typeInformation: TypeInformation) throws -> UInt
    
    func create(index: _Index) throws
}

protocol DatabaseRetriever {
    func get(query: _QueryProtocol) throws -> [Writer]
}

protocol DatabaseInserter {
    func add(readers: [Reader]) throws
}

protocol DatabaseDeleter {
    func delete(query: _QueryProtocol) throws
}

