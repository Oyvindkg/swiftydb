//
//  SQLiteDatabase.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 21/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import TinySQLite

struct SQLiteDatabase: BackingDatabase, SQLiteDatabaseIndexer, SQLiteDatabaseDeleter {

    let queue: DatabaseQueue
    
    var migrator = SQLiteDatabaseMigrator()
    
    init(configuration: Configuration) {
        
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
            return DefaultObjectSerializer.readers(for: object)
        }

        for reader in readers {
            try migrator.migrateType(reader.type as! Storable.Type, ifNecessaryOn: queue)
        }
        
        try SQLiteDatabaseInserter.add(readers: readers, on: queue)
    }
    
    mutating func get<Query>(using query: Query) throws -> [Query.Subject] where Query : StorableQuery {
        
        try migrator.migrateType(Query.Subject.self, ifNecessaryOn: queue)
        
        let writers = try SQLiteDatabaseRetriever.get(using: query, on: queue)
        
        return ObjectMapper.objects(mappedBy: writers)
    }
    
    mutating func delete<Query>(using query: Query) throws where Query : StorableQuery {
        try migrator.migrateType(Query.Subject.self, ifNecessaryOn: queue)
            
        try delete(query: query)
    }
}
