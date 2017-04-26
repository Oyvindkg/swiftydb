//
//  DatabaseQueue.swift
//  TinySQLite
//
//  Created by Øyvind Grimnes on 28/12/15.
//

import Foundation


open class DatabaseQueue {
    
    // TODO: Enable queues working on different databases at the same time
    private static let queue = DispatchQueue(label: "com.tinysqlite.DatabaseQueue")
    
    fileprivate let database: DatabaseConnection
    
    /** Create a database queue for the database at the provided path */
    public init(location: URL) {
        database = DatabaseConnection(location: location)
    }
    
    /** Execute a synchronous transaction on the database in a sequential queue */
    open func transaction(_ block: ((DatabaseConnection) throws -> Void)) throws {
       
        try database { (database) -> Void in
            
            /* If an error occurs, rollback the transaction and rethrow the error */
            do {
                try database.beginTransaction()
                
                try block(database)
                
                try database.endTransaction()
            } catch let error {
                try database.rollbackTransaction()
                
                throw error
            }
        }
    }
    
    /** Execute synchronous queries on the database in a sequential queue */
    open func database(_ block: ((DatabaseConnection) throws -> Void)) throws {
        
        /* Run the query in a sequential queue to avoid threading related problems */
        try DatabaseQueue.queue.sync { () -> Void in
            
            /* Open the database and execute the block. Pass on any errors thrown */
            try self.database.open()
            
            /* Close the database when leaving this scope */
            defer {
                try! self.database.close()
            }
            
            try block(self.database)
        }
    }
}
