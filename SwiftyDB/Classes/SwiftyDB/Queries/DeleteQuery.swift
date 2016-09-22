//
//  DeleteQuery.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 10/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

/**
 A database query used to delete objects
 
 This query object can be stored and reused times
 */
public class DeleteQuery<T: Storeable>: Query<T> {
    
    public typealias ResultType = Void
    
    private let database: ObjectDatabase
    
    internal init(database: ObjectDatabase) {
        self.database = database
    }
    
    /**
     Filter objects matching the provided statement and get the results
     
     - parameters:
        - filter:           a filter statement
        - resultHandler:    and optional result handler
     */
    public func filter(filter: FilterStatement, resultHandler: (Result<ResultType> -> Void)?) {
        self.filter(filter)
        
        self.database.delete(self, resultHandler: resultHandler)
    }
}
