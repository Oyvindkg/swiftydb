//
//  MigrationUtils.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 02/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import TinySQLite

internal struct TypeInformation {
    var name                    = ""
    var properties: [String]    = []
    var identifierName          = ""
}

extension TypeInformation: Equatable {}

internal func ==(lhs: TypeInformation, rhs: TypeInformation) -> Bool {
    return lhs.identifierName == rhs.identifierName
        && lhs.name == rhs.name
        && lhs.properties == rhs.properties
}


internal struct MigrationUtilities {
    
    /** Get a list of property names for the type */
    static func properties(for type: Mappable.Type) -> [String] {
        
        let reader = ObjectMapper.read(type: type)
        
        return Array(reader.propertyTypes.keys)
    }
    
    /** Get information reflecting the type */
    static func typeInformationFor(type: Storable.Type) -> TypeInformation {
        return TypeInformation(name:            type.name,
                               properties:      properties(for: type),
                               identifierName:  type.identifier())
    }
    
    /** Get information reflecting the database's represntation of the type */
    static func typeInformationFor(type: Storable.Type, in database: DatabaseConnection) throws -> TypeInformation? {
        
        let statement = try database.statement(for: "PRAGMA table_info(\(type.name))")
                                    .execute()
        
        var properties: [String] = []
        var identifier: String?
        
        for row in statement {
            let name         = row.stringForColumn("name")!
            let isPrimaryKey = row.boolForColumn("pk")!
            
            properties.append(name)
            
            if isPrimaryKey {
                identifier = name
            }
        }
        
        try statement.finalize()
        
        if properties.isEmpty && identifier == nil {
            return nil
        }
        
        return TypeInformation(name:            type.name,
                               properties:      properties,
                               identifierName:  identifier!)
    }
}
