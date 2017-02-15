//
//  IndexInstanceType.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 10/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

/** Represents a single index with optional filters */
public protocol Index {
    
    /** The type the index indexes */
    var type: Storable.Type { get }
    
    /** The the indexed properties */
    var properties: [String] { get }
    
    /** Filters used to limit the data indexed by this index */
    var filter: FilterStatement? { get }
    
    /**
     Filter the objects to use in the index
     
     - parameters:
        - filter: a filter statement
     */
    @discardableResult func `where`(_ filter: FilterStatement) -> Index
}
