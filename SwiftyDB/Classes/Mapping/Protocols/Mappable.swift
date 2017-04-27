//
//  Mapable.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 19/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

/** Defines mappable objects */
public protocol Mappable {
        
    /** Used to map objects with data from the database */
    static func mappableObject() -> Mappable
    
    /** 
    Used to map properties when reading from and writing to the object
     
    - parameters:
        - map: a map to be read or written
    */
    mutating func map<M>(using mapper: inout M) where M : Mapper
}
