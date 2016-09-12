//
//  Index.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 04/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

/** Class used to create indices on a set of properties, with optional filters */
class Index: IndexType, _IndexType {
    let type: Storeable.Type
    
    var indices: [_IndexInstanceType]
    
    init(type: Storeable.Type) {
        self.type = type
        self.indices = []
    }
    
    func on(properties: String...) -> IndexInstanceType {
        return on(properties)
    }
    
    func on(properties: [String]) -> IndexInstanceType {
        let index = IndexInstance(type: type)
        
        index.properties = properties
        
        indices.append(index)
        
        return index
    }
}
