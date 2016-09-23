//
//  SQLiteDatabaseDeleter.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 02/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import TinySQLite

struct SQLiteDatabaseDeleter: DatabaseDeleter {
    
    let databaseQueue: DatabaseQueue
    let queryFactory: SQLiteQueryFactory
    
    init(databaseQueue: DatabaseQueue, queryFactory: SQLiteQueryFactory) {
        self.databaseQueue = databaseQueue
        self.queryFactory = queryFactory
    }
    
    func delete(query: _QueryProtocol) throws {
        
        let query = queryFactory.deleteQueryForType(query.type, withFilter: query.filter as? SQLiteFilterStatement)
        
        try databaseQueue.database { database in
            try database.prepare(query.query)
                .executeUpdate(query.parameters)
                .finalize()
        }
    }
    
}
