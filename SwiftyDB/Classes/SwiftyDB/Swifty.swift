//
//  SwiftyDB.swift
//  ORM
//
//  Created by Øyvind Grimnes on 17/08/16.
//  Copyright © 2016 Øyvind Grimnes. All rights reserved.
//

import Foundation


public class Swifty: ObjectDatabaseType {
    
    let database: DatabaseType
    
    let migrator: MigratorType
    let indexer: IndexerType
    
    public let configuration: ConfigurationType
    
    public init(configuration: ConfigurationType) {
        self.configuration = configuration
        
        database = SQLiteDatabase(configuration: configuration)
        
        migrator = Migrator()
        indexer = Indexer()
    }
    
    public convenience init(name: String) {
        let configuration = Configuration(databaseName: name)
        
        self.init(configuration: configuration)
    }
    
    
    // MARK: - Add
    
    func add<T: Storeable>(object: T, resultHandler: (Result<Void> -> Void)?) {
        return add([object], resultHandler: resultHandler)
    }
    
    func add<T: Storeable>(objects: [T], resultHandler: (Result<Void> -> Void)?) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let result = self.addSync(objects)
            
            resultHandler?(result)
        }
        
    }
    
    internal func addSync<T: Storeable>(objects: [T]) -> Result<Void> {
        return resultForValue {
            try self.migrator.migrateTypeIfNecessary(T.self, inSwifty: self)
            
            try self.database.add(objects)
        }
    }
    
    
    // MARK: - Get
    
    func get<T : Storeable>(type: T.Type) -> GetQuery<T> {
        return GetQuery<T>(database: self)
    }
    
    func get<T: Storeable>(type: T.Type, resultHandler: (Result<[T]> -> Void)?) {
        let query = Query<T>()
        
        get(query, resultHandler: resultHandler)
    }
    
    func get<T: Storeable>(query: Query<T>, resultHandler: (Result<[T]> -> Void)?) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let result = self.getSync(query)
            
            resultHandler?(result)
        }
    }
    
    internal func getSync<T : Storeable>(query: Query<T>) -> Result<[T]> {
        return resultForValue {
            try self.migrator.migrateTypeIfNecessary(T.self, inSwifty: self)
            try self.indexer.indexTypeIfNecessary(T.self, inSwifty: self)
            
            return try self.database.get(query, nested: true)
        }
    }
    
    // MARK: - Delete
    
    func delete<T: Storeable>(type: T.Type, resultHandler: (Result<Void> -> Void)?) {
        let query = Query<T>()
        
        delete(query, resultHandler: resultHandler)
    }
    
    func delete<T: Storeable>(query: Query<T>, resultHandler: (Result<Void> -> Void)?) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let result = self.deleteSync(query)
            
            resultHandler?(result)
        }
    }
    
    internal func deleteSync<T : Storeable>(query: Query<T>) -> Result<Void> {
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
