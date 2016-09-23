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
    
    func createTableIfNecessaryFor(readers: [Reader]) throws {
        
        for reader in readers {
            let tableExists = try tableExistsFor(reader: reader)
            
            guard !tableExists else {
                continue
            }
            
            try createTableFor(reader: reader)
        }
    }

    func createTableIfNecessaryFor(type: Storable.Type) throws {
        let reader = Mapper.readerFor(type: type)
        
        try createTableFor(reader: reader )
    }
    
    fileprivate func createTableFor(reader: Reader) throws {
        
        try createTablesIfNecessaryForNestedReadersIn(reader: reader)
        
        /* Table was created for a nested reader */
        if try tableExistsFor(reader: reader) {
            return
        }
        
        let query = queryFactory.createTableQueryFor(reader: reader)
        
        try databaseQueue.database { database in
            try database.prepare(query.query)
                .executeUpdate(query.parameters)
                .finalize()
        }
        
        existingTables.insert(String(describing: reader.type))
    }
    
    fileprivate func createTablesIfNecessaryForNestedReadersIn(reader: Reader) throws {
        
        /* Nested storable objects */
        try createTableIfNecessaryFor(readers: reader.mappables.map { $0.value as! Reader })
        
        /* Nested arrays and sets of storable objects */
        for (_, childMaps) in reader.mappableArrays {
            let childReaders: [Reader] = childMaps.matchType()
            
            try createTableIfNecessaryFor(readers: childReaders)
        }
    }
    
    fileprivate func tableExistsFor(reader: Reader) throws -> Bool {
        return try tableExistsFor(type: reader.type as! Storable.Type)
    }
    
    fileprivate func tableExistsFor(type: Storable.Type) throws -> Bool {
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
