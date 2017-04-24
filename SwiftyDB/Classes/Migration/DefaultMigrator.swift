//
//  Migrator.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 03/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

class DefaultMigrator: Migrator {
    
    var validTypes: Set<String> = [ String(describing: TypeInformation.self) ]
    
    func migrateTypeIfNecessary(_ type: Storable.Type, in database: Database) throws {
        
        guard !validTypes.contains("\(type)") else {
            return
        }
        
        for (_, childType) in Mapper.reader(for: type).propertyTypes {
            guard childType is Storable.Type else {
                continue
            }
            
            try migrateTypeIfNecessary(childType as! Storable.Type, in: database)
        }
        
        try migrateTypeNonrecursiveIfNecessary(type, in: database)
        
        validTypes.insert("\(type)")
    }
    
    // TODO: Make this pretty
    fileprivate func migrateTypeNonrecursiveIfNecessary(_ type: Storable.Type, in database: Database) throws {
        
        var query = Query<TypeInformation>()
            
        query.filter = "name" == String(describing: type)
        
        let result = try database.executeGet(query: query)
        
        if let typeInformation = result.first {
            
            guard self.type(type, needsMigrationFrom: typeInformation) else {
                return
            }
            
            let newSchemaVersion = try database.database.migrate(type: type, fromTypeInformation: typeInformation)
            
            guard newSchemaVersion > UInt(typeInformation.version) else {
                throw SwiftyError.migration("\(type) was migrated, but the schema version was not incremented")
            }
            
            let newTypeInformation = MigrationUtils.typeInformationFor(type: type, version: newSchemaVersion)
            
            try database.executeAdd([newTypeInformation])

        } else {
            let newTypeInformation = MigrationUtils.typeInformationFor(type: type)
            
            try database.executeAdd([newTypeInformation])
        }
    }
    
    // TODO: Wont detect changes with the same storable value type
    func type(_ type: Storable.Type, needsMigrationFrom typeInformation: TypeInformation) -> Bool {
        
        if typeInformation.identifierName !=  type.identifier() {
            return true
        }
        
        let currentProperties = MigrationUtils.propertyDefinitionsFor(type: type)
        let previousProperties = typeInformation.properties
        
        if currentProperties.count != previousProperties.count {
            return true
        }
        
        for key in currentProperties.keys {
            if currentProperties[key] != previousProperties[key] {
                return true
            }
        }
        
        return false
    }
}
