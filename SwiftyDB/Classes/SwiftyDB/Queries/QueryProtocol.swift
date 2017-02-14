//
//  QueryType.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 10/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

/** Contains all valid filter methods */
public protocol QueryProtocol {
    func limit(_ max: Int) -> Self
    func skip(_ start: Int) -> Self
    func filter(_ filter: FilterStatement) -> Self
    func sort(by property: String, ascending: Bool) -> Self
}

/** A query representation used internally */
protocol _QueryProtocol {
    var type:   Storable.Type {get}
    var filter: FilterStatement? { get }
    var max:    Int? {get}
    var start:  Int? {get}
    var sorting: Sorting {get}
}
