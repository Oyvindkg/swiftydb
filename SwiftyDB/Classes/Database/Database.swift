//
//  Database.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 21/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

protocol DatabaseType {
    
    func add<T: Storable>(_ objects: [T]) throws
    
    func get<T: Storable>(_ query: Query<T>, nested: Bool) throws -> [T]
    
    func delete<T: Storable>(_ query: Query<T>) throws
    
    func migrate(_ type: Storable.Type, fromTypeInformation typeInformation: TypeInformation) throws -> UInt
    
    func create(_ index: _IndexType) throws
}

protocol DatabaseRetrieverType {
    func get(_ query: _QueryType, nested: Bool) throws -> [Writer]
}

protocol DatabaseInserterType {
    func add(_ readers: [Reader]) throws
}

protocol DatabaseDeleterType {
    func delete(_ query: _QueryType) throws
}

