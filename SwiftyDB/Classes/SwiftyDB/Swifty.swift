//
//  SwiftyDB.swift
//  ORM
//
//  Created by Øyvind Grimnes on 17/08/16.
//  Copyright © 2016 Øyvind Grimnes. All rights reserved.
//

import Foundation
import Result

/**
 A database object used to add, retrieve and delete objects
*/

open class Swifty: ObjectDatabase {
    
    var database: Database
    
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
        - resultHandler:    an optional result handler
    */
    open func add<T: Storable>(_ object: T, resultHandler: ((Result<Void, SwiftyError>) -> Void)?) {
        return add([object], resultHandler: resultHandler)
    }
    
    /**
     Add objects to the database
     
     - parameters:
        - objects:          the objects to be added
        - resultHandler:    an optional result handler
     */
    open func add<T: Storable>(_ objects: [T], resultHandler: ((Result<Void, SwiftyError>) -> Void)?) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            let result = self.executeAdd(objects)
            
            resultHandler?(result)
        }
        
    }
    
    internal func executeAdd<T: Storable>(_ objects: [T]) -> Result<Void, SwiftyError> {
        return resultForValue {
            for object in objects {
                try self.migrator.migrateTypeIfNecessary(type(of: object), in: self)
            }
            
            try self.database.add(objects: objects)
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
    open func get<T : Storable>(_ type: T.Type) -> GetQuery<T> {
        return GetQuery<T>(database: self)
    }
    
    /**
     Get objects for the provided type
     
     - parameters:
        - type:             type of the objects to be retrieved
        - resultHandler:    an optional result handler
     */
    open func get<T: Storable>(_ type: T.Type, resultHandler: ((Result<[T], SwiftyError>) -> Void)?) {
        let query = Query<T>()
        
        get(with: query, resultHandler: resultHandler)
    }
    
    /**
     Get objects for the provided type
     
     - parameters:
        - query:            query to be executed
        - resultHandler:    an optional result handler
     */
    open func get<T: Storable>(with query: Query<T>, resultHandler: ((Result<[T], SwiftyError>) -> Void)?) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            let result = self.executeGet(query: query)
            
            resultHandler?(result)
        }
    }
    
    internal func executeGet<T : Storable>(query: Query<T>) -> Result<[T], SwiftyError> {
        return resultForValue {
            try self.migrator.migrateTypeIfNecessary(T.self, in: self)
            try self.typeIndexer.indexTypeIfNecessary(T.self, in: self)
            
            return try self.database.get(with: query)
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
    open func delete<T: Storable>(_ type: T.Type, resultHandler: ((Result<Void, SwiftyError>) -> Void)?) {
        let query = Query<T>()
        
        delete(with: query, resultHandler: resultHandler)
    }

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
    open func delete<T: Storable>(with query: Query<T>, resultHandler: ((Result<Void, SwiftyError>) -> Void)?) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            let result = self.executeDelete(query: query)
            
            resultHandler?(result)
        }
    }
    
    internal func executeDelete<T : Storable>(query: Query<T>) -> Result<Void, SwiftyError> {
        return resultForValue {
            try self.migrator.migrateTypeIfNecessary(T.self, in: self)
            try self.typeIndexer.indexTypeIfNecessary(T.self, in: self)
            
            return try self.database.delete(with: query)
        }
    }
    
    
    // MARK: - Helpers
    
    fileprivate func resultForValue<T>(_ block: (Void) throws -> T) -> Result<T, SwiftyError>{
        do {
            let value = try block()
            
            return .success(value)
        } catch let error as SwiftyError {
            return .failure(error)
        } catch let error {
            return .failure(.unknown(error))
        }
    }
}
