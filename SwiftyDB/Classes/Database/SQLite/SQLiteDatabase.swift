//
//  SQLiteDatabase.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 21/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import TinySQLite

struct SQLiteDatabase: Database, SQLiteDatabaseTableCreator, SQLiteDatabaseInserter, SQLiteDatabaseIndexer, SQLiteDatabaseRetriever, SQLiteDatabaseDeleter, SQLiteDatabaseMigrator {
    
    var validTypes: Set<String> = ["TypeInformation"]
    var existingTables: Set<String> = []
    
    let databaseQueue: DatabaseQueue
    
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
        
        try createTableIfNecessaryFor(readers: readers)
        
        try add(readers: readers)
    }
    
    func get<T : Storable>(with query: Query<T>) throws -> [T] {
        do {
            let writers: [Writer] = try get(query: query)
            
            return Mapper.objects(forWriters: writers)
        } catch is TinyError {
            throw SwiftyError.query("Encountered an error during execution of the query. Are you sure all property names are valid?")
        } catch let error {
            throw SwiftyError.unknown(error)
        }
    }

    mutating func delete<T : Storable>(with query: Query<T>) throws {
        do {
            try createTableIfNecessaryFor(type: T.self)
            
            try delete(query: query)
        } catch is TinyError {
            throw SwiftyError.query("Encountered an error during execution of the query. Are you sure all property names are valid?")
        } catch let error {
            throw SwiftyError.unknown(error)
        }
    }
    
}
