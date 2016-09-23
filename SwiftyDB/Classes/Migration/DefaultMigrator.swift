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
    
    func migrateIfNecessary(type: Storable.Type, inSwifty swifty: Swifty) throws {
        if validTypes.contains("\(type)") {
            return
        }
        
        for (_, childType) in Mapper.readerFor(type: type).types {
            guard childType is Storable.Type else {
                continue
            }
            
            try migrateIfNecessary(type: childType as! Storable.Type, inSwifty: swifty)
        }
        
        try migrateThisIfNecessary(type: type, inSwifty: swifty)
        
        validTypes.insert("\(type)")
    }
    
    // TODO: Make this pretty
    // TODO: Wont detect changes with the same storable value type
    fileprivate func migrateThisIfNecessary(type: Storable.Type, inSwifty swifty: Swifty) throws {
        
        let query = Query<TypeInformation>().filter("name" == String(describing: type))
        
        let result = swifty.getSync(query)
        
        if let typeInformation = result.value?.first {
            var needsMigration = false

            if typeInformation.identifierName !=  type.identifier() {
                needsMigration = true
            }
            
            
            let currentProperties = MigrationUtils.propertyDefinitionsForType(type)
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
                
                let newTypeInformation = MigrationUtils.typeInformationForType(type, version: Int(newSchemaVersion))
                
                _ = swifty.addSync([newTypeInformation])
            }
        } else {
            let newTypeInformation = MigrationUtils.typeInformationForType(type)
            
            _ = swifty.addSync([newTypeInformation])
        }
    }
}
