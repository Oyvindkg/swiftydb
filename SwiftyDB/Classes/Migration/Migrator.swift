//
//  Migrator.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 03/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

class Migrator: MigratorType {
    
    var validTypes: Set<String> = [ String(describing: TypeInformation.self) ]
    
    func migrateTypeIfNecessary(_ type: Storable.Type, inSwifty swifty: Swifty) throws {
        if validTypes.contains("\(type)") {
            return
        }
        
        for (_, childType) in Mapper.readerForType(type).types {
            guard childType is Storable.Type else {
                continue
            }
            
            try migrateTypeIfNecessary(childType as! Storable.Type, inSwifty: swifty)
        }
        
        try migrateThisTypeIfNecessary(type, inSwifty: swifty)
        
        validTypes.insert("\(type)")
    }
    
    // TODO: Make this pretty
    // TODO: Wont detect changes with the same storable value type
    fileprivate func migrateThisTypeIfNecessary(_ type: Storable.Type, inSwifty swifty: Swifty) throws {
        
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
                
                swifty.addSync([newTypeInformation])
            }
        } else {
            let newTypeInformation = MigrationUtils.typeInformationForType(type)
            
            swifty.addSync([newTypeInformation])
        }
    }
}
