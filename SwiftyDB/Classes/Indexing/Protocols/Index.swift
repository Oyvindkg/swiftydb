//
//  IndexType.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 10/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

/** Protocol used to create indices on a set of properties */
public protocol Indexer {
    
    var type: Storable.Type { get }
    
    var indices: [Index] { get }
    
    /**
     Define an index on a collection of properties
     
     - parameters:
        - properties: the properties to be used in the index
     */
    @discardableResult func index(on properties: [String]) -> Index
}

extension Indexer {
    /**
     Define an index on a collection of properties
     
     - parameters:
     - properties: the properties to be used in the index
     */
    @discardableResult public func index(on properties: String...) -> Index {
        return index(on: properties)
    }
}
