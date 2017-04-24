//
//  SQLiteDatabaseIndexCreator.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 24/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import TinySQLite

protocol SQLiteDatabaseIndexer: DatabaseIndexer {
    var databaseQueue: DatabaseQueue { get }
}

extension SQLiteDatabaseIndexer {
    
    func createIndex(with index: Indexer) throws {
        try deleteIndices(for: index.type)
        
        for index in index.indices {
            let query = SQLiteQueryFactory.createIndexQuery(for: index)
            
            try databaseQueue.database { database in
                guard try database.contains(table: String(describing: index.type)) else {
                    return
                }
                
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
