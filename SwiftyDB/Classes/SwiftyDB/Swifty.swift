//
//  SwiftyDB.swift
//  ORM
//
//  Created by Øyvind Grimnes on 17/08/16.
//  Copyright © 2016 Øyvind Grimnes. All rights reserved.
//

import Foundation


/**
 A database object used to add, retrieve and delete objects
*/

public class Swifty: ObjectDatabase {
    
    let database: DatabaseType
    
    let migrator: MigratorType
    let indexer: IndexerType
    
    /**
     The database object's configuration
     */
    public let configuration: ConfigurationType
    
    
    /**
     Initiate a new database object using the provided configuration
     
     - parameters:
        - configuration: database configuration
     */
    public init(configuration: ConfigurationType) {
        self.configuration = configuration
        
        database = SQLiteDatabase(configuration: configuration)
        
        migrator = Migrator()
        indexer = Indexer()
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
        - resultHandler:    an optional result handler
    */
    public func add<T: Storable>(object: T, resultHandler: (Result<Void> -> Void)?) {
        return add([object], resultHandler: resultHandler)
    }
    
    /**
     Add objects to the database
     
     - parameters:
        - objects:          the objects to be added
        - resultHandler:    an optional result handler
     */
    public func add<T: Storable>(objects: [T], resultHandler: (Result<Void> -> Void)?) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let result = self.addSync(objects)
            
            resultHandler?(result)
        }
        
    }
    
    internal func addSync<T: Storable>(objects: [T]) -> Result<Void> {
        return resultForValue {
            for object in objects {
                try self.migrator.migrateTypeIfNecessary(object.dynamicType, inSwifty: self)
            }
            
            try self.database.add(objects)
        }
    }
    
    
    // MARK: - Get
    
    /**
     Create a GetQuery for the provided type
     
     - returns:
     A `GetQuery` object that can be used to filter, sort and limit the results
     
     - parameters:
        - type: type of the objects to be retrieved
     */
    public func get<T : Storable>(type: T.Type) -> GetQuery<T> {
        return GetQuery<T>(database: self)
    }
    
    /**
     Get objects for the provided type
     
     - parameters:
        - type:             type of the objects to be retrieved
        - resultHandler:    an optional result handler
     */
    public func get<T: Storable>(type: T.Type, resultHandler: (Result<[T]> -> Void)?) {
        let query = Query<T>()
        
        get(query, resultHandler: resultHandler)
    }
    
    /**
     Get objects for the provided type
     
     - parameters:
        - query:            query to be executed
        - resultHandler:    an optional result handler
     */
    public func get<T: Storable>(query: Query<T>, resultHandler: (Result<[T]> -> Void)?) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let result = self.getSync(query)
            
            resultHandler?(result)
        }
    }
    
    internal func getSync<T : Storable>(query: Query<T>) -> Result<[T]> {
        return resultForValue {
            try self.migrator.migrateTypeIfNecessary(T.self, inSwifty: self)
            try self.indexer.indexTypeIfNecessary(T.self, inSwifty: self)
            
            return try self.database.get(query, nested: true)
        }
    }
    
    // MARK: - Delete
    
    /**
     Create a DeleteQuery for the provided type
     
     - returns:
     A `DeleteQuery` object that can be used to filter objects to delete
     
     - parameters:
        - type: type of the objects to be deleted
     */
    public func delete<T: Storable>(type: T.Type, resultHandler: (Result<Void> -> Void)?) {
        let query = Query<T>()
        
        delete(query, resultHandler: resultHandler)
    }
    
    /**
     Delete objects for the provided type
     
     - parameters:
        - type:             type of the objects to be deleted
        - resultHandler:    an optional result handler
     */
    public func delete<T: Storable>(query: Query<T>, resultHandler: (Result<Void> -> Void)?) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let result = self.deleteSync(query)
            
            resultHandler?(result)
        }
    }
    
    internal func deleteSync<T : Storable>(query: Query<T>) -> Result<Void> {
        return resultForValue {
            try self.migrator.migrateTypeIfNecessary(T.self, inSwifty: self)
            try self.indexer.indexTypeIfNecessary(T.self, inSwifty: self)
            
            return try self.database.delete(query)
        }
    }
    
    
    // MARK: - Helpers
    
    private func resultForValue<T>(block: Void throws -> T) -> Result<T>{
        do {
            let value = try block()
            
            return .success(value)
        } catch let error as SwiftyError {
            return .error(error.description)
        } catch let error {
            return .error("An unexpected error was encountered: \(error)")
        }
    }
}
