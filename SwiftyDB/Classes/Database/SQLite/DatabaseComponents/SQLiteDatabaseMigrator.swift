//
//  SQLiteDatabaseMigrator.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 02/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import TinySQLite

struct SQLiteDatabaseMigrator {
        
    /** The types that have been verified to be valid */
    var validTypes: Set<String> = []
    
    /** The types about to be migrated. Used to prevent recurrence */
    var migratingTypes: Set<String> = []
}

extension SQLiteDatabaseMigrator {

    mutating func migrateType(_ type: Storable.Type, ifNecessaryOn queue: DatabaseQueue) throws {
        guard !validTypes.contains(type.name) && !migratingTypes.contains(type.name) else {
            return
        }
        
        migratingTypes.insert(type.name)
        
        try migrateStorablePropertiesOfType(type, ifNecessaryOn: queue)
        
        try migrateType(type, on: queue)
        
        validTypes.insert(type.name)
        migratingTypes.remove(type.name)
    }
    
    private mutating func migrateStorablePropertiesOfType(_ type: Storable.Type, ifNecessaryOn queue: DatabaseQueue) throws {
        
        let reader = ObjectMapper.read(type: type)
        
        for (_, type) in reader.propertyTypes {
            if let storableType = type as? Storable.Type {
                try migrateType(storableType, ifNecessaryOn: queue)
            } else if let storableArrayType = type as? StorableArray.Type {
                if let storableType = storableArrayType.storableType {
                    try migrateType(storableType, ifNecessaryOn: queue)
                }
            }
        }
    }
    
    func migrateType(_ type: Storable.Type, on queue: DatabaseQueue) throws {
        let currentType = MigrationUtilities.typeInformationFor(type: type)
        
        try queue.transaction { database in
            
            guard try database.contains(table: type.name) else {
                return try createTable(for: type, in: database)
            }
            
            let databaseType = try MigrationUtilities.typeInformationFor(type: type, in: database)
            
            let currentProperties  = Set(currentType.properties)
            let databaseProperties = Set(databaseType.properties)
            
            let addedProperties   = currentProperties.subtracting(databaseProperties)
            let removedProperties = databaseProperties.subtracting(currentProperties)
            
            try addProperties(addedProperties, to: type, in: database)
            try removeProperties(removedProperties, from: type, in: database)
        }
    }
    
    private func addProperties(_ properties: Set<String>, to type: Storable.Type, in database: DatabaseConnection) throws {
        let reader = ObjectMapper.read(type: type)
        
        for property in properties {
            let propertyType  = reader.propertyTypes[property]!
            
            let column = SQLiteQueryFactory.columnForProperty(property, withType: propertyType)
            
            var query = "ALTER TABLE \(type.name) ADD COLUMN \(column.definition)"
            
            if let storableValue = reader.storableValues[property] {
                query += " DEFAULT '\(storableValue)'"
            }
            
            try database.statement(for: query)
                        .executeUpdate()
                        .finalize()
        }
    }
    
    private func removeProperties(_ properties: Set<String>, from type: Storable.Type, in database: DatabaseConnection) throws {
        guard !properties.isEmpty else {
            return
        }
        
        if properties.contains(type.identifier()) {
            throw SwiftyError.migration("Tried to remove the \(type.name)'s identifying property '\(type.identifier())'")
        }
        
        let information = MigrationUtilities.typeInformationFor(type: type)
        
        try renameTable(type.name, to: "old_\(type.name)", in: database)
        try createTable(for: type, in: database)
        try moveDataFromOldTable(for: information, in: database)
        try dropTable("old_\(type.name)", in: database)
    }
}


extension SQLiteDatabaseMigrator {

    fileprivate func moveDataFromOldTable(for information: TypeInformation, in database: DatabaseConnection) throws {
        
        let columns = information.properties.joined(separator: ", ")
        
        let query = "INSERT INTO \(information.name) (\(columns)) SELECT \(columns) FROM old_\(information.name)"
        
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
