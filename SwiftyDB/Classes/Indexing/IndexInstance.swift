//
//  IndexInstance.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 10/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

class IndexInstance: IndexInstanceType, _IndexInstanceType {
    let type: Storeable.Type
    
    var filters: FilterStatement?
    
    var properties: [String] = []
    
    init(type: Storeable.Type) {
        self.type = type
    }
    
    func filter(filter: FilterStatement) -> IndexInstanceType {
        self.filters = filter
        
        return self
    }
}