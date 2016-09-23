//
//  Indexable.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 04/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

/** Defined an indexable type */
protocol Indexable {
    /**
     Defines how to index a type
     
     - parameters:
        - index: an index type used to define indices
     */
    static func index(index: Index)
}
