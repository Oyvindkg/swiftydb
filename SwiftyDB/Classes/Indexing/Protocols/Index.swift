//
//  IndexType.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 10/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

/** Protocol used to create indices on a set of properties */
public protocol Index {
    
    /** 
     Define an index on a collection of properties
     
     - parameters:
        - properties: the properties to be used in the index
     */
    func on(properties: String...) -> IndexInstance
    
    /**
     Define an index on a collection of properties
     
     - parameters:
        - properties: the properties to be used in the index
     */
    func on(properties: [String]) -> IndexInstance
}

/* An internal index type representation */
protocol _Index {
    var type: Storable.Type { get }
    
    var indices: [_IndexInstance] { get }
}
