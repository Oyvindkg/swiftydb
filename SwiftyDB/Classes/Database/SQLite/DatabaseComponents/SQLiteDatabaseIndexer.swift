//
//  SQLiteDatabaseIndexCreator.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 24/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import TinySQLite

struct SQLiteDatabaseIndexer {
    
    static func updateIndicesFor(type: Storable.Type, ifNecessaryOn queue: DatabaseQueue) throws {
        
        guard let indexableType = type as? Indexable.Type else {
            return
        }
        
        let currentIndexNames  = IndexingUtils.indexNames(for: type)
        let databaseIndexNames = try indexNames(for: type, on: queue)
        
        guard currentIndexNames != databaseIndexNames else {
            return
        }
        
        let addedIndexNames   = currentIndexNames.subtracting(databaseIndexNames)
        let removedIndexNames = databaseIndexNames.subtracting(currentIndexNames)
        
        let addedIndices = indexableType.indices().filter { index in
            let name = IndexingUtils.name(of: index, for: type)
            
            return addedIndexNames.contains(name)
        }
        
        try deleteIndices(withNames: removedIndexNames, on: queue)
        try createIndices(addedIndices, for: type, on: queue)
    }
    
    static func createIndices(_ indices: [AnyIndex], for type: Storable.Type, on queue: DatabaseQueue) throws {
        
        try queue.transaction { database in
            for index in indices {
                let query = SQLiteQueryFactory.createIndexQuery(for: index, for: type)
                
                try database.statement(for: query.query)
                        .executeUpdate()
                        .finalize()
            }
        }
    }
    
    fileprivate static func deleteIndices(withNames indexNames: Set<String>, on queue: DatabaseQueue) throws {
        
        try queue.transaction { database in
            for name in indexNames {
                let query = "DROP INDEX IF EXISTS '\(name)'"
                
                try database.statement(for: query)
                            .executeUpdate()
                            .finalize()
            }
        }
    }
    
    static func indexNames(for type: Storable.Type, on queue: DatabaseQueue) throws -> Set<String> {
        let query = "SELECT name FROM sqlite_master WHERE type == 'index' AND tbl_name == ?"

        var indexNames: [String] = []
        
        try queue.database { database in
            let statement = try database.statement(for: query)
            let parameters = [type.name]
            
            for row in try statement.execute(withParameters: parameters) {
                indexNames.append(row.stringForColumn(at: 0)!)
            }
            
            try statement.finalize()
        }
        
        return Set(indexNames.filter { !$0.contains("sqlite") })
    }
}
