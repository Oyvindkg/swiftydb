//
//  IndexType.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 10/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

/** Protocol used to create indices on a set of properties */
public protocol IndexType {
    
    /** 
     Define an index on a collection of properties
     
     - parameters:
        - properties: the properties to be used in the index
     */
    func on(properties: String...) -> IndexInstanceType
    
    /**
     Define an index on a collection of properties
     
     - parameters:
        - properties: the properties to be used in the index
     */
    func on(properties: [String]) -> IndexInstanceType
}

/* An internal index type representation */
protocol _IndexType {
    var type: Storable.Type { get }
    
    var indices: [_IndexInstanceType] { get }
}
