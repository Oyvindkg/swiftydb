//
//  Database.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 21/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation


internal protocol ObjectDatabase {
    func add<T: Storeable>(object: T, resultHandler: (Result<Void> -> Void)?)
    func add<T: Storeable>(objects: [T], resultHandler: (Result<Void> -> Void)?)
    
    func get<T : Storeable>(type: T.Type) -> GetQuery<T>
    func get<T: Storeable>(type: T.Type, resultHandler: (Result<[T]> -> Void)?)
    func get<T: Storeable>(query: Query<T>, resultHandler: (Result<[T]> -> Void)?)
    
    func delete<T: Storeable>(type: T.Type, resultHandler: (Result<Void> -> Void)?)
    func delete<T: Storeable>(query: Query<T>, resultHandler: (Result<Void> -> Void)?)
}
