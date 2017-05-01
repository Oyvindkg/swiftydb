//
//  Wolf.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 29/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import SwiftyDB

struct Wolf: Storable {
    var name: String
    var age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    
    static func mappableObject() -> Mappable {
        return Wolf(name: "", age: 0)
    }
    
    mutating func map<M>(using mapper: inout M) where M : Mapper {
        name <- mapper["name"]
        age  <- mapper["age"]
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

func ==(lhs: Wolf, rhs: Wolf) -> Bool {
    return lhs.age == rhs.age && lhs.name == rhs.name
}

extension Wolf: Equatable {}
