//
//  SQLiteDatabaseMigrator.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 02/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import TinySQLite

class SQLiteDatabaseMigrator: DatabaseMigratorType {
    
    let databaseQueue: DatabaseQueue
    let queryFactory: SQLiteQueryFactory
    
    var validTypes: Set<String> = ["TypeInformation"]
    
    init(databaseQueue: DatabaseQueue, queryFactory: SQLiteQueryFactory) {
        self.databaseQueue = databaseQueue
        self.queryFactory = queryFactory
    }
    
    func migrateType(type: Storeable.Type, fromTypeInformation typeInformation: TypeInformation) throws {
        guard let migratableType = type as? Migratable.Type else {
            throw SwiftyError.Migration("\(type) needs migration, but does not conform to the Migratable protocol")
        }

        // TODO: Make .version UInt
        
        let migration = Migration(currentVersion: UInt(typeInformation.version))
                
        migratableType.migrate(migration)
        
        try databaseQueue.transaction { database in
            
            let existingData = try self.existingDataForType(type, fromDatabase: database)
            
            let migratedData = self.migratedData(existingData, withMigration: migration, forType: type)
 
            try self.validateMigratedData(migratedData, forType: type)
            
            try self.updateReferencesForData(existingData, andMigratedDataArray: migratedData, ofType: type, typeInformation: typeInformation, inDatabase: database)
            
            try self.dropTableForType(type, inDatabase: database)

            try self.createTableForType(type, inDatabase: database)
            
            try! self.insertData(migratedData, forType: type, inDatabase: database)
        }
    }
    
    func validateMigratedData(migratedData: [[String: SQLiteValue?]], forType type: Storeable.Type) throws {
        let reader = Mapper.readerForType(type)
        
        let migratedProperties = Set(migratedData.first!.keys)
        let typeProperties = Set(reader.types.keys.filter { reader.types[$0] is StoreableValue.Type})
                
        let missingProperties = typeProperties.subtract(migratedProperties)
        let extraProperties = migratedProperties.subtract(typeProperties)
        
        guard missingProperties.isEmpty else {
            throw SwiftyError.Migration("The following properties were not present after migrating '\(type)': \(missingProperties.map({"'\($0)'"}).joinWithSeparator(", "))")
        }
        
        guard extraProperties.isEmpty else {
            throw SwiftyError.Migration("The following properties were not removed after migrating '\(type)', but is no longer valid properties: \(extraProperties.map({"'\($0)'"}).joinWithSeparator(", "))")
        }
    }
    
    func migrateType(type: Storeable.Type) throws {
        try databaseQueue.transaction { database in
            try! self.createTableForType(type, inDatabase: database)
        }
    }
    
    private func updateReferencesForData(dataArray: [[String: SQLiteValue?]], andMigratedDataArray migratedDataArray: [[String: SQLiteValue?]], ofType type: Storeable.Type, typeInformation: TypeInformation, inDatabase database: DatabaseConnection) throws {
        
        let identifier = typeInformation.identifierName
        let newIdentifier = type.identifier()
        
        guard identifier != newIdentifier else {
            return
        }
        
        let childStatement = try! database.prepare("UPDATE \(HasStoreable.self) SET childID = ? WHERE childType = '\(type)' AND childID = ?")
        let parentStatement = try! database.prepare("UPDATE \(HasStoreable.self) SET parentID = ? WHERE parentType = '\(type)' AND parentID = ?")
                        
        for (data, migratedData) in zip(dataArray, migratedDataArray) {
            let identifierValue = data[identifier]!
            let newIdentifierValue = migratedData[newIdentifier]!
            
            try! childStatement.executeUpdate([newIdentifierValue, identifierValue])
            try! parentStatement.executeUpdate([newIdentifierValue, identifierValue])
        }
        
        try! childStatement.finalize()
        try! parentStatement.finalize()
    }
    
    private func existingDataForType(type: Storeable.Type, fromDatabase database: DatabaseConnection) throws -> [[String: SQLiteValue?]] {
        
        let retrieveQuery = self.queryFactory.selectQueryForType(type, andFilter: nil, sorting: .None, limit: nil, offset: nil)
        
        let statement = try database.prepare(retrieveQuery.query)
        
        defer {
            try! statement.finalize()
        }
        
        
        return try statement.execute().map { $0.dictionary }
    }
    
    // TODO: Make sure operations are executed in the correct order
    private func migratedData(dataArray: [[String: SQLiteValue?]], withMigration migration: Migration, forType type: Storeable.Type) -> [[String: SQLiteValue?]] {
        var migratedDataArray = dataArray
        
        if dataArray.isEmpty {
            return migratedDataArray
        }
        
        for i in 0 ..< dataArray.count {
            var migratedData = dataArray[i]
            
            /* Migrate data as specified in the types `migration(..)` function */
            for operation in migration.operations {
                switch operation {
                case .Add(let property, let defaultValue):
                    migratedData[property] = defaultValue as? SQLiteValue
                case .Transform(let property, let transformation):
                    migratedData[property] = transformation(migratedData[property] as? StoreableValue) as? SQLiteValue
                case .Rename(let property, let newProperty):
                    migratedData[newProperty] = migratedData[property]
                    migratedData[property] = nil
                case .Remove(let property):
                    migratedData[property] = nil
                }
            }

            migratedDataArray[i] = migratedData
        }
        
        
        return migratedDataArray
    }
    
    private func dropTableForType(type: Storeable.Type, inDatabase database: DatabaseConnection) throws {
        try database.prepare("DROP TABLE \(type)")
            .executeUpdate()
            .finalize()
    }
    
    private func createTableForType(type: Storeable.Type, inDatabase database: DatabaseConnection) throws {
        let reader = Mapper.readerForType(type)
        
        let createTableQuery = self.queryFactory.createTableQueryForReader(reader)
        
        try database.prepare(createTableQuery.query)
            .executeUpdate(createTableQuery.parameters)
            .finalize()
    }
    
    private func insertData(dataArray: [[String: SQLiteValue?]], forType type: Storeable.Type, inDatabase database: DatabaseConnection) throws {
        let reader = Mapper.readerForType(type)
        
        let insertQuery = self.queryFactory.insertQueryForReader(reader)
        
        let insertStatement = try database.prepare(insertQuery.query)
        
        for data in dataArray {
            try insertStatement.executeUpdate(data)
        }
        
        try insertStatement.finalize()
    }
}