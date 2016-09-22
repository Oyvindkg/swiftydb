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
    
    func add(_ readers: [Reader]) throws {
        guard readers.count > 0 else {
            return
        }
        
        let mappedReaders = readers.groupBy { String(describing: $0.type) }
        
        try databaseQueue.transaction { database in
            for (_, readers) in mappedReaders {
                let query      = self.queryFactory.insertQueryForReader(readers.first!)
                
                let statement = try database.prepare(query.query)
                
                defer {
                    try! statement.finalize()
                }
                
                for reader in readers {
                    var parameters: [String: SQLiteValue?] = [:]
                    
                    for (key, value) in reader.storableValues {
                        parameters[key] = value as? SQLiteValue
                    }
                    
                    try statement.executeUpdate(parameters)
                }
            }
        }
    }
}
