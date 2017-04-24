//
//  Database.swift
//  ORM
//
//  Created by Øyvind Grimnes on 17/08/16.
//  Copyright © 2016 Øyvind Grimnes. All rights reserved.
//

import Foundation
import PromiseKit

/**
 A database object used to add, retrieve and delete objects
*/

open class Database: ObjectDatabase {
    
    /**
    The available modes for the database
     
    - normal:  all objects are stored persistently.
    - sandbox: copies the current database and creates a new dummy database. Any changes made in sandbox mode will not affect the original database, and will be lost when the Swifty instance is destroyed.
    */
    public enum Mode {
        case normal
        case sandbox
    }
    
    var database: BackingDatabase
    
    let migrator: Migrator
    let typeIndexer: TypeIndexer
    
    /**
     The database object's configuration
     */
    open let configuration: Configuration
    
    
    /**
     Initiate a new database object using the provided configuration
     
     - parameters:
        - configuration: database configuration
     */
    public init(configuration: Configuration) {
        self.configuration = configuration
        
        database = SQLiteDatabase(configuration: configuration)
        
        migrator = DefaultMigrator()
        typeIndexer = DefaultTypeIndexer()
    }
    
    /**
     Initiate a new database object using the default configuration with a provided database name
     
     - parameters:
        - name: name of the database
     */
    public convenience init(name: String) {
        let configuration = Configuration(name: name)
        
        self.init(configuration: configuration)
    }
    
    
    // MARK: - Add
    
    /**
     Add an object to the database
     
     - parameters:
        - object:           the object to be added
    */

    /**
     Add objects to the database
     
     - parameters:
        - objects:          the objects to be added
     */
    public func add<T>(objects: [T]) -> Promise<Void> where T : Storable {
        return Promise { resolve, reject in
            DispatchQueue.global().async {
                do {
                    try self.executeAdd(objects)
                    
                    resolve()
                } catch {
                    reject(error)
                }
            }
        }
    }
    
    internal func executeAdd<T: Storable>(_ objects: [T]) throws {
        for object in objects {
            try self.migrator.migrateTypeIfNecessary(type(of: object), in: self)
        }
        
        try self.database.add(objects: objects)
    }
    
    
    // MARK: - Get
    
    /**
     Get objects for the provided type
     
     - parameters:
        - query:            query to be executed
        - resultHandler:    an optional result handler
     */
    public func get<Query>(using query: Query) -> Promise<[Query.Subject]> where Query : StorableQuery {
        
        return Promise { resolve, reject in
            DispatchQueue.global().async {
                do {
                    resolve(try self.executeGet(query: query))
                } catch {
                    reject(error)
                }
            }
        }
    }
    
    internal func executeGet<Query>(query: Query) throws -> [Query.Subject] where Query : StorableQuery {
        try self.migrator.migrateTypeIfNecessary(Query.Subject.self, in: self)
        try self.typeIndexer.indexTypeIfNecessary(Query.Subject.self, in: self)
        
        
        return try self.database.get(using: query)
    }
    
    // MARK: - Delete    
    
    /**
     Delete objects for the provided type
     
     - parameters:
        - type:             type of the objects to be deleted
        - resultHandler:    an optional result handler
     */
    public func delete<Query>(using query: Query) -> Promise<Void> where Query : StorableQuery {
        return Promise { resolve, reject in
            DispatchQueue.global().async {
                do {
                    try self.executeDelete(query: query)
                    resolve()
                } catch {
                    reject(error)
                }
            }
        }
    }
    
    internal func executeDelete<Query>(query: Query) throws where Query : StorableQuery {
        try self.migrator.migrateTypeIfNecessary(Query.Subject.self, in: self)
        try self.typeIndexer.indexTypeIfNecessary(Query.Subject.self, in: self)
        
        try self.database.delete(using: query)
    }
}
