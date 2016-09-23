//
//  GetQuery.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 10/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

/**
 A database query used to retrieve objects
 
 This query object can be stored and reused times
 */
open class GetQuery<T: Storable>: Query<T> {
    
    public typealias ResultType = [SubjectType]
    
    fileprivate let database: ObjectDatabase
    
    internal init(database: ObjectDatabase) {
        self.database = database
    }
    
    /**
     Filter objects matching the provided statement and get the results
     
     - parameters:
        - filter:           a filter statement
        - resultHandler:    and optional result handler
     */
    open func filter(_ filter: FilterStatement, resultHandler: ((Result<ResultType>) -> Void)?) {
        self.database.get(self.filter(filter), resultHandler: resultHandler)
    }
    
    /**
     Skip the first n results and get the results
     
     - parameters:
        - start:            number of results to skip
        - resultHandler:    and optional result handler
     */
    open func start(_ start: Int, resultHandler: ((Result<ResultType>) -> Void)?) {
        self.database.get(self.start(start), resultHandler: resultHandler)
    }
    
    /**
     Set maximum number of results and get the results
     
     - parameters:
        - max:              the maximum number of results
        - resultHandler:    and optional result handler
    */
    open func max(_ max: Int, resultHandler: ((Result<ResultType>) -> Void)?) {
        self.database.get(self.max(max), resultHandler: resultHandler)
    }
    
    /**
     Sort the results on a provided property and get the results
     
     - parameters:
        - property:         name of the property to be sorted on
        - ascending:        boolean indicating whether the objects should be sorted ascending or descending
        - resultHandler:    and optional result handler
    */
    open func sortBy(_ property: String, ascending: Bool = true, resultHandler: ((Result<ResultType>) -> Void)?) {
        self.database.get(self.sortBy(property, ascending: ascending), resultHandler: resultHandler)
    }
}
