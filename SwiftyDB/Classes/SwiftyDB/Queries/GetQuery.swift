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
    
    private let database: ObjectDatabaseType
    
    internal init(database: ObjectDatabaseType) {
        self.database = database
    }
    
    public func filter(filter: FilterStatement, resultHandler: (Result<ResultType> -> Void)?) {
        self.filter(filter)
        
        self.database.get(self, resultHandler: resultHandler)
    }
    
    public func limit(limit: Int, resultHandler: (Result<ResultType> -> Void)?) {
        self.limit(limit)
        
        self.database.get(self, resultHandler: resultHandler)
    }
    
    public func offset(offset: Int, resultHandler: (Result<ResultType> -> Void)?) {
        self.offset(offset)
        
        self.database.get(self, resultHandler: resultHandler)
    }
    
    public func sort(property: String, ascending: Bool = true, resultHandler: (Result<ResultType> -> Void)?) {
        self.sort(property, ascending: ascending)
        
        self.database.get(self, resultHandler: resultHandler)
    }
}