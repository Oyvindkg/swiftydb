//
//  QueryType.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 10/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

public enum Sorting {
    case none
    case ascending(on: String)
    case descending(on: String)
}

/** Contains all valid filter methods */
public protocol AnyQuery {
    var type:   Storable.Type {get}
    var filter: FilterStatement? { get }
    var max:    Int? {get}
    var start:  Int? {get}
    var sorting: Sorting {get}
}

public protocol StorableQuery: class, AnyQuery {
    associatedtype Subject: Storable
    
    func `where`(_ filter: FilterStatement) -> Self
    func order(by property: String, ascending: Bool) -> Self
    func skip(_ skipped: Int) -> Self
    func limit(_ max: Int) -> Self
}

extension StorableQuery {
    
    public func order(by property: String) -> Self {
        return order(by: property, ascending: true)
    }
}



/** A simple data structure used as a non-generic, internal replacement for Query */
internal struct SimpleQuery: AnyQuery {
    
    var type: Storable.Type
    var filter: FilterStatement?
    var start: Int?
    var max: Int?
    var sorting: Sorting
    
    init(type: Storable.Type, filter: FilterStatement? = nil, start: Int? = nil, max: Int? = nil, sorting: Sorting = .none) {
        self.type    = type
        self.filter  = filter
        self.start   = start
        self.max     = max
        self.sorting = sorting
    }
}
