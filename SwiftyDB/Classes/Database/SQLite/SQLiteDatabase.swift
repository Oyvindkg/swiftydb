//
//  SQLiteDatabase.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 21/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import TinySQLite

struct SQLiteDatabase: BackingDatabase, SQLiteDatabaseTableCreator, SQLiteDatabaseInserter, SQLiteDatabaseIndexer, SQLiteDatabaseDeleter {

    
    var existingTables: Set<String> = []
    
    let databaseQueue: DatabaseQueue
    
    var migrator = SQLiteDatabaseMigrator()
    
    init(configuration: Configuration) {
        
        /* Copy any exsiting database to create a sandbox database */
        if configuration.mode == .sandbox {
            try? FileManager.default.removeItem(atPath: configuration.location.path)
            
            /** Create a copy of the database for sandbox mode */
            try? FileManager.default.copyItem(atPath: configuration.location(for: .normal).path,
                                              toPath: configuration.location.path)
        }
        
        databaseQueue = DatabaseQueue(location: configuration.location)
    }
    
    mutating func add<T : Storable>(objects: [T]) throws {
        
        let readers = objects.flatMap { object in
            return DefaultObjectSerializer.readers(for: object)
        }

        for reader in readers {
            try migrator.migrateType(reader.type as! Storable.Type, ifNecessaryOn: databaseQueue)
        }
        
        try add(readers: readers)
    }
    
    mutating func get<Query>(using query: Query) throws -> [Query.Subject] where Query : StorableQuery {
        
        try migrator.migrateType(Query.Subject.self, ifNecessaryOn: databaseQueue)
        
        
        let writers = try SQLiteDatabaseRetriever.get(using: query, on: databaseQueue)
        
        return ObjectMapper.objects(forWriters: writers)
    }
    
    mutating func delete<Query>(using query: Query) throws where Query : StorableQuery {
        try migrator.migrateType(Query.Subject.self, ifNecessaryOn: databaseQueue)
            
        try delete(query: query)
    }
}
