//
//  TestClass.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 30/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import SwiftyDB

class TestClass: Storable {
    
    var storableProperty            = "John"
    var storablePropertyArray      = [12]
    var storablePropertySet        = [0.1,0.2]
    var storablePropertyDictionary = ["age": 11]
    
    var storable: Stark           = Stark(name: "John", weight: 80, age: 16)
    var storableArray: [Stark]    = [Stark(name: "John", weight: 80, age: 16)]
    var storableSet: Set<Stark>   = [Stark(name: "John", weight: 80, age: 16)]
    
    
    var optionalStorableProperty: String?                   = "John"
    var optionalStorablePropertyArray: [Int]?              = [12]
    var optionalStorablePropertySet: [Double]?             = [0.1,0.2]
    var optionalStorablePropertyDictionary: [String: Int]? = ["age": 11]
    
    var optionalStorable: Stark?           = Stark(name: "John", weight: 80, age: 16)
    var optionalStorableArray: [Stark]?    = [Stark(name: "John", weight: 80, age: 16)]
    var optionalStorableSet: Set<Stark>?   = [Stark(name: "John", weight: 80, age: 16)]
    
    
    var unwrappedStorableProperty: String!                   = "John"
    var unwrappedStorablePropertyArray: [Int]!              = [12]
    var unwrappedStorablePropertySet: [Double]!             = [0.1,0.2]
    var unwrappedStorablePropertyDictionary: [String: Int]! = ["age": 11]
    
    var unwrappedStorable: Stark!           = Stark(name: "John", weight: 80, age: 16)
    var unwrappedStorableArray: [Stark]!    = [Stark(name: "John", weight: 80, age: 16)]
    var unwrappedStorableSet: Set<Stark>!   = [Stark(name: "John", weight: 80, age: 16)]
}

extension TestClass: Mappable {
    static func mappableObject() -> Mappable {
        return TestClass()
    }
    
    func map<M>(using mapper: inout M) where M : Mapper {

        storableProperty            <- mapper["storableProperty"]
        storablePropertyArray       <- mapper["storablePropertyArray"]
        storablePropertySet         <- mapper["storablePropertySet"]
        storablePropertyDictionary  <- mapper["storablePropertyDictionary"]
        
        storable      <- mapper["storable"]
        storableArray <- mapper["storableArray"]
        storableSet   <- mapper["storableSet"]
        
        
        optionalStorableProperty            <- mapper["optionalStorableProperty"]
        optionalStorablePropertyArray       <- mapper["optionalStorablePropertyArray"]
        optionalStorablePropertySet         <- mapper["optionalStorablePropertySet"]
        optionalStorablePropertyDictionary  <- mapper["optionalStorablePropertyDictionary"]
        
        optionalStorable      <- mapper["optionalStorable"]
        optionalStorableArray <- mapper["optionalStorableArray"]
        optionalStorableSet   <- mapper["optionalStorableSet"]
        
        
        unwrappedStorableProperty            <- mapper["unwrappedStorableProperty"]
        unwrappedStorablePropertyArray       <- mapper["unwrappedStorablePropertyArray"]
        unwrappedStorablePropertySet         <- mapper["unwrappedStorablePropertySet"]
        unwrappedStorablePropertyDictionary  <- mapper["unwrappedStorablePropertyDictionary"]
        
        unwrappedStorable      <- mapper["unwrappedStorable"]
        unwrappedStorableArray <- mapper["unwrappedStorableArray"]
        unwrappedStorableSet   <- mapper["unwrappedStorableSet"]
    }
}

extension TestClass: Identifiable {
    static func identifier() -> String {
        return "storableProperty"
    }
}
