//
//  SQLiteDatabaseTableCreator.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 22/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import TinySQLite

class SQLiteDatabaseTableCreator {
    
    let databaseQueue: DatabaseQueue
    let queryFactory: SQLiteQueryFactory
    
    var existingTables: Set<String> = []
    
    init(databaseQueue: DatabaseQueue, queryFactory: SQLiteQueryFactory) {
        self.databaseQueue = databaseQueue
        self.queryFactory = queryFactory
    }
    
    func createTableForTypeIfNecessary(_ type: Storable.Type) throws {
        let reader = Mapper.readerForType(type)
        
        try createTableForReader( reader )
    }
    
    func createTableForReadersIfNecessary(_ readers: [Reader]) throws {
        
        for reader in readers {
            let tableExists = try tableExistsForReader(reader)

            guard !tableExists else {
                continue
            }
            
            try createTableForReader(reader)
        }
    }
    
    fileprivate func createTableForReader(_ reader: Reader) throws {
        
        try createTablesForNestedReadersIfNecessary(reader)
        
        /* Table was created for a nested reader */
        if try tableExistsForReader(reader) {
            return
        }
        
        let query = queryFactory.createTableQueryForReader(reader)
        
        try databaseQueue.database { database in
            try database.prepare(query.query)
                .executeUpdate(query.parameters)
                .finalize()
        }
        
        existingTables.insert(String(describing: reader.type))
    }
    
    fileprivate func createTablesForNestedReadersIfNecessary(_ reader: Reader) throws {
        
        /* Nested storable objects */
        try createTableForReadersIfNecessary( reader.mappables.map { $0.1 as! Reader } )
        
        /* Nested arrays and sets of storable objects */
        for (_, childMaps) in reader.mappableArrays {
            let childReaders: [Reader] = childMaps.matchType()
            
            try createTableForReadersIfNecessary(childReaders)
        }
    }
    
    fileprivate func tableExistsForReader(_ reader: Reader) throws -> Bool {
        return try tableExistsForType(reader.type as! Storable.Type)
    }
    
    fileprivate func tableExistsForType(_ type: Storable.Type) throws -> Bool {
        let name = String(describing: type)

        guard !existingTables.contains( name ) else {
            return true
        }
        
        var containsTable = false
        
        try databaseQueue.database { database in
            containsTable = try database.containsTable(name)
        }
        
        if containsTable {
            existingTables.insert(name)
        }
        
        return containsTable
    }
    
}
