//
//  DeleteQuery.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 10/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

public class DeleteQuery<T: Storeable>: Query<T> {
    
    public typealias ResultType = Void
    
    private let database: ObjectDatabase
    
    internal init(database: ObjectDatabase) {
        self.database = database
    }
    
    public func filter(filter: FilterStatement, resultHandler: (Result<ResultType> -> Void)?) {
        self.filter(filter)
        
        self.database.delete(self, resultHandler: resultHandler)
    }
}
