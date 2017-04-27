//
//  QueryType.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 10/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

/** Defines how to order retrieved results */
public enum Order {
    
    /** Use the default order of results */
    case none
    
    /** Order the results in ascending order on the provided property */
    case ascending(on: String)
    
    /** Order the results in descending order on the provided property */
    case descending(on: String)
}

/** Contains all properties used to build a query */
public protocol AnyQuery {
    
    /** The type to be retrieved or deleted */
    var type: Storable.Type {get}
    
    /** Filters used to limit the objects to retrieve or delete */
    var filter: FilterStatement? { get }
    
    /** The maximum number of results to retrieve */
    var limit: Int? {get}
    
    /** The number of results to skip when retrieving objects */
    var skip: Int? {get}
    
    /** The desired ordering for retrieved objects */
    var order: Order {get}
}

/** A generic query used to retrieve objects */
public protocol StorableQuery: class, AnyQuery {
    
    /** The type to be retrieved or deleted */
    associatedtype Subject: Storable
}


/** A simple data structure used as a non-generic, internal replacement for Query */
internal struct SimpleQuery: AnyQuery {
    
    /** The type to be retrieved or deleted */
    var type: Storable.Type
    
    /** Filters used to limit the objects to retrieve or delete */
    var filter: FilterStatement?
    
    /** The maximum number of results to retrieve */
    var limit: Int?
    
    /** The number of results to skip when retrieving objects */
    var skip: Int?
    
    /** The desired ordering for retrieved objects */
    var order: Order
    
    init(type: Storable.Type, filter: FilterStatement? = nil, skip: Int? = nil, limit: Int? = nil, order: Order = .none) {
        self.type    = type
        self.filter  = filter
        self.skip    = skip
        self.limit   = limit
        self.order   = order
    }
}
