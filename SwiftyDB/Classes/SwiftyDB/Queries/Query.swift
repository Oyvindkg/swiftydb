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
    
    /**
     Filter objects matching the provided statement
     
     - parameters:
        - filter:  a filter statement
     
     - returns: self
     */
    public func filter(filter: FilterStatement) -> Self {
        self.filter = filter
        
        return self
    }
    
    /**
     Set maximum number of results
     
     - parameters:
        - max:  the maximum number of results
     
     - returns: self
     */
    public func max(max: Int) -> Self {
        self.max = max
        
        return self
    }
    
    /**
     Skip the first n results
     
     - parameters:
        - skip: the number of results to skip
     
     - returns: self
     */
    public func start(start: Int) -> Self {
        self.start = start
        
        return self
    }
    
    /**
     Sort the results on a provided property
     
     - parameters:
        - property:     name of the property to be sorted on
        - ascending:    boolean indicating whether the objects should be sorted ascending or descending
     
     - returns: self
     */
    public func sortBy(property: String, ascending: Bool = true) -> Self {
        self.sorting = ascending ? .ascending(property) : .descending(property)
        
        return self
    }
}


