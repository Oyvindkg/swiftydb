//
//  Index.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 04/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

/** Class used to create indices on a set of properties, with optional filters */
class DefaultIndexer: Indexer {

    let type: Storable.Type
    
    var indices: [Index]
    
    init(type: Storable.Type) {
        self.type = type
        self.indices = []
    }
    
    /**
     Define an index on a collection of properties
     
     - parameters:
     - properties: the properties to be used in the index
     */
    public func index(on properties: [String]) -> Index {
        let index = DefaultIndex(type: type)
        
        index.properties = properties
        
        indices.append(index)
        
        return index
    }
}
