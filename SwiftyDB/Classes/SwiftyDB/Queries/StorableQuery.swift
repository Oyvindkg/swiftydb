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

public protocol StorableQuery: AnyQuery {
    associatedtype Subject: Storable
}
