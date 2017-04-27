//
//  Indexable.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 04/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation


public protocol AnyIndex {
    
    /** The properties to be indexed */
    var properties: [String] { get }

    /** 
    Optional filters used to constrain the index domain.
     
    This is similar to a `WHERE` clause in SQL
    */
    var filter: FilterStatement? { get }
}

/** 
A structure representing an index in the database  

This is simply here for your convenience. You may implement the `AnyIndex` protocol in any object and use it as an index.
*/
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
