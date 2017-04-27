//
//  SQLiteDatabaseDeleter.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 02/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import TinySQLite


struct SQLiteDatabaseDeleter {

    static func delete(query: AnyQuery, on queue: DatabaseQueue) throws {
        
        let query = SQLiteQueryFactory.deleteQuery(for: query.type, filter: query.filter as? SQLiteFilterStatement)
        
        try queue.database { database in
            try database.statement(for: query.query)
                        .executeUpdate(withParameters: query.parameters)
                        .finalize()
        }
    }
}
