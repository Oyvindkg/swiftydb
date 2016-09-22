//
//  Bone.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 29/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

class Bone: Storable {
    var weight: Double = 12.3
    var dnr: String = "12321321"
    
    init() {}
    
    init(dnr: String) {
        self.dnr = dnr
    }
    
    static func mappableObject() -> Mappable {
        return Bone()
    }
    
    func mapping(map: MapType) {
        dnr     <- map["dnr"]
        weight  <- map["weight"]
    }
    
    static func identifier() -> String {
        return "dnr"
    }
}
