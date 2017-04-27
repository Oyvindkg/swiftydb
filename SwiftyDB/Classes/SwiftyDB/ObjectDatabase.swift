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
public protocol ObjectDatabase {
    
    /**
     Add objects to the database
     
     - parameters:
        - objects:          the objects to be added
        - resultHandler:    an optional result handler
     */
    func add<T: Storable>(objects: [T]) -> Promise<Void>
    
    /**
    Get objects for the provided type
     
    - parameters:
        - type:             type of the objects to be retrieved
    */
    func get<T: Storable>(_ type: T.Type) -> Promise<[T]>
    
    /**
    Get objects for the provided type
     
    - parameters:
        - query:            query to be executed
    */
    func get<Query>(using query: Query) -> Promise<[Query.Subject]> where Query : StorableQuery
    
    /**
    Delete objects for the provided type
     
    - parameters:
        - type:             type of the objects to be deleted
    */
    func delete(using query: AnyQuery) -> Promise<Void>
}

extension ObjectDatabase {
    
    /**
    Add an object to the database
     
    - parameters:
        - object:           the object to be added
    */
    public func add<T: Storable>(_ object: T) -> Promise<Void> {
        return add(objects: [object])
    }
    
    /**
    Add an object to the database
     
    - parameters:
        - object:           the object to be added
    */
    public func add<T: Storable>(_ objects: T...) -> Promise<Void> {
        return add(objects: objects)
    }
    

    /**
    Get objects for the provided type
     
    - parameters:
        - type:             type of the objects to be retrieved
    */
    public func get<T>(_ type: T.Type) -> Promise<[T]> where T : Storable {
        let query = Query<T>()
        
        return get(using: query)
    }
    
    /**
    Create a DeleteQuery for the provided type
     
    - returns: A `DeleteQuery` object that can be used to filter objects to delete
     
    - parameters:
        - type: type of the objects to be deleted
    */
    public func delete<T>(_ type: T.Type) -> Promise<Void> where T : Storable {
        let query = Query<T>()
        
        return delete(using: query)
    }
}
