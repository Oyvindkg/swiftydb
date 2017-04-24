//
//  GetQuery.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 02/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

/**
 A database query
 
 This query object can be stored and reused times
 */
public struct Query<T: Storable>: StorableQuery {
    public typealias Subject = T

    public var type: Storable.Type {
        return Subject.self
    }
    
    public var filter: FilterStatement?
    public var max: Int?
    public var start: Int?
    public var sorting: Sorting
    
    public init() {
        sorting = .none
    }
}
