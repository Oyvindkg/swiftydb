//
//  Wolf.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 29/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import SwiftyDB

struct Wolf: Storeable {
    var name: String
    var age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    
    static func newInstance() -> Mappable {
        return Wolf(name: "", age: 0)
    }
    
    mutating func mapping(map: MapType) {
        name <- map["name"]
        age  <- map["age"]
    }
    
    static func identifier() -> String {
        return "name"
    }
}

extension Wolf: Hashable {
    var hashValue: Int {
        return name.hashValue
    }
}