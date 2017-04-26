//
//  Bone.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 29/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import SwiftyDB

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
    
    func map<M>(using mapper: inout M) where M : Mapper {
        dnr     <- mapper["dnr"]
        weight  <- mapper["weight"]
    }
    
    static func identifier() -> String {
        return "dnr"
    }
}
