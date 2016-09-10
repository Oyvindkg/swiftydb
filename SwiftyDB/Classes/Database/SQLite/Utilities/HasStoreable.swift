//
//  HasMappable.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 22/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

class HasStoreable: HasValue {
    
    var childType = ""
    var childID   = ""
    
    override init() {
        super.init()
    }
    
    override class func newInstance() -> Mappable {
        return HasStoreable()
    }
    
    init(parentType: String, parentID: String, parentProperty: String, childType: String, childID: String, index: String = "") {
        self.childType = childType
        self.childID = childID
        
        super.init(parentType: parentType, parentID: parentID, parentProperty: parentProperty, index: index)
    }
    
    override func mapping(map: MapType) {
        super.mapping(map)

        childID         <- map["childID"]
        childType       <- map["childType"]
    }
}

/* Increases performance for migration and get requests by ~50% */
extension HasStoreable: Indexable {
    static func index(index: IndexType) {
        index.on("childType", "childID")
        index.on("parentType", "parentID", "parentProperty")
    }
}
