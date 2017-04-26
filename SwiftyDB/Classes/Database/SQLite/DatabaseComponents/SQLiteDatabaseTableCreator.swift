//
//  SQLiteDatabaseTableCreator.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 22/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import TinySQLite

protocol SQLiteDatabaseTableCreator {
    
    var databaseQueue: DatabaseQueue { get }
    var existingTables: Set<String> { get set }
}

extension SQLiteDatabaseTableCreator {

    mutating func createTableIfNecessaryFor(readers: [Reader]) throws {
        
        for reader in readers {
            let tableExists = try tableExistsFor(reader: reader)
            
            guard !tableExists else {
                continue
            }
            
            try createTableFor(reader: reader)
        }
    }

    mutating func createTableIfNecessaryFor(type: Storable.Type) throws {
        let reader = ObjectMapper.read(type: type)
        
        try createTableFor(reader: reader )
    }
    
    fileprivate mutating func createTableFor(reader: Reader) throws {
        
        try createTablesIfNecessaryForNestedReadersIn(reader: reader)
        
        /* Table was created for a nested reader */
        if try tableExistsFor(reader: reader) {
            return
        }
        
        let query = SQLiteQueryFactory.createTableQuery(for: reader)
        
        try databaseQueue.database { database in
            try database.statement(for: query.query)
                .executeUpdate(withParameters: query.parameters)
                .finalize()
        }
        
        existingTables.insert(String(describing: reader.type))
    }
    
    fileprivate mutating func createTablesIfNecessaryForNestedReadersIn(reader: Reader) throws {
        
        /* Nested storable objects */
        try createTableIfNecessaryFor(readers: reader.mappables.map { $0.value as! Reader })
        
        /* Nested arrays and sets of storable objects */
        for (_, childMaps) in reader.mappableArrays {
            let childReaders: [Reader] = childMaps.matchType()
            
            try createTableIfNecessaryFor(readers: childReaders)
        }
    }
    
    fileprivate mutating func tableExistsFor(reader: Reader) throws -> Bool {
        return try tableExistsFor(type: reader.type as! Storable.Type)
    }
    
    fileprivate mutating func tableExistsFor(type: Storable.Type) throws -> Bool {
        let name = String(describing: type)

        guard !existingTables.contains( name ) else {
            return true
        }
        
        var containsTable = false
        
        try databaseQueue.database { database in
            containsTable = try database.contains(table: name)
        }
        
        if containsTable {
            existingTables.insert(name)
        }
        
        return containsTable
    }
    
}
