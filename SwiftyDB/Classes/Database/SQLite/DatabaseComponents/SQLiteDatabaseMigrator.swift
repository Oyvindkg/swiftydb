//
//  SQLiteDatabaseMigrator.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 02/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import TinySQLite

extension SQLiteDatabase {
    
    struct Migrator {
            
        /** The types that have been verified to be valid */
        var validTypes: Set<String> = []
        
        /** The types about to be migrated. Used to prevent recurrence */
        var migratingTypes: Set<String> = []

        mutating func updateTable(for type: Storable.Type, ifNecessaryOn queue: DatabaseQueue) throws {
            guard !validTypes.contains(type.name) && !migratingTypes.contains(type.name) else {
                return
            }
            
            migratingTypes.insert(type.name)
            
            try updateTableForStorableProperties(of: type, ifNecessaryOn: queue)
            
            try updateTable(for: type, on: queue)
            
            validTypes.insert(type.name)
            migratingTypes.remove(type.name)
        }
        
        private mutating func updateTableForStorableProperties(of type: Storable.Type, ifNecessaryOn queue: DatabaseQueue) throws {
            
            let reader = ObjectMapper.read(type: type)
            
            for (_, type) in reader.propertyTypes {
                if let storableType = type as? Storable.Type {
                    try updateTable(for: storableType, ifNecessaryOn: queue)
                } else if let storableArrayType = type as? StorableArray.Type {
                    if let storableType = storableArrayType.storableType {
                        try updateTable(for: storableType, ifNecessaryOn: queue)
                    }
                }
            }
        }
        
        func updateTable(for type: Storable.Type, on queue: DatabaseQueue) throws {
            let currentType = MigrationUtilities.typeInformationFor(type: type)
            
            guard currentType.properties.contains(currentType.identifierName) else {
                let properties = currentType.properties.map({"'\($0)'"}).joined(separator: ", ")
                
                throw SwiftyError.migration("The identifier defined by \(type) ('\(type.identifier())') was not found in the mapped properties (\(properties))")
            }
            
            try queue.transaction { database in
                
                guard let databaseType = try MigrationUtilities.typeInformationFor(type: type, in: database) else {
                    return try createTable(for: type, in: database)
                }

                guard currentType != databaseType else {
                    return
                }
                
                guard currentType.identifierName == databaseType.identifierName else {
                    throw SwiftyError.migration("The SQLite backend does not support changing the identifying property name. Expected identifier '\(databaseType.identifierName)', but found '\(currentType.identifierName)'")
                }
                
                let temporaryTableName = "old_\(type.name)"
                let existingProperties = Set(databaseType.properties).intersection(currentType.properties)
                
                try renameTable(type.name, to: temporaryTableName, in: database)
                try createTable(for: type, in: database)
                try moveDataForProperties(existingProperties, from: temporaryTableName, to: type.name, in: database)
                try dropTable(temporaryTableName, in: database)
            }
        }

        fileprivate func moveDataForProperties(_ properties: Set<String>, from table: String, to targetTable: String, in database: DatabaseConnection) throws {
            let columns = properties.joined(separator: ", ")
            
            let query = "INSERT INTO \(targetTable) (\(columns)) SELECT \(columns) FROM \(table)"
            
            try database.statement(for: query)
                        .executeUpdate()
                        .finalize()
        }
        
        fileprivate func dropTable(for type: Storable.Type, in database: DatabaseConnection) throws {
            try dropTable(type.name, in: database)
        }
        
        fileprivate func dropTable(_ tableName: String, in database: DatabaseConnection) throws {
            try database.statement(for: "DROP TABLE \(tableName)")
                .executeUpdate()
                .finalize()
        }
        
        fileprivate func renameTable(_ name: String, to newName: String, in database: DatabaseConnection) throws {
            try database.statement(for: "ALTER TABLE \(name) RENAME TO \(newName)")
                        .executeUpdate()
                        .finalize()
        }
        
        fileprivate func createTable(for type: Storable.Type, in database: DatabaseConnection) throws {
            let reader = ObjectMapper.read(type: type)
            
            let createTableQuery = SQLiteQueryFactory.createTableQuery(for: reader)

            try database.statement(for: createTableQuery.query)
                        .executeUpdate(withParameters: createTableQuery.parameters)
                        .finalize()
        }
    }
}
