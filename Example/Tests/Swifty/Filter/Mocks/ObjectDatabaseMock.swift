//
//  MockDatabase.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 29/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

@testable import SwiftyDB

struct ObjectDatabaseMock: ObjectDatabase {
    
    func add<T : Storeable>(object: T) -> Result<Void> {
        return .Success()
    }
    
    func add<T : Storeable>(objects: [T]) -> Result<Void> {
        return .Success()
    }
    
    
    func get<T : Storeable>(type: T.Type) -> Query<T, [T]> {
        return Query() { query in
            return .Success([])
        }
    }
    
    func get<T : Storeable>(type: T.Type) -> Result<[T]> {
        return .Success([])
    }
    
    func get<T : Storeable>(query: Query<T, [T]>) -> Result<[T]> {
        return .Success([])
    }
    
    
    func delete<T : Storeable>(query: Query<T, Void>) -> Result<Void> {
        return .Success()
    }
    
    func delete<T : Storeable>(objects: [T]) -> Result<Void> {
        return .Success()
    }
    
    func delete<T : Storeable>(object: T) -> Result<Void> {
        return .Success()
    }
    
    func delete<T : Storeable>(type: T.Type) -> Result<Void> {
        return .Success()
    }
    
    func delete<T : Storeable>(type: T.Type) -> Query<T, Void> {
        return Query() { query in
            return .Success()
        }
    }
    
    
}