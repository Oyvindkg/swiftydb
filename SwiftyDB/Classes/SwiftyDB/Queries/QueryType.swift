//
//  QueryType.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 10/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

public protocol QueryType {
    func filter(filter: FilterStatement) -> Self
    func limit(limit: Int) -> Self
    func offset(offset: Int) -> Self
    func sort(property: String, ascending: Bool) -> Self
}

protocol _QueryType {
    var type: Storeable.Type {get}
    var filter: FilterStatement? { get }
    var limit: Int? {get}
    var offset: Int? {get}
    var sorting: Sorting {get}
}