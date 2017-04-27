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
public class Query<T: Storable>: StorableQuery {
    
    public typealias Subject = T
    
    /** The type to be retrieved or deleted */
    public var type:   Storable.Type  {
        return Subject.self
    }
    
    /** Filters used to limit the objects to retrieve or delete */
    public var filter: FilterStatement?
    
    /** The maximum number of results to retrieve */
    public var limit: Int?
    
    /** The number of results to skip when retrieving objects */
    public var skip: Int?
    
    /** The desired ordering for retrieved objects */
    public var order: Order
    
    
    init() {
        order = .none
    }
    
    /** Create a new query 
    
    - note: `get(_ type:)` and `delete(_ type:)` both create identical queries. Both methods are available for improved semantics.
    
    - parameters:
        - type: the type to be queried
     
    - returns: A new `Query` to be used for retrieving and deleting objects
    */
    public static func get(_ type: Subject.Type) -> Query<Subject> {
        return Query<Subject>()
    }
    
    /** 
    Create a new query
     
    - note: `get(_ type:)` and `delete(_ type:)` both create identical queries. Both methods are available for improved semantics.
     
    - parameters:
        - type: the type to be queried
     
    - returns: A new `Query` to be used for retrieving and deleting objects
    */
    public static func delete(_ type: Subject.Type) -> Query<Subject> {
        return Query<Subject>()
    }
    
    /** 
    Limit the retrieved results
 
    - parameter max: the maximum number of results to be retrieved
 
    - returns: self
    */
    public func limit(to max: Int) -> Self {
        self.limit = max
        
        return self
    }
    
    /**
    Use this to skip the `skipped` first results when retrieving objects.

    - parameter skipped: the number of results to skip
     
    - returns: self
    */
    public func skip(_ skipped: Int) -> Self {
        skip = skipped
        
        return self
    }
    
    /**
    Use this to skip the `skipped` first results when retrieving objects.
     
    - parameters:
        - property:  the property to be used when ordering the results
        - ascending: boolean indicating whether the results should be sorted in ascending or descending order
     
    - returns: self
    */
    public func order(by property: String, ascending: Bool = true) -> Self {
        if ascending {
            order = .ascending(on: property)
        } else {
            order = .descending(on: property)
        }
        
        return self
    }
    
    /**
    Limit the objects to be retrieved or deleted by providing filters.
 
    A filter can be created like this:
    `"name" == "John" && "age" < 20`
 
    For more examples and a full list of available operators, see: https://github.com/Oyvindkg/swiftydb/tree/dev#retrievingObjects
 
    - parameter filter: filter used to limit the objects to be retrieved or deleted
 
    - returns: self
    */
    public func `where`(_ filter: FilterStatement) -> Self {
        self.filter = filter
        
        return self
    }
}
