//
//  MigrationUtils.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 02/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import TinySQLite

internal struct MigrationUtilities {
    
    /** Get a list of property names for the type */
    static func properties(for type: Mappable.Type) -> [String] {
        
        let reader = ObjectMapper.read(type: type)
        
        return reader.propertyTypes.filter { !($0.value is Storable) }
                                   .map { $0.key }
    }
    
    /** Get information reflecting the type */
    static func typeInformationFor(type: Storable.Type) -> TypeInformation {
        return TypeInformation(name:            String(describing: type),
                               properties:      properties(for: type),
                               identifierName:  type.identifier())
    }
    
    /** Get information reflecting the database's represntation of the type */
    static func typeInformationFor(type: Storable.Type, in database: DatabaseConnection) throws -> TypeInformation {
        
        let statement = try database.statement(for: "SELECT * FROM \(type.name) LIMIT 0")
                                    .execute()
        
        let properties = Array(statement.dictionary.keys)
        
        try statement.finalize()
        
        return TypeInformation(name:            String(describing: type),
                               properties:      properties,
                               identifierName:  type.identifier())
    }
    
}
