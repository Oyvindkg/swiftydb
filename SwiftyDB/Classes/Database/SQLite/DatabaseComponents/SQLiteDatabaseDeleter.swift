//
//  SQLiteDatabaseDeleter.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 02/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import TinySQLite


protocol SQLiteDatabaseDeleter: DatabaseDeleter {
    var databaseQueue: DatabaseQueue { get }
}

extension SQLiteDatabaseDeleter {

    func delete(query: AnyQuery) throws {
        
        let query = SQLiteQueryFactory.deleteQuery(for: query.type, filter: query.filter as? SQLiteFilterStatement)
        
        try databaseQueue.database { database in
            try database.statement(for: query.query)
                .executeUpdate(withParameters: query.parameters)
                .finalize()
        }
    }
}
