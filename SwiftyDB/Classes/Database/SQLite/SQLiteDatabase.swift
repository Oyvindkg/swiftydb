//
//  SQLiteDatabase.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 21/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import TinySQLite

struct SQLiteDatabase: DatabaseType {
    
    let databaseQueue: DatabaseQueue
    
    let queryFactory: SQLiteQueryFactory
    
    let tableCreator: SQLiteDatabaseTableCreator
    let inserter: DatabaseInserterType
    let retriever: DatabaseRetrieverType
    let indexer: DatabaseIndexerType
    let deleter: DatabaseDeleterType
    let migrator: DatabaseMigratorType
    
    init(configuration: ConfigurationType) {
        
        /* Copy any exsiting database to create a sandbox database */
        if configuration.mode == .sandbox {
            var normalConfiguration = configuration
            
            normalConfiguration.mode = .normal
            
            try? NSFileManager.defaultManager().removeItemAtPath(configuration.path)
            try? NSFileManager.defaultManager().copyItemAtPath(normalConfiguration.path, toPath: configuration.path)
        }
        
        databaseQueue = DatabaseQueue(path: configuration.path)
        
        queryFactory = SQLiteQueryFactory()
        
        tableCreator = SQLiteDatabaseTableCreator(databaseQueue: databaseQueue, queryFactory: queryFactory)
        inserter     = SQLiteDatabaseInserter(databaseQueue: databaseQueue, queryFactory: queryFactory)
        retriever    = SQLiteDatabaseRetriever(databaseQueue: databaseQueue, queryFactory: queryFactory)
        indexer      = SQLiteDatabaseIndexer(databaseQueue: databaseQueue, queryFactory: queryFactory)
        deleter      = SQLiteDatabaseDeleter(databaseQueue: databaseQueue, queryFactory: queryFactory)
        migrator     = SQLiteDatabaseMigrator(databaseQueue: databaseQueue, queryFactory: queryFactory)
    }
    
    func add<T : Storable>(objects: [T]) throws {
        
        let readers = objects.flatMap(ObjectSerializer.readersForStorable)
        
        try tableCreator.createTableForReadersIfNecessary(readers)
        
        try inserter.add(readers)
    }
    
    func get<T : Storable>(query: Query<T>, nested: Bool = true) throws -> [T] {
        do {
            try tableCreator.createTableForTypeIfNecessary(T.self)
            
            let writers = try retriever.get(query, nested: nested)
            
            return Mapper.objectsForWriters(writers)
        } catch is TinySQLite.Error {
            throw SwiftyError.query("Encountered an error during execution of the query. Are you sure all property names are valid?")
        } catch let error {
            throw SwiftyError.unknown("An unexpected error was encountered: \(error)")
        }
    }

    func delete<T : Storable>(query: Query<T>) throws {
        do {
            try tableCreator.createTableForTypeIfNecessary(T.self)
            
            try deleter.delete(query)
        } catch is TinySQLite.Error {
            throw SwiftyError.query("Encountered an error during execution of the query. Are you sure all property names are valid?")
        } catch let error {
            throw SwiftyError.unknown("An unexpected error was encountered: \(error)")
        }
    }
    
    func migrate(type: Storable.Type, fromTypeInformation typeInformation: TypeInformation) throws -> UInt {
        return try migrator.migrateType(type, fromTypeInformation: typeInformation)
    }
    
    func create(index: _IndexType) throws {
        try indexer.create(index)
    }
}
