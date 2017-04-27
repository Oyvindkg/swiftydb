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
    
    public var type: Storable.Type {
        return Subject.self
    }
    
    public var filter: FilterStatement?
    public var max: Int?
    public var start: Int?
    public var sorting: Sorting
    
    init() {
        sorting = .none
    }
    
    public static func get(_ type: Subject.Type) -> Query<Subject> {
        return Query<Subject>()
    }
    
    public static func delete(_ type: Subject.Type) -> Query<Subject> {
        return Query<Subject>()
    }
    
    public func limit(_ max: Int) -> Self {
        self.max = max
        
        return self
    }
    
    public func skip(_ skipped: Int) -> Self {
        start = skipped
        
        return self
    }
    
    public func order(by property: String, ascending: Bool = true) -> Self {
        if ascending {
            sorting = .ascending(on: property)
        } else {
            sorting = .descending(on: property)
        }
        
        return self
    }
    
    public func `where`(_ filter: FilterStatement) -> Self {
        self.filter = filter
        
        return self
    }
}
