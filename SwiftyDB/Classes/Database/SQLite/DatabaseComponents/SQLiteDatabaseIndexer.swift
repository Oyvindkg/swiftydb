//
//  SQLiteDatabaseIndexCreator.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 24/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import TinySQLite

class SQLiteDatabaseIndexer: DatabaseIndexer {
    
    let databaseQueue: DatabaseQueue
    let queryFactory: SQLiteQueryFactory
    
    init(databaseQueue: DatabaseQueue, queryFactory: SQLiteQueryFactory) {
        self.databaseQueue = databaseQueue
        self.queryFactory  = queryFactory
    }
    
    func createIndex(from index: Indexer) throws {
        try deleteIndices(for: index.type)
        
        for index in index.indices {
            let query = queryFactory.createIndexQuery(for: index)

            try databaseQueue.database { database in
                try database.statement(for: query.query)
                    .executeUpdate()
                    .finalize()
            }
        }
    }
    
    fileprivate func deleteIndices(for type: Storable.Type) throws {
        let indexNames = try self.indexNames(for: type)
        
        try deleteIndices(indexNames)
    }
    
    fileprivate func deleteIndices(_ indexNames: [String]) throws {
        
        try databaseQueue.database { database in
            
            for indexName in indexNames {
                let query = "DROP INDEX IF EXISTS '\(indexName)'"
                
                let statement = try database.statement(for: query)
                
                _ = try statement.executeUpdate()
                
                try statement.finalize()
            }            
        }
    }
    
    fileprivate func indexNames(for type: Storable.Type) throws -> [String] {
        let query = "SELECT name FROM sqlite_master WHERE type == 'index' AND tbl_name == ?"
        
        var indexNames: [String] = []
        
        try databaseQueue.database { database in
            let statement = try database.statement(for: query)

            let parameters = [String(describing: type)]
            
            for row in try statement.execute(withParameters: parameters) {
                indexNames.append(row.stringForColumn(at: 0)!)
            }
            
            try statement.finalize()
        }
        
        return indexNames.filter { !$0.contains("sqlite") }
    }
}
