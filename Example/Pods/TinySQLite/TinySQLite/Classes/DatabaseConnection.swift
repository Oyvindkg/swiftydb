//
//  DatabaseConnection.swift
//  TinySQLite
//
//  Created by Øyvind Grimnes on 25/12/15.
//

import sqlite3



internal let SQLITE_STATIC    = unsafeBitCast(0, to: sqlite3_destructor_type.self)
internal let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)


/** Responsible for opening and closing database connections, executing queries, and managing transactions */
open class DatabaseConnection {
    
    fileprivate var databaseHandle: OpaquePointer?
    fileprivate let location: URL
    
    open var isOpen: Bool
    
    public init(location: URL) {
        self.location = location
        self.isOpen   = false
    }
    
    /** Open the database connection */
    open func open() throws {
        try ResultHandler.verifyResult(code: sqlite3_open(location.path, &databaseHandle))
        
        isOpen = true
    }
    
    /** Close the database connection */
    open func close() throws {
        try ResultHandler.verifyResult(code: sqlite3_close(databaseHandle))
        
        databaseHandle = nil
        isOpen         = false
    }
    
    /**
     Prepare a statement for the provided query
     
     - parameter query:  an SQLite query
     
     - returns:          a prepared statement
     */
    open func statement(for query: String) throws -> Statement {
        guard let handle = databaseHandle else {
            throw TinyError.libraryMisuse
        }
        
        let statement: Statement = Statement(query)
        
        try statement.prepareForDatabase(handle)
        
        return statement
    }
}

// MARK: - Transactions
extension DatabaseConnection {
    
    /** Begin a transaction */
    func beginTransaction() throws {
        try statement(for: "BEGIN TRANSACTION")
            .executeUpdate()
            .finalize()
    }
    
    /** End an ongoing transaction */
    func endTransaction() throws {
        try statement(for: "END TRANSACTION")
            .executeUpdate()
            .finalize()
    }
    
    /** Rollback a transaction */
    func rollbackTransaction() throws {
        try statement(for: "ROLLBACK TRANSACTION")
            .executeUpdate()
            .finalize()
    }
}

// MARK: - General
extension DatabaseConnection {
    
    /** Number of rows affected by INSERT, UPDATE, or DELETE since the database was opened */
    public func numberOfRowsChangedInLastQuery() -> Int {
        return Int(sqlite3_changes(databaseHandle))
    }
    
    /** Total number of rows affected by INSERT, UPDATE, or DELETE since the database was opened */
    public func totalNumberOfRowsChanged() -> Int {
        return Int(sqlite3_total_changes(databaseHandle))
    }
    
    /** Interrupts any pending database operations */
    public func interrupt() {
        sqlite3_interrupt(databaseHandle)
    }
}

// MARK: - Convenience
extension DatabaseConnection {
    
    /**
     Check if a table exists
     
     - parameter tableName: name of the table
     
     - returns: `true` if the database contains a table with the specified name
     */
    public func contains(table tableName: String) throws -> Bool {
        let query = "SELECT name FROM sqlite_master WHERE type='table' AND name=?"
        
        return try resultExists(for: query, withParameters: [tableName])
    }
    
    /**
     Check if a table exists
     
     - parameter indexName: name of the index
     
     - returns: `true` if the database contains an index with the specified name
     */
    public func contains(index indexName: String) throws -> Bool {
        let query = "SELECT name FROM sqlite_master WHERE type='index' AND name=?"
        
        return try resultExists(for: query, withParameters: [indexName])
    }
    
    /**
     Check if a table exists
     
     - parameter viewName: name of the view
     
     - returns: `true` if the database contains a view with the specified name
     */
    public func contains(view viewName: String) throws -> Bool {
        let query = "SELECT name FROM sqlite_master WHERE type='view' AND name=?"
        
        return try resultExists(for: query, withParameters: [viewName])
    }
    
    private func resultExists(for query: String, withParameters parameters: [SQLiteValue?]) throws -> Bool {
        let statement = try self.statement(for: query).execute(withParameters: parameters)
        
        /* Finalize the statement if necessary */
        defer {
            try! statement.finalize()
        }
        
        return statement.next() != nil
    }
}
