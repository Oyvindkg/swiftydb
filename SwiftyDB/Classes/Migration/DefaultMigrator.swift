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
    
    func migrateTypeIfNecessary(_ type: Storable.Type, in swifty: Swifty) throws {
        guard !validTypes.contains("\(type)") else {
            return
        }
        
        for (_, childType) in Mapper.reader(for: type).propertyTypes {
            guard childType is Storable.Type else {
                continue
            }
            
            try migrateTypeIfNecessary(childType as! Storable.Type, in: swifty)
        }
        
        try migrateTypeNonrecursiveIfNecessary(type, in: swifty)
        
        validTypes.insert("\(type)")
    }
    
    // TODO: Make this pretty
    // TODO: Wont detect changes with the same storable value type
    fileprivate func migrateTypeNonrecursiveIfNecessary(_ type: Storable.Type, in swifty: Swifty) throws {
        
        let query = Query<TypeInformation>().where("name" == String(describing: type))
        
        let result = swifty.executeGet(query: query)
        
        if let typeInformation = result.value?.first {
            var needsMigration = false

            if typeInformation.identifierName !=  type.identifier() {
                needsMigration = true
            }
            
            
            let currentProperties = MigrationUtils.propertyDefinitionsFor(type: type)
            let previousProperties = typeInformation.properties
            
            if currentProperties.count != previousProperties.count {
                needsMigration = true
            }
            
            for key in currentProperties.keys {
                if currentProperties[key] != previousProperties[key] {
                    needsMigration = true
                    break
                }
            }
            
            if needsMigration {
                let newSchemaVersion = try swifty.database.migrate(type: type, fromTypeInformation: typeInformation)
                
                guard newSchemaVersion > UInt(typeInformation.version) else {
                    throw SwiftyError.migration("\(type) was migrated, but the schema version was not incremented")
                }
                
                let newTypeInformation = MigrationUtils.typeInformationFor(type: type, version: newSchemaVersion)
                
                _ = swifty.executeAdd([newTypeInformation])
            }
        } else {
            let newTypeInformation = MigrationUtils.typeInformationFor(type: type)
            
            _ = swifty.executeAdd([newTypeInformation])
        }
    }
}
