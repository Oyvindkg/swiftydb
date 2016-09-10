//
//  Dog.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 29/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import SwiftyDB

enum Breed: String {
    case Dachs = "dachs"
}

class Dog: Storeable {
    var bones   = [Bone(dnr: "12321"), Bone(dnr: "asdasdasdsda"), Bone(), Bone(dnr: "0123"), Bone(dnr: "0123")]
    var ids: [Double] = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
    var dates: [NSDate] = [NSDate(), NSDate().dateByAddingTimeInterval(123123)]
    var type    = Breed.Dachs
    
    var name: String
    var name1: String
    var name2: String
    var name3: String
    var name4: String
    var name5: String
    var name6: String
    
    var age: Int
    var superBone: Bone
    
    init() {
        superBone = Bone(dnr: "\(arc4random_uniform(100))")
        age = Int(arc4random_uniform(100))
        name = "\(arc4random())"
        name1 = "\(arc4random())"
        name2 = "\(arc4random())"
        name3 = "\(arc4random())"
        name4 = "\(arc4random())"
        name5 = "\(arc4random())"
        name6 = "\(arc4random())"
    }
    
    func mapping(map: MapType) {
//        name            <- map["name"]
        name1            <- map["name1"]
        name2            <- map["name2"]
        name3            <- map["name3"]
        name4            <- map["name4"]
        name5            <- map["name5"]
        name6            <- map["name6"]
//        age             <- map["age"]
//        type            <- map["type"]
//        bones           <- map["bones"]
//        superBone       <- map["superBone"]
        dates           <- map["dates"]
        ids             <- map["numbers"]
    }
    
    class func newInstance() -> Mappable {
        return Dog()
    }
    
    // TODO: Make sure the identifier is a valid property
    class func identifier() -> String {
        return "name"
    }
}

class Dogger: Dog {
    override class func newInstance() -> Mappable {
        return Dogger()
    }
}

//extension Dog: Migratable {
//    static func migrate(migration: MigrationType) {
//        print("sasd")
//        if migration.currentVersion < 1 {
////            migration.migrate("numbers").rename("ids").transform([Int].self, to: [Double].self) { intArray in
////                if let array = intArray {
////                    return array.map { Double($0) }
////                }
////                
////                return nil
////            }
//        }
//    }
//}