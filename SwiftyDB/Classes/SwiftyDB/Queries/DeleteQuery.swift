//
//  DeleteQuery.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 10/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import PromiseKit

/**
 A database query used to delete objects
 
 This query object can be stored and reused times
 */
open class DeleteQuery<T: Storable>: Query<T> {
    
    public typealias Result = Void
    
    fileprivate let database: ObjectDatabase
    
    internal init(database: ObjectDatabase) {
        self.database = database
    }
    
    /**
     Filter objects matching the provided statement and get the results
     
     - parameters:
        - filter:           a filter statement
     */
    open func `where`(_ filter: FilterStatement) -> Promise<Result> {
        return self.database.delete(using: self.where(filter))
    }
}
