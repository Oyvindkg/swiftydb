//
//  SQLiteDatabase.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 21/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import TinySQLite

struct SQLiteDatabase: Database {
    
    let databaseQueue: DatabaseQueue
    
    let queryFactory: SQLiteQueryFactory
    
    let tableCreator: SQLiteDatabaseTableCreator
    let inserter: DatabaseInserter
    let retriever: DatabaseRetriever
    let indexer: DatabaseIndexer
    let deleter: DatabaseDeleter
    let migrator: DatabaseMigrator
    
    init(configuration: Configuration) {
        
        /* Copy any exsiting database to create a sandbox database */
        if configuration.mode == .sandbox {
            try? FileManager.default.removeItem(atPath: configuration.location.path)
            
            /** Create a copy of the database for sandbox mode */
            try? FileManager.default.copyItem(atPath: configuration.location(for: .normal).path,
                                              toPath: configuration.location.path)
        }
        
        databaseQueue = DatabaseQueue(location: configuration.location)
        
        queryFactory = SQLiteQueryFactory()
        
        tableCreator = SQLiteDatabaseTableCreator(databaseQueue: databaseQueue, queryFactory: queryFactory)
        inserter     = SQLiteDatabaseInserter(databaseQueue: databaseQueue, queryFactory: queryFactory)
        retriever    = SQLiteDatabaseRetriever(databaseQueue: databaseQueue, queryFactory: queryFactory)
        indexer      = SQLiteDatabaseIndexer(databaseQueue: databaseQueue, queryFactory: queryFactory)
        deleter      = SQLiteDatabaseDeleter(databaseQueue: databaseQueue, queryFactory: queryFactory)
        migrator     = SQLiteDatabaseMigrator(databaseQueue: databaseQueue, queryFactory: queryFactory)
    }
    
    func add<T : Storable>(objects: [T]) throws {
        
        let readers = objects.flatMap(DefaultObjectSerializer.readersFor)
        
        try tableCreator.createTableIfNecessaryFor(readers: readers)
        
        try inserter.add(readers: readers)
    }
    
    func get<T : Storable>(query: Query<T>) throws -> [T] {
        do {
            //try tableCreator.createTableForTypeIfNecessary(T.self)
            
            let writers = try retriever.get(query: query)
            
            return Mapper.objectsForWriters(writers)
        } catch is TinyError {
            throw SwiftyError.query("Encountered an error during execution of the query. Are you sure all property names are valid?")
        } catch let error {
            throw SwiftyError.unknown("An unexpected error was encountered: \(error)")
        }
    }

    func delete<T : Storable>(query: Query<T>) throws {
        do {
            try tableCreator.createTableIfNecessaryFor(type: T.self)
            
            try deleter.delete(query: query)
        } catch is TinyError {
            throw SwiftyError.query("Encountered an error during execution of the query. Are you sure all property names are valid?")
        } catch let error {
            throw SwiftyError.unknown("An unexpected error was encountered: \(error)")
        }
    }
    
    func migrate(type: Storable.Type, fromTypeInformation typeInformation: TypeInformation) throws -> UInt {
        return try migrator.migrate(type: type, fromTypeInformation: typeInformation)
    }
    
    func create(index: _Index) throws {
        try indexer.create(index: index)
    }
}
