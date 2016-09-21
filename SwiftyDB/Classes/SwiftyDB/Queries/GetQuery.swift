//
//  GetQuery.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 10/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

public class GetQuery<T: Storeable>: Query<T> {
    
    public typealias ResultType = [SubjectType]
    
    private let database: ObjectDatabase
    
    internal init(database: ObjectDatabase) {
        self.database = database
    }
    
    public func filter(filter: FilterStatement, resultHandler: (Result<ResultType> -> Void)?) {
        self.filter(filter)
        
        self.database.get(self, resultHandler: resultHandler)
    }
    
    public func start(start: Int, resultHandler: (Result<ResultType> -> Void)?) {
        self.start(start)
        
        self.database.get(self, resultHandler: resultHandler)
    }
    
    public func max(max: Int, resultHandler: (Result<ResultType> -> Void)?) {
        self.max(max)
        
        self.database.get(self, resultHandler: resultHandler)
    }
    
    public func sortBy(property: String, ascending: Bool = true, resultHandler: (Result<ResultType> -> Void)?) {
        self.sortBy(property, ascending: ascending)
        
        self.database.get(self, resultHandler: resultHandler)
    }
}
