//
//  IndexType.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 10/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

/** Protocol used to create indices on a set of properties */
public protocol IndexType {
    func on(properties: String...) -> IndexInstanceType
    func on(properties: [String]) -> IndexInstanceType
}

protocol _IndexType {
    var indices: [IndexInstanceType] { get }
}
