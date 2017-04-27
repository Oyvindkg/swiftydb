//
//  SQLiteDatabaseObjectAdder.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 22/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import TinySQLite


extension SQLiteDatabase {
    
    /** Extracts data from `Reader`s and inserts them into the SQLite database */
    struct Inserter {
 
        static func add(readers: [Reader], on queue: DatabaseQueue) throws {
            guard readers.count > 0 else {
                return
            }
            
            /* Group the readers by type to reuse prepared statements for performance gain */
            let groupedReaders = readers.group { $0.storableType.name }
            
            try queue.transaction { database in
                
                for (_, readers) in groupedReaders {
                    
                    let query = SQLiteQueryFactory.insertQuery(for: readers.first!, replaceIfExists:  true)
                    
                    let statement = try database.statement(for: query.query)
                    
                    for reader in readers {
                        var parameters: [String: SQLiteValue?] = [:]
                        
                        for (key, value) in reader.storableValues {
                            parameters[key] = value as? SQLiteValue
                        }
                        
                        _ = try statement.executeUpdate(withParameterMapping: parameters)
                    }
                    
                    try statement.finalize()
                }
            }
        }
    }
}
