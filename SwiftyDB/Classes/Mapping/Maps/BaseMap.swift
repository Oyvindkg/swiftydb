//
//  BaseMap.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 22/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation


class BaseMap {
    
    /* Properties */
    let type: Mappable.Type
    var currentKey: String?
    
    var storeableValues: [String: StoreableValue] = [:]
    var storeableValueArrays: [String: [StoreableValue?]] = [:]
    
    var mappables: [String: MapType] = [:]
    var mappableArrays: [String: [MapType]] = [:]
    
    init(type: Mappable.Type) {
        self.type = type
    }
}

//extension BaseMap: Map {
//    subscript(key: String) -> Map {
//        currentKey = key
//        
//        return self
//    }
//}