//
//  GetQuery.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 02/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

public protocol QueryType {
    func filter(filter: FilterStatement) -> Self
    func limit(limit: Int) -> Self
    func offset(offset: Int) -> Self
    func sort(property: String, ascending: Bool) -> Self
}

protocol _QueryType {
    var type: Storeable.Type {get}
    var filter: FilterStatement? { get }
    var limit: Int? {get}
    var offset: Int? {get}
    var sorting: Sorting {get}
}


public class Query<T: Storeable>: QueryType, _QueryType {
    
    public typealias SubjectType = T
    
    internal let type: Storeable.Type = T.self
    
    internal var filter: FilterStatement?
    internal var limit: Int?
    internal var offset: Int?
    internal var sorting: Sorting = .None
    
    public func filter(filter: FilterStatement) -> Self {
        self.filter = filter
        
        return self
    }
    
    public func limit(limit: Int) -> Self {
        self.limit = limit
        
        return self
    }
    
    public func offset(offset: Int) -> Self {
        self.offset = offset
        
        return self
    }
    
    public func sort(property: String, ascending: Bool = true) -> Self {
        self.sorting = ascending ? .Ascending(property) : .Descending(property)
        
        return self
    }
}

public class GetQuery<T: Storeable>: Query<T> {
    
    public typealias ResultType = [SubjectType]
    
    private let database: Swifty
    
    internal init(database: Swifty) {
        self.database = database
    }
    
    public func filter(filter: FilterStatement, resultHandler: (Result<ResultType> -> Void)?) {
        self.filter(filter)
        
        let result = self.database.getSync(self)
        
        resultHandler?(result)
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

public class DeleteQuery<T: Storeable>: Query<T> {
    
    public typealias ResultType = Void
    
    private let database: Swifty
    
    internal init(database: Swifty) {
        self.database = database
    }
    
    public func filter(filter: FilterStatement, resultHandler: (Result<ResultType> -> Void)?) {
        self.filter(filter)
        
        self.database.delete(self, resultHandler: resultHandler)
    }
}
