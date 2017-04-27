//
//  Indexable.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 04/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation


public protocol AnyIndex {
    var filter: FilterStatement? { get }
    var properties: [String] { get }
}

public class Index: AnyIndex {
    public var filter: FilterStatement?
    public var properties: [String]
    
    internal init(properties: [String]) {
        self.properties = properties
    }
    
    public static func on(_ properties: [String]) -> Index {
        return Index(properties: properties)
    }
    
    public static func on(_ properties: String...) -> Index {
        return Index(properties: properties)
    }
    
    public func `where`(_ filter: FilterStatement) -> Index {
        self.filter = filter
        
        return self
    }
}


/** Defined an indexable type */
public protocol Indexable {
    static func indices() -> [AnyIndex]
}
