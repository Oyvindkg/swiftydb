//
//  Database.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 21/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import PromiseKit

/** An object database interface used to add, retrieve and delete objects from some persistent store */
internal protocol ObjectDatabase {
    
    /**
     Add an object to the database
     
     - parameters:
        - object:           the object to be added
        - resultHandler:    an optional result handler
     */
    func add<T: Storable>(_ object: T) -> Promise<Void>
    
    /**
     Add objects to the database
     
     - parameters:
        - objects:          the objects to be added
        - resultHandler:    an optional result handler
     */
    func add<T: Storable>(_ objects: [T]) -> Promise<Void>
    
    
    /**
     Create a GetQuery for the provided type
     
     - parameters:
        - type: type of the objects to be retrieved

     - returns: A `GetQuery` object that can be used to filter, sort and limit the results
     */
    func get<T : Storable>(_ type: T.Type) -> GetQuery<T>
    
    /**
     Get objects for the provided type
     
     - parameters:
        - type:             type of the objects to be retrieved
        - resultHandler:    an optional result handler
     */
    func get<T: Storable>(_ type: T.Type) -> Promise<[T]>
    
    /**
     Get objects for the provided type
     
     - parameters:
        - query:            query to be executed
        - resultHandler:    an optional result handler
     */
    func get<T: Storable>(with query: Query<T>) -> Promise<[T]>
    
    
    /**
     Create a DeleteQuery for the provided type
     
     - parameters:
        - type: type of the objects to be deleted
     
     - returns: A `DeleteQuery` object that can be used to filter objects to delete
     */
    func delete<T: Storable>(_ type: T.Type) -> Promise<Void>
    
    /**
     Delete objects for the provided type
     
     - parameters:
        - type:             type of the objects to be deleted
        - resultHandler:    an optional result handler
     */
    func delete<T: Storable>(with query: Query<T>) -> Promise<Void>
}
