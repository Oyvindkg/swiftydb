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
    internal var max: Int?
    internal var start: Int?
    internal var sorting: Sorting = .none
    
    public func filter(filter: FilterStatement) -> Self {
        self.filter = filter
        
        return self
    }
    
    public func max(max: Int) -> Self {
        self.max = max
        
        return self
    }
    
    public func start(start: Int) -> Self {
        self.start = start
        
        return self
    }
    
    public func sortBy(property: String, ascending: Bool = true) -> Self {
        self.sorting = ascending ? .ascending(property) : .descending(property)
        
        return self
    }
}


