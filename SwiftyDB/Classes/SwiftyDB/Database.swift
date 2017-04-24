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
     Create a GetQuery for the provided type
     
     - returns:
     A `GetQuery` object that can be used to filter, sort and limit the results
     
     - parameters:
        - type: type of the objects to be retrieved
     */
    open func get<T : Storable>(_ type: T.Type) -> GetQuery<T> {
        return GetQuery<T>(database: self)
    }
    
    /**
     Get objects for the provided type
     
     - parameters:
        - query:            query to be executed
        - resultHandler:    an optional result handler
     */
    public func get<T>(using query: Query<T>) -> Promise<[T]> where T : Storable {
        
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
    
    internal func executeGet<T : Storable>(query: Query<T>) throws -> [T] {
        try self.migrator.migrateTypeIfNecessary(T.self, in: self)
        try self.typeIndexer.indexTypeIfNecessary(T.self, in: self)
        
        
        return try self.database.get(with: query)
    }
    
    // MARK: - Delete
    
    /**
    Create a DeleteQuery for the provided type
     
    - returns: A `DeleteQuery` object that can be used to filter, sort and limit the objects deleted
     
    - parameters:
        - type: type of the objects to be retrieved
    */
    open func delete<T : Storable>(_ type: T.Type) -> DeleteQuery<T> {
        return DeleteQuery<T>(database: self)
    }
    
    
    /**
     Delete objects for the provided type
     
     - parameters:
        - type:             type of the objects to be deleted
        - resultHandler:    an optional result handler
     */
    public func delete<T>(using query: Query<T>) -> Promise<Void> where T : Storable {
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
    
    internal func executeDelete<T : Storable>(query: Query<T>) throws {
        try self.migrator.migrateTypeIfNecessary(T.self, in: self)
        try self.typeIndexer.indexTypeIfNecessary(T.self, in: self)
        
        try self.database.delete(with: query)
    }
}
