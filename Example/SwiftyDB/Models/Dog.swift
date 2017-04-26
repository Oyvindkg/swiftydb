//
//  Dog.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 29/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import SwiftyDB

enum Breed: String, StorableProperty {
    case dachs = "dachs"
}

struct Dog: Storable {
    
    var bones           = [Bone(dnr: "12321"), Bone(dnr: "asdasdasdsda"), Bone(), Bone(dnr: "0123"), Bone(dnr: "0123"), Bone(dnr: "0123")]
    var ids: [Double]   = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
    var dates           = [Date(), Date().addingTimeInterval(123123)]
    var type            = Breed.dachs
    
    var name: String
    var age: Double
    var superBone: Bone
    var weight: Double
    
    init() {
        superBone = Bone(dnr: "\(arc4random_uniform(100))")
        age       = Double(arc4random_uniform(100))
        name      = "\(arc4random())"
        weight    = 13.3
    }
    
    mutating func map<M>(using mapper: inout M) where M : Mapper {
        name            <- mapper["name"]
        age             <- mapper["age"]
        type            <- mapper["type"]
        weight          <- mapper["weight"]
//        bones           <- mapper["bones"]
//        superBone       <- mapper["superBone"]
        dates           <- mapper["dates"]
        ids             <- mapper["numbers"]
    }
    
    static func mappableObject() -> Mappable {
        return Dog()
    }
    
    // TODO: Make sure the identifier is a valid property
    static func identifier() -> String {
        return "name"
    }
}
