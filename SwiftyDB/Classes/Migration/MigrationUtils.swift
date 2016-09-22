//
//  MigrationUtils.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 02/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

internal struct MigrationUtils {
    
    static func propertyDefinitionsForType(_ type: Mappable.Type) -> [String: String] {
        
        let reader = Mapper.readerForType(type)
        
        var definitions: [String: String] = [:]
        
        for (property, type) in reader.types {
            definitions[property] = String(describing: type)
        }
        
        return definitions
    }
    
    static func typeInformationForType(_ type: Storable.Type, version: Int = 0) -> TypeInformation {
        let name = String(describing: type)
        let properties = propertyDefinitionsForType(type)
        let identifier = type.identifier()
        let indices: Set<String> = []
        
        return TypeInformation(name: name, properties: properties, version: version, identifierName: identifier, indices: indices)
    }
    
}
