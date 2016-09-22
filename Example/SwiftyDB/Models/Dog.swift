//
//  Dog.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 29/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import SwiftyDB

enum Breed: String {
    case dachs = "dachs"
}

class Dog: Storable {
    var bones           = [Bone(dnr: "12321"), Bone(dnr: "asdasdasdsda"), Bone(), Bone(dnr: "0123"), Bone(dnr: "0123"), Bone(dnr: "0123")]
    var ids: [Double]   = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
    var dates           = [NSDate(), NSDate().dateByAddingTimeInterval(123123)]
    var type            = Breed.dachs
    
    var name: String
    var age: Double
    var superBone: Bone
    var weight: Double
    
    init() {
        superBone = Bone(dnr: "\(arc4random_uniform(100))")
        age = Double(arc4random_uniform(100))
        name = "\(arc4random())"
        weight = 13.3
    }
    
    func mapping(map: MapType) {
        name            <- map["name"]
        age             <- map["age"]
        type            <- map["type"]
        weight          <- map["weight"]
//        bones           <- map["bones"]
        superBone       <- map["superBone"]
//        dates           <- map["dates"]
        ids             <- map["numbers"]
    }
    
    class func mappableObject() -> Mappable {
        return Dog()
    }
    
    // TODO: Make sure the identifier is a valid property
    class func identifier() -> String {
        return "name"
    }
}

extension Dog: Migratable {
    static func migrate(inout migration: MigrationType) {
        if migration.schemaVersion < 1 {
            migration.add("numbers", defaultValue: [] as [Double])

            migration.schemaVersion = 1
        }
    }
}
