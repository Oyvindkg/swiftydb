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
    

    /** The database object's configuration */
    open let configuration: Configuration
    
    
    /**
    Initiate a new database object using the provided configuration
     
    - parameters:
        - configuration: database configuration
    */
    public init(configuration: Configuration) {
        self.configuration = configuration
        
        database = SQLiteDatabase(configuration: configuration)
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
    
    /**
    Add objects to the database
     
    - parameters:
        - objects:          the objects to be added
    */
    public func add<T>(objects: [T]) -> Promise<Void> where T : Storable {
        return Promise { resolve, reject in
            DispatchQueue.global().async {
                do {
                    resolve(try self.add(objects))
                } catch {
                    reject(error)
                }
            }
        }
    }
    
    internal func add<T: Storable>(_ objects: [T]) throws {
        try self.database.add(objects: objects)
    }
    
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
                    resolve(try self.get(using: query))
                } catch {
                    reject(error)
                }
            }
        }
    }
    
    internal func get<Query>(using query: Query) throws -> [Query.Subject] where Query : StorableQuery {
        return try self.database.get(using: query)
    }
    
    /**
     Delete objects for the provided type
     
     - parameters:
        - type:             type of the objects to be deleted
        - resultHandler:    an optional result handler
     */
    public func delete(using query: AnyQuery) -> Promise<Void> {
        return Promise { resolve, reject in
            DispatchQueue.global().async {
                do {
                    resolve(try self.delete(using: query))
                } catch {
                    reject(error)
                }
            }
        }
    }
    
    internal func delete(using query: AnyQuery) throws {
        try self.database.delete(using: query)
    }
}
