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

open class Database {
    
    /** The available operation modes for the database */
    public enum Mode: String {
        
        /** All objects are stored persistently */
        case normal = "normal"
        
        /** Copies the current database into a dummy database. Any changes made in sandbox mode will not affect the original database, and will be lost when the Swifty instance is destroyed. */
        case sandbox = "sandbox"
    }
    
    /** The underlying database. At the moment, this is an SQLite database */
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
    
    internal init(database: BackingDatabase, configuration: Configuration) {
        self.configuration = configuration
        self.database      = database
    }
    
    /**
    Add objects to the database
     
    - parameters:
        - objects: the objects to be added
    
    - returns: a `Promise` to be fulfilled when the objects are added
    */
    public func add<T>(objects: [T]) -> Promise<Void> where T : Storable {
        return Promise { resolve, reject in
            DispatchQueue.global().async {
                do {
                    resolve(try self.add(objects: objects))
                } catch {
                    reject(error)
                }
            }
        }
    }
    
    /**
    Add an object to the database
     
    - parameters:
        - object: the object to be added
    
    - returns: a `Promise` to be fulfilled when the objects are added
    */
    public func add<T: Storable>(_ object: T) -> Promise<Void> {
        return add(objects: [object])
    }
    
    /**
    Add an object to the database
     
    - parameters:
        - object: the object to be added
    
    - returns: a `Promise` to be fulfilled when the objects are added
    */
    public func add<T: Storable>(objects: T...) -> Promise<Void> {
        return add(objects: objects)
    }
    
    internal func add<T: Storable>(objects: [T]) throws {
        try self.database.add(objects: objects)
    }
    
    /**
    Get objects for the provided type
     
    - parameters:
        - query: query to be executed
     
    - returns: a `Promise` to be fulfilled when the objects are retrieved
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
    
    /**
    Get objects for the provided type
     
    - parameters:
        - type: type of the objects to be retrieved
     
    - returns: a `Promise` to be fulfilled when the objects are retrieved
    */
    public func get<T>(_ type: T.Type) -> Promise<[T]> where T : Storable {
        let query = Query<T>()
        
        return get(using: query)
    }
    
    internal func get<Query>(using query: Query) throws -> [Query.Subject] where Query : StorableQuery {
        return try self.database.get(using: query)
    }
    
    /**
    Delete objects for the provided type
     
    - parameters:
        - type:             type of the objects to be deleted
     
    - returns: a `Promise` to be fulfilled when the objects are deleted
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
    
    /**
    Create a DeleteQuery for the provided type
     
    - parameters:
        - type: type of the objects to be deleted
     
    - returns: a `Promise` to be fulfilled when the objects are deleted
    */
    public func delete<T>(_ type: T.Type) -> Promise<Void> where T : Storable {
        let query = Query<T>()
        
        return delete(using: query)
    }
    
    internal func delete(using query: AnyQuery) throws {
        try self.database.delete(using: query)
    }
}
