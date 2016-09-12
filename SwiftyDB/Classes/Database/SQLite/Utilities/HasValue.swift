//
//  HasValue.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 22/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

class HasValue: Storeable {
    
    var id             = ""
    var index          = ""
        
    var parentType     = ""
    var parentID       = ""
    var parentProperty = ""
    
    init() {}
    
    class func newInstance() -> Mappable {
        return HasValue()
    }
    
    init(parentType: String, parentID: String, parentProperty: String, index: String = "") {
        self.parentType = parentType
        self.parentID = parentID
        self.parentProperty = parentProperty
        
        self.index = index
        self.id = "\(parentType):\(parentID):\(parentProperty):\(self.index)"
    }
    
    func mapping(map: MapType) {
        id              <- map["id"]
        index           <- map["index"]
                
        parentID        <- map["parentID"]
        parentType      <- map["parentType"]
        parentProperty  <- map["parentProperty"]
    }
    
    static func identifier() -> String {
        return "id"
    }
}