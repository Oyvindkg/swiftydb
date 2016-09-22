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
open class Query<T: Storable>: QueryType, _QueryType {
    
    public typealias SubjectType = T
    
    internal let type: Storable.Type = T.self
    
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
    open func filter(_ filter: FilterStatement) -> Self {
        self.filter = filter
        
        return self
    }
    
    /**
     Set maximum number of results
     
     - parameters:
        - max:  the maximum number of results
     
     - returns: self
     */
    open func max(_ max: Int) -> Self {
        self.max = max
        
        return self
    }
    
    /**
     Skip the first n results
     
     - parameters:
        - skip: the number of results to skip
     
     - returns: self
     */
    open func start(_ start: Int) -> Self {
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
    open func sortBy(_ property: String, ascending: Bool = true) -> Self {
        self.sorting = ascending ? .ascending(property) : .descending(property)
        
        return self
    }
}


