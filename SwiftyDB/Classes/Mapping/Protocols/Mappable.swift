//
//  Mapable.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 19/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

public protocol Mappable {
    /** Objects must be initializeable in order to be mapped */
    static func newInstance() -> Mappable
    
    /** Used to map properties when reading from and writing to the object */
    mutating func mapping (map: MapType)
}