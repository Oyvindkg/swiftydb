//
//  Stark.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 29/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import SwiftyDB

class Stark: Storable {
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
}

extension Stark: Hashable {
    var hashValue: Int {
        return name.hashValue
    }
}

extension Stark: Mappable {
    
    static func mappableObject() -> Mappable {
        return Stark(name: "Sansa", weight: 56.2, age: 14)
    }
    
    func map<M>(using mapper: inout M) where M : Mapper {
        name     <- mapper["name"]
        age      <- mapper["age"]
        weight   <- mapper["weight"]
        wolf     <- mapper["wolf"]
        siblings <- mapper["siblings"]
    }
}

extension Stark: Identifiable {
    static func identifier() -> String {
        return "name"
    }
}

extension Stark: SwiftyDB.Indexable {
    static func indices() -> [SwiftyDB.AnyIndex] {
        return [
            Index.on("name").where("name" == "Sansa" && "age" > 10 || ("wolf" == "Ghost" && "age" << (0..<20)))
        ]
    }
}

func ==(lhs: Stark, rhs: Stark) -> Bool {
    return lhs.age == rhs.age && lhs.name == rhs.name && lhs.weight == rhs.weight && lhs.wolf == rhs.wolf && lhs.siblings ?? [] == rhs.siblings ?? []
}

extension Stark: Equatable {}
