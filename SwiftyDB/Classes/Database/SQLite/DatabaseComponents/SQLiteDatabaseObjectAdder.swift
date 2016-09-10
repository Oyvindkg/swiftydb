//
//  SQLiteDatabaseObjectAdder.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 22/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import TinySQLite

struct SQLiteDatabaseInserter: DatabaseInserterType {
    
    let databaseQueue: DatabaseQueue
    let queryFactory: SQLiteQueryFactory
    
    init(databaseQueue: DatabaseQueue, queryFactory: SQLiteQueryFactory) {
        self.databaseQueue = databaseQueue
        self.queryFactory = queryFactory
    }
    
    func add(readers: [Reader]) throws {
        guard readers.count > 0 else {
            return
        }
        
        try databaseQueue.transaction { database in
            for reader in readers {
                let query      = self.queryFactory.insertQueryForReader(reader)
                
                var parameters: [String: SQLiteValue?] = [:]
                
                for (key, value) in reader.storeableValues {
                    parameters[key] = value as? SQLiteValue
                }
                
                let statement = try! database.prepare(query.query)
                
                try! statement.executeUpdate(parameters)
                try! statement.finalize()
            }
        }
    }
}