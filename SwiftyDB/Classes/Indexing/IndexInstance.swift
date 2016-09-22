//
//  IndexInstance.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 10/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

class IndexInstance: IndexInstanceType, _IndexInstanceType {
    let type: Storable.Type
    
    var filters: FilterStatement?
    
    var properties: [String] = []
    
    init(type: Storable.Type) {
        self.type = type
    }
    
    func filter(_ filter: FilterStatement) -> IndexInstanceType {
        self.filters = filter
        
        return self
    }
}
