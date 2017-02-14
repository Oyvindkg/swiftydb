//
//  Mapper.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 21/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

/** A struct responsible for populating `Reader`s with `Storable` object data, and populating `Storable`s with `Writer` data.
 */
struct Mapper {
    
    /** 
    Get an object populated with data from the provided `Writer`
    */
    static func object<T: Mappable>(for writer: Writer) -> T {
        var object = T.mappableObject() as! T

        object.mapping(map: writer)

        return object
    }
    
    /** 
    Get objects populated with data from the provided `Writer`s
    */
    static func objects<T: Mappable>(forWriters writers: [Writer]) -> [T] {
        return writers.map { writer in
            return object(for: writer)
        }
    }
    
    /**
    Get a `Reader` populated with data from the provided object
    */
    static func reader<T: Mappable>(for object: T) -> Reader {
        let reader = Reader(type: T.self)
        
        var readableObject = object
        
        readableObject.mapping(map: reader)
        
        return reader
    }
    
    /**
    Get `Reader`s populated with data from the provided objects
    */
    static func readers<T: Mappable>(forObjects objects: [T]) -> [Reader] {
        return objects.map { object in
            return self.reader(for: object)
        }
    }
    
    /**
    Get a `Reader` populated with the default values of the provided type
    */
    static func reader(for type: Mappable.Type) -> Reader {
        let reader = Reader(type: type)
        
        var readableObject = type.mappableObject()
        
        readableObject.mapping(map: reader)
        
        return reader
    }
}
