//
//  GetQuery.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 10/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import PromiseKit

/**
 A database query used to retrieve objects
 
 This query object can be stored and reused times
 */
open class GetQuery<T: Storable>: Query<T> {
    
    public typealias Result = [Subject]
    
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
    open func `where`(_ filter: FilterStatement) -> Promise<Result> {
        return database.get(using: self.where(filter))
    }
    
    /**
     Skip the first n results and get the results
     
     - parameters:
        - start:            number of results to skip
        - resultHandler:    and optional result handler
     */
    open func skip(_ start: Int) -> Promise<Result> {
        return database.get(using: skip(start))
    }
    
    /**
     Set maximum number of results and get the results
     
     - parameters:
        - max:              the maximum number of results
        - resultHandler:    and optional result handler
    */
    open func limit(_ max: Int) -> Promise<Result> {
        return database.get(using: limit(max))
    }
    
    /**
     Sort the results on a provided property and get the results
     
     - parameters:
        - property:         name of the property to be sorted on
        - ascending:        boolean indicating whether the objects should be sorted ascending or descending
        - resultHandler:    and optional result handler
    */
    open func order(by property: String, ascending: Bool = true) -> Promise<Result> {
        return database.get(using: order(by: property, ascending: ascending))
    }
}
