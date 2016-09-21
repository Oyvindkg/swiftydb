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
    
    init(configuration: ConfigurationProtocol) {
        

        if configuration.mode == .sandbox {
            let dryRunDatabasePath = configuration.databaseDirectory + "/dryrun-" + configuration.databaseName
            
            try? NSFileManager.defaultManager().removeItemAtPath(dryRunDatabasePath)
            try? NSFileManager.defaultManager().copyItemAtPath(configuration.databasePath, toPath: dryRunDatabasePath)
            
            databaseQueue = DatabaseQueue(path: dryRunDatabasePath)
        } else {
            databaseQueue = DatabaseQueue(path: configuration.databasePath)
        }
        
        queryFactory = SQLiteQueryFactory()
        
        tableCreator = SQLiteDatabaseTableCreator(databaseQueue: databaseQueue, queryFactory: queryFactory)
        inserter     = SQLiteDatabaseInserter(databaseQueue: databaseQueue, queryFactory: queryFactory)
        retriever    = SQLiteDatabaseRetriever(databaseQueue: databaseQueue, queryFactory: queryFactory)
        indexer      = SQLiteDatabaseIndexer(databaseQueue: databaseQueue, queryFactory: queryFactory)
        deleter      = SQLiteDatabaseDeleter(databaseQueue: databaseQueue, queryFactory: queryFactory)
        migrator     = SQLiteDatabaseMigrator(databaseQueue: databaseQueue, queryFactory: queryFactory)
    }
    
    func add<T : Storeable>(objects: [T]) throws {
        
        let readers = objects.flatMap(ObjectSerializer.readersForStoreable)
        
        try tableCreator.createTableForReadersIfNecessary(readers)
        
        try inserter.add(readers)
    }
    
    func get<T : Storeable>(query: Query<T>, nested: Bool = true) throws -> [T] {
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

    func delete<T : Storeable>(query: Query<T>) throws {
        do {
            try tableCreator.createTableForTypeIfNecessary(T.self)
            
            try deleter.delete(query)
        } catch is TinySQLite.Error {
            throw SwiftyError.query("Encountered an error during execution of the query. Are you sure all property names are valid?")
        } catch let error {
            throw SwiftyError.unknown("An unexpected error was encountered: \(error)")
        }
    }
    
    func migrate(type: Storeable.Type, fromTypeInformation typeInformation: TypeInformation) throws {
        try migrator.migrateType(type, fromTypeInformation: typeInformation)
    }
    
    func create(index: _IndexType) throws {
        for index in index.indices {
            try indexer.create(index)
        }
    }
}
