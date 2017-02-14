//
//  MigrationUtils.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 02/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

internal struct MigrationUtils {
    
    static func propertyDefinitionsFor(type: Mappable.Type) -> [String: String] {
        
        let reader = Mapper.reader(for: type)
        
        var definitions: [String: String] = [:]
        
        for (property, type) in reader.types {
            definitions[property] = String(describing: type)
        }
        
        return definitions
    }
    
    static func typeInformationFor(type: Storable.Type, version: UInt = 0) -> TypeInformation {
        let name       = String(describing: type)
        let properties = propertyDefinitionsFor(type: type)
        let identifier = type.identifier()
        let indices    = Set<String>()
        
        return TypeInformation(name: name, properties: properties, version: version, identifierName: identifier, indices: indices)
    }
    
}
