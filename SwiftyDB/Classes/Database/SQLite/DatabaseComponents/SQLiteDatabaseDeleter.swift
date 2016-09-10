//
//  SQLiteDatabaseDeleter.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 02/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import TinySQLite

struct SQLiteDatabaseDeleter: DatabaseDeleterType {
    
    let databaseQueue: DatabaseQueue
    let queryFactory: SQLiteQueryFactory
    
    init(databaseQueue: DatabaseQueue) {
        self.databaseQueue = databaseQueue
        
        self.queryFactory = Injector.defaultInstance.autowire()!
    }
    
    init(databaseQueue: DatabaseQueue, queryFactory: SQLiteQueryFactory) {
        self.databaseQueue = databaseQueue
        self.queryFactory = queryFactory
    }
    
    func delete(query: _QueryType) throws {
        
        let query = queryFactory.deleteQueryForType(query.type, withFilter: query.filter as? SQLiteFilterStatement)
        
        try databaseQueue.database { database in
            try! database.prepare(query.query)
                .executeUpdate(query.parameters)
                .finalize()
        }
    }
    
}