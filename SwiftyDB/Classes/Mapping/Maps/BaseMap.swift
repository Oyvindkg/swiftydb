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
    
    var storableValues: [String: StorableValue] = [:]
    var storableValueArrays: [String: [StorableValue?]] = [:]
    
    var mappables: [String: MapType] = [:]
    var mappableArrays: [String: [MapType]] = [:]
    
    init(type: Mappable.Type) {
        self.type = type
    }
}
