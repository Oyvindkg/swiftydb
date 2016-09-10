//
//  TypeInformation.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 02/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation


struct TypeInformation: Storeable {
    
    var name = ""
    var properties: [String: String] = [:]
    var version = 0
    var identifierName = ""
    var indices: Set<String> = []
    
    static func newInstance() -> Mappable {
        return TypeInformation()
    }
    
    mutating func mapping(map: MapType) {
        name            <- map["name"]
        properties      <- map["properties"]
        version         <- map["version"]
        identifierName  <- map["identifierName"]
    }
    
    static func identifier() -> String {
        return "name"
    }
}