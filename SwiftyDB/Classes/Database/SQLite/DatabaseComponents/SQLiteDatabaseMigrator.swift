//
//  SQLiteDatabaseMigrator.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 02/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import TinySQLite

class SQLiteDatabaseMigrator: DatabaseMigrator {
    
    let databaseQueue: DatabaseQueue
    let queryFactory: SQLiteQueryFactory
    
    var validTypes: Set<String> = ["TypeInformation"]
    
    init(databaseQueue: DatabaseQueue, queryFactory: SQLiteQueryFactory) {
        self.databaseQueue = databaseQueue
        self.queryFactory = queryFactory
    }
    
    func migrate(type: Storable.Type, fromTypeInformation typeInformation: TypeInformation) throws -> UInt {
        guard let migratableType = type as? Migratable.Type else {
            throw SwiftyError.migration("\(type) needs migration, but does not conform to the Migratable protocol")
        }

        // TODO: Make .version UInt
        
        var migration: Migration = DefaultMigration(schemaVersion: UInt(typeInformation.version))
                
        migratableType.migrate(migration: &migration)
        
        try databaseQueue.transaction { database in
            
            let existingData = try self.existingDataFor(type: type, fromDatabase: database)
            
            let migratedData = self.migratedDataFrom(data: existingData, withMigration: migration as! _Migration, forType: type)
 
            try self.validate(migratedData: migratedData, forType: type)
            
            try self.dropTableFor(type: type, inDatabase: database)

            try self.createTableFor(type: type, inDatabase: database)
            
            try self.insert(data: migratedData, forType: type, inDatabase: database)
        }
        
        return migration.schemaVersion
    }
    
    func validate(migratedData: [[String: SQLiteValue?]], forType type: Storable.Type) throws {
        guard !migratedData.isEmpty else {
            return
        }
        
        let reader = Mapper.readerForType(type)
        
        let migratedProperties = Set(migratedData.first!.keys)
        let typeProperties = Set(reader.types.keys)
        
        
        let missingProperties = typeProperties.subtracting(migratedProperties)
        let extraProperties = migratedProperties.subtracting(typeProperties)

        guard missingProperties.isEmpty else {
            throw SwiftyError.migration("The following properties were missing after migrating '\(type)': \(missingProperties.map({"'\($0)'"}).joined(separator: ", "))")
        }
        
        guard extraProperties.isEmpty else {
            throw SwiftyError.migration("The following properties were present after migrating '\(type)', but are not valid properties: \(extraProperties.map({"'\($0)'"}).joined(separator: ", "))")
        }
    }
    
    func migrate(type: Storable.Type) throws -> UInt {
        try databaseQueue.transaction { database in
            try self.createTableFor(type: type, inDatabase: database)
        }
        
        return 0
    }
    
    fileprivate func existingDataFor(type: Storable.Type, fromDatabase database: DatabaseConnection) throws -> [[String: SQLiteValue?]] {
        
        let retrieveQuery = self.queryFactory.selectQueryForType(type, andFilter: nil, sorting: .none, limit: nil, offset: nil)
        
        let statement = try database.prepare(retrieveQuery.query)
        
        defer {
            try! statement.finalize()
        }
        
        
        return try statement.execute().map { $0.dictionary }
    }
    
    // TODO: Make sure operations are executed in the correct order
    fileprivate func migratedDataFrom(data dataArray: [[String: SQLiteValue?]], withMigration migration: _Migration, forType type: Storable.Type) -> [[String: SQLiteValue?]] {
        var migratedDataArray = dataArray
        
        if dataArray.isEmpty {
            return migratedDataArray
        }
        
        for i in 0 ..< dataArray.count {
            var migratedData = dataArray[i]
            
            /* Migrate data as specified in the types `migration(..)` function */
            for operation in migration.operations {
                switch operation {
                case .add(let property, let defaultValue):
                    migratedData[property] = defaultValue as? SQLiteValue
                case .transform(let property, let transformation):
                    migratedData[property] = transformation(migratedData[property] as? StorableValue) as? SQLiteValue
                case .rename(let property, let newProperty):
                    migratedData[newProperty] = migratedData[property]
                    migratedData[property] = nil
                case .remove(let property):
                    migratedData[property] = nil
                }
            }

            migratedDataArray[i] = migratedData
        }
        
        
        return migratedDataArray
    }
    
    fileprivate func dropTableFor(type: Storable.Type, inDatabase database: DatabaseConnection) throws {
        try database.prepare("DROP TABLE \(type)")
            .executeUpdate()
            .finalize()
    }
    
    fileprivate func createTableFor(type: Storable.Type, inDatabase database: DatabaseConnection) throws {
        let reader = Mapper.readerForType(type)
        
        let createTableQuery = self.queryFactory.createTableQueryForReader(reader)
        
        try database.prepare(createTableQuery.query)
            .executeUpdate(createTableQuery.parameters)
            .finalize()
    }
    
    fileprivate func insert(data dataArray: [[String: SQLiteValue?]], forType type: Storable.Type, inDatabase database: DatabaseConnection) throws {
        let reader = Mapper.readerForType(type)
        
        let insertQuery = self.queryFactory.insertQueryForReader(reader)

        let insertStatement = try database.prepare(insertQuery.query)
        
        for data in dataArray {
            _ = try insertStatement.executeUpdate(data)
        }
        
        try insertStatement.finalize()
    }
}
