//
//  SQLiteDatabaseMigrator.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 02/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import TinySQLite

protocol SQLiteDatabaseMigrator: DatabaseMigrator {
    var databaseQueue: DatabaseQueue { get }
    var validTypes: Set<String> { get set }     // Must contain `TypeInformation` on startup
}

extension SQLiteDatabaseMigrator {

    func migrate(type: Storable.Type, fromTypeInformation typeInformation: TypeInformation) throws -> UInt {
        
        guard let migratableType = type as? Migratable.Type else {
            throw SwiftyError.migration("\(type) needs migration, but does not conform to the Migratable protocol")
        }
        
        var migration: Migration = DefaultMigration(schemaVersion: typeInformation.version)
                
        migratableType.migrate(migration: &migration)
        
        try databaseQueue.transaction { database in
            
            guard let dataBeforeMigration = try? self.existingData(for: type, in: database) else {
                return
            }
            
            let dataAfterMigration  = self.migratedData(from: dataBeforeMigration, applying: migration as! _Migration, for: type)
 
            try self.validateMigratedData(dataAfterMigration, forType: type)
            
            try self.dropTable(for: type, in: database)

            try self.createTable(for: type, in: database)
            
            try self.insert(dataAfterMigration, for: type, in: database)
        }
        
        return migration.schemaVersion
    }
    
    fileprivate func validateMigratedData(_ migratedData: [[String: SQLiteValue?]], forType type: Storable.Type) throws {
        guard !migratedData.isEmpty else {
            return
        }
        
        let reader = Mapper.reader(for: type)
        
        let propertiesBeforeMigration = Set(reader.propertyTypes.keys)
        let propertiesAfterMigration  = Set(migratedData.first!.keys)
        
        
        let missingProperties = propertiesBeforeMigration.subtracting(propertiesAfterMigration)
        let extraProperties   = propertiesAfterMigration.subtracting(propertiesBeforeMigration)

        guard missingProperties.isEmpty else {
            throw SwiftyError.migration("The following properties were missing after migrating '\(type)': \(missingProperties)")
        }
        
        guard extraProperties.isEmpty else {
            throw SwiftyError.migration("The following properties were present after migrating '\(type)', but are not present in the object map: \(extraProperties)")
        }
    }
    
    fileprivate func migrate(type: Storable.Type) throws -> UInt {
        try databaseQueue.transaction { database in
            try self.createTable(for: type, in: database)
        }
        
        return 0
    }
    
    fileprivate func existingData(for type: Storable.Type, in database: DatabaseConnection) throws -> [[String: SQLiteValue?]] {
        
        let retrieveQuery = SQLiteQueryFactory.selectQuery(for: type,
                                                          filter: nil,
                                                          sorting: .none,
                                                          limit: nil,
                                                          offset: nil)
        
        let statement = try database.statement(for: retrieveQuery.query)
        
        defer {
            try! statement.finalize()
        }
        
        
        return try statement.execute().map { $0.dictionary }
    }
    
    // TODO: Make sure operations are executed in the correct order
    fileprivate func migratedData(from dataArray: [[String: SQLiteValue?]], applying migration: _Migration, for type: Storable.Type) -> [[String: SQLiteValue?]] {
        var migratedDataArray = dataArray
        
        if dataArray.isEmpty {
            return migratedDataArray
        }
        
        for i in 0 ..< dataArray.count {
            var migratedData = dataArray[i]
            
            /* Migrate data as specified in the types `migration(..)` function */
            for operation in migration.operations {
                switch operation {
                
                /** A new property was added. Use the default value, or nil */
                case .add(let property, let defaultValue):
                    migratedData[property] = defaultValue as? SQLiteValue
                    
                /** A property has changes. Apply the provided transformation */
                case .transform(let property, let transformation):
                    migratedData[property] = transformation(migratedData[property] as? StorableValue) as? SQLiteValue
                   
                /** A property was renamed */
                case .rename(let property, let newProperty):
                    migratedData[newProperty] = migratedData[property]
                    migratedData[property]    = nil
                    
                /** A property was removed. Remove it from the data */
                case .remove(let property):
                    migratedData[property] = nil
                }
            }

            migratedDataArray[i] = migratedData
        }
        
        
        return migratedDataArray
    }
    
    fileprivate func dropTable(for type: Storable.Type, in database: DatabaseConnection) throws {
        try dropTable("\(type)", in: database)
    }
    
    fileprivate func dropTable(_ tableName: String, in database: DatabaseConnection) throws {
        try database.statement(for: "DROP TABLE \(tableName)")
            .executeUpdate()
            .finalize()
    }
    
    fileprivate func createTable(for type: Storable.Type, in database: DatabaseConnection) throws {
        let reader = Mapper.reader(for: type)
        
        let createTableQuery = SQLiteQueryFactory.createTableQuery(for: reader)
        
        try database.statement(for: createTableQuery.query)
            .executeUpdate(withParameters: createTableQuery.parameters)
            .finalize()
    }
    
    fileprivate func insert(_ dataArray: [[String: SQLiteValue?]], for type: Storable.Type, in database: DatabaseConnection) throws {
        let reader = Mapper.reader(for: type)
        
        let insertQuery = SQLiteQueryFactory.insertQuery(for: reader)

        let insertStatement = try database.statement(for: insertQuery.query)
        
        for data in dataArray {
            _ = try insertStatement.executeUpdate(withParameterMapping: data)
        }
        
        try insertStatement.finalize()
    }
}
