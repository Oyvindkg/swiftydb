//
//  MockDatabase.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 29/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

@testable import SwiftyDB

struct ObjectDatabaseMock: ObjectDatabaseType {
    
    func add<T : Storeable>(object: T, resultHandler: (Result<Void> -> Void)?) {
        add([object], resultHandler: resultHandler)
    }
    
    func add<T : Storeable>(objects: [T], resultHandler: (Result<Void> -> Void)?) {
        resultHandler?(.Success())
    }
    

    func get<T : Storeable>(query: Query<T>, resultHandler: (Result<[T]> -> Void)?) {
        resultHandler?(.Success([]))
    }

    func get<T : Storeable>(type: T.Type) -> GetQuery<T> {
        return GetQuery(database: self)
    }
    
    func get<T : Storeable>(type: T.Type, resultHandler: (Result<[T]> -> Void)?) {
        let query = Query<T>()
        
        get(query, resultHandler: resultHandler)
    }
    
    func delete<T : Storeable>(type: T.Type, resultHandler: (Result<Void> -> Void)?) {
        let query = Query<T>()
        
        delete(query, resultHandler: resultHandler)
    }
    
    func delete<T : Storeable>(query: Query<T>, resultHandler: (Result<Void> -> Void)?) {
        resultHandler?(.Success())
    }
    
}