//
//  TypeInformation.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 02/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation


struct TypeInformation: Storable {
    
    var name                    = ""
    var properties: [String]    = []
    var identifierName          = ""
    
    static func mappableObject() -> Any {
        return TypeInformation()
    }
    
    mutating func mapping(map: Map) {
        name            <- map["name"]
        properties      <- map["properties"]
        identifierName  <- map["identifierName"]
    }
    
    static func identifier() -> String {
        return "name"
    }
}
