//
//  SQLiteDatabase.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 21/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import TinySQLite

/** 
 An interface wrapping an SQLite database.
 
 This structure simply maps data to or from objects, and makes sure the tables are up to date, but delegates the query execution to other components such as the `SQLiteDatabaseMigrator`.
*/
struct SQLiteDatabase: BackingDatabase {

    let queue: DatabaseQueue
    
    var migrator = SQLiteDatabase.Migrator()
    var indexer  = SQLiteDatabase.Indexer()
    
    init(configuration: Database.Configuration) {
        
        /* Copy any exsiting database to create a sandbox database */
        if configuration.mode == .sandbox {
            try? FileManager.default.removeItem(atPath: configuration.location.path)
            
            /** Create a copy of the database for sandbox mode */
            try? FileManager.default.copyItem(atPath: configuration.location(for: .normal).path,
                                              toPath: configuration.location.path)
        }
        
        queue = DatabaseQueue(location: configuration.location)
    }
    
    mutating func add<T : Storable>(objects: [T]) throws {
        
        let readers = objects.flatMap { object in
            return ObjectSerializer.readers(for: object)
        }

        for reader in readers {
            try migrator.updateTable(for: reader.storableType, ifNecessaryOn: queue)
            try indexer.updateIndices(for: reader.storableType, ifNecessaryOn: queue)
        }
        
        try SQLiteDatabase.Inserter.add(readers: readers, on: queue)
    }
    
    mutating func get<Query>(using query: Query) throws -> [Query.Subject] where Query : StorableQuery {
        
        try migrator.updateTable(for: query.type, ifNecessaryOn: queue)
        try indexer.updateIndices(for: query.type, ifNecessaryOn: queue)
        
        let writers = try SQLiteDatabaseRetriever.get(using: query, on: queue)
        
        return ObjectMapper.objects(mappedBy: writers)
    }
    
    mutating func delete(using query: AnyQuery) throws {
        try migrator.updateTable(for: query.type, ifNecessaryOn: queue)
        try indexer.updateIndices(for: query.type, ifNecessaryOn: queue)

        try SQLiteDatabase.Deleter.delete(query: query, on: queue)
    }
}
