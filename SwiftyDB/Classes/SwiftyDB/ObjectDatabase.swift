//
//  Database.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 21/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation


//internal protocol ObjectDatabase {
//    func add<T: Storeable>(object: T) -> Result<Void>
//    func add<T: Storeable>(objects: [T]) -> Result<Void>
//    
//    func get<T: Storeable>(type: T.Type) -> Query<T, [T]>
//    func get<T: Storeable>(query: Query<T, [T]>) -> Result<[T]>
//    func get<T: Storeable>(type: T.Type) -> Result<[T]>
//    
//    func delete<T: Storeable>(type: T.Type) -> Query<T, Void>
//    func delete<T: Storeable>(type: T.Type) -> Result<Void>
//    func delete<T: Storeable>(query: Query<T, Void>) -> Result<Void>
//}