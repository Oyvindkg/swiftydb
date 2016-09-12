//
//  SQLiteDatabaseIndexCreator.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 24/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import TinySQLite

class SQLiteDatabaseIndexer: DatabaseIndexerType {
    
    let databaseQueue: DatabaseQueue
    let queryFactory: SQLiteQueryFactory
    
    init(databaseQueue: DatabaseQueue, queryFactory: SQLiteQueryFactory) {
        self.databaseQueue = databaseQueue
        self.queryFactory = queryFactory
    }
    
    func create(index: _IndexInstanceType) throws {
        let query = queryFactory.createIndexQueryFor(index)

        try databaseQueue.database { database in
            try database.prepare(query.query)
                .executeUpdate()
                .finalize()
        }
    }
}