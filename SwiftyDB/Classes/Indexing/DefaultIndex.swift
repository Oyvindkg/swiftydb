//
//  IndexInstance.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 10/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

class DefaultIndex: Index {
    
    let type: Storable.Type
    
    /** Filters used to limit the data indexed by this index */
    var filter: FilterStatement?

    var properties: [String] = []
    
    init(type: Storable.Type) {
        self.type = type
    }
    
    func `where`(_ filter: FilterStatement) -> Index {
        self.filter = filter
        
        return self
    }
}
