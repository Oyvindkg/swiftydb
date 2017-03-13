//
//  MockDatabase.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 29/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import Result

@testable import SwiftyDB

struct ObjectDatabaseMock: ObjectDatabase {
    
    func add<T : Storable>(_ object: T, resultHandler: ((Result<Void, SwiftyError>) -> Void)?) {
        add([object], resultHandler: resultHandler)
    }
    
    func add<T : Storable>(_ objects: [T], resultHandler: ((Result<Void, SwiftyError>) -> Void)?) {
        resultHandler?(.success())
    }
    

    func get<T : Storable>(with query: Query<T>, resultHandler: ((Result<[T], SwiftyError>) -> Void)?) {
        resultHandler?(.success([]))
    }

    func get<T : Storable>(_ type: T.Type) -> GetQuery<T> {
        return GetQuery(database: self)
    }
    
    func get<T : Storable>(_ type: T.Type, resultHandler: ((Result<[T], SwiftyError>) -> Void)?) {
        let query = Query<T>()
        
        get(with: query, resultHandler: resultHandler)
    }
    
    func delete<T : Storable>(_ type: T.Type, resultHandler: ((Result<Void, SwiftyError>) -> Void)?) {
        let query = Query<T>()
        
        delete(with: query, resultHandler: resultHandler)
    }
    
    func delete<T : Storable>(with query: Query<T>, resultHandler: ((Result<Void, SwiftyError>) -> Void)?) {
        resultHandler?(.success())
    }
    
}
