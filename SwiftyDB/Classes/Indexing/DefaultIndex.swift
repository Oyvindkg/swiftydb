//
//  Index.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 04/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

/** Class used to create indices on a set of properties, with optional filters */
class DefaultIndex: Index, _Index {
    let type: Storable.Type
    
    var indices: [_IndexInstance]
    
    init(type: Storable.Type) {
        self.type = type
        self.indices = []
    }
    
    func on(properties: String...) -> IndexInstance {
        return on(properties: properties)
    }
    
    func on(properties: [String]) -> IndexInstance {
        let index = DefaultIndexInstance(type: type)
        
        index.properties = properties
        
        indices.append(index)
        
        return index
    }
}
