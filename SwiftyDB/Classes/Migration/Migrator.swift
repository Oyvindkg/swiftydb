//
//  Migrator.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 03/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

class Migrator: MigratorType {
    
    var validTypes: Set<String> = [ String(TypeInformation) ]
    
    func migrateTypeIfNecessary(type: Storeable.Type, inSwifty swifty: Swifty) throws {
        if validTypes.contains("\(type)") {
            return
        }
        
        for (_, childType) in Mapper.readerForType(type).types {
            guard childType is Storeable.Type else {
                continue
            }
            
            try migrateTypeIfNecessary(childType as! Storeable.Type, inSwifty: swifty)
        }
        
        try migrateThisTypeIfNecessary(type, inSwifty: swifty)
        
        validTypes.insert("\(type)")
    }
    
    // TODO: Make this pretty
    //TODO: Wont detect changes with the same storeable value type
    private func migrateThisTypeIfNecessary(type: Storeable.Type, inSwifty swifty: Swifty) throws {
        
        let query = Query<TypeInformation>().filter("name" == String(type))
        
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
                try swifty.database.migrate(type, fromTypeInformation: typeInformation)
                
                let newTypeInformation = MigrationUtils.typeInformationForType(type, version: typeInformation.version+1)
                
                swifty.addSync([newTypeInformation])
            }
        } else {            
            let newTypeInformation = MigrationUtils.typeInformationForType(type)
            
            swifty.addSync([newTypeInformation])
        }
    }
}