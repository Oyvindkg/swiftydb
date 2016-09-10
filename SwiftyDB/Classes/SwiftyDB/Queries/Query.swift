//
//  GetQuery.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 02/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation


public class Query<T: Storeable>: QueryType, _QueryType {
    
    public typealias SubjectType = T
    
    internal let type: Storeable.Type = T.self
    
    internal var filter: FilterStatement?
    internal var limit: Int?
    internal var offset: Int?
    internal var sorting: Sorting = .None
    
    public func filter(filter: FilterStatement) -> Self {
        self.filter = filter
        
        return self
    }
    
    public func limit(limit: Int) -> Self {
        self.limit = limit
        
        return self
    }
    
    public func offset(offset: Int) -> Self {
        self.offset = offset
        
        return self
    }
    
    public func sort(property: String, ascending: Bool = true) -> Self {
        self.sorting = ascending ? .Ascending(property) : .Descending(property)
        
        return self
    }
}


