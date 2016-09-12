//
//  SQLiteDatabaseTableCreator.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 22/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import TinySQLite

struct SQLiteDatabaseTableCreator {
    
    let databaseQueue: DatabaseQueue
    let queryFactory: SQLiteQueryFactory
    
    let existingTables: Set<String> = []
    
    init(databaseQueue: DatabaseQueue, queryFactory: SQLiteQueryFactory) {
        self.databaseQueue = databaseQueue
        self.queryFactory = queryFactory
    }
    
    func createTableForTypeIfNecessary(type: Storeable.Type) throws {
        let reader = Mapper.readerForType(type)
        
        try createTableForReader( reader )
    }
    
    func createTableForReadersIfNecessary(readers: [Reader]) throws {
        
        for reader in readers {
            let tableExists = try tableExistsForReader(reader)

            guard !tableExists else {
                continue
            }
            
            try createTableForReader(reader)
        }
    }
    
    private func createTableForReader(reader: Reader) throws {
        
        try createTablesForNestedReadersIfNecessary(reader)
        
        /* Table was created for a nested reader */
        if try tableExistsForReader(reader) {
            return
        }
        
        let query = queryFactory.createTableQueryForReader(reader)
        
        try databaseQueue.database { database in
            try! database.prepare(query.query)
                .executeUpdate(query.parameters)
                .finalize()
        }
    }
    
    private func createTablesForNestedReadersIfNecessary(reader: Reader) throws {
        
        /* Nested storeable objects */
        try createTableForReadersIfNecessary( reader.mappables.map { $0.1 as! Reader } )
        
        /* Nested arrays and sets of storeable objects */
        for (_, childMaps) in reader.mappableArrays {
            let childReaders: [Reader] = childMaps.matchType()
            
            try createTableForReadersIfNecessary(childReaders)
        }
    }
    
    private func tableExistsForReader(reader: Reader) throws -> Bool {
        return try tableExistsForType(reader.type as! Storeable.Type)
    }
    
    private func tableExistsForType(type: Storeable.Type) throws -> Bool {
        let name = String(type)

        guard !existingTables.contains( name ) else {
            return true
        }
        
        var containsTable = false
        
        try databaseQueue.database { database in
            containsTable = try database.containsTable(name)
        }
        
        return containsTable
    }
    
}