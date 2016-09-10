//
//  Stark.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 29/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import SwiftyDB

class Stark: Storeable {
    var name: String
    var age: Int
    var weight: Double
    var wolf: Wolf?
    
    var siblings: [Stark]?
    
    init(name: String, weight: Double, age: Int, wolf: Wolf? = nil) {
        self.name = name
        self.age = age
        self.weight = weight
        self.wolf = wolf
    }
    
    static func newInstance() -> Mappable {
        return Stark(name: "Sansa", weight: 56.2, age: 14)
    }
    
    static func identifier() -> String {
        return "age"
    }
    
    func mapping(map: MapType) {
        name   <- map["name"]
        age    <- map["age"]
        weight <- map["weight"]
        wolf   <- map["wolf"]
        siblings <- map["siblings"]
    }
}