//
//  IndexInstanceType.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 10/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

/** Represents a single index with optional filters */
public protocol IndexInstance {
    
    /**
     Filter the objects to use in the index
     
     - parameters:
        - filter: a filter statement
     */
    func filter(_ filter: FilterStatement) -> IndexInstance
}

/** An internal index instance representation */
protocol _IndexInstance {
    var type: Storable.Type { get }
    var properties: [String] { get }
    var filters: FilterStatement? { get }
}
