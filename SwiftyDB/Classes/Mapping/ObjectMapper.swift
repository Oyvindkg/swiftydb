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
struct ObjectMapper {
    
    /** 
    Get an object populated with data from the provided `Writer`
    */
    static func object<T: Mappable>(for writer: inout Writer) -> T {
        var object = T.mappableObject() as! T

        object.map(using: &writer)

        return object
    }
    
    /** 
    Get objects populated with data from the provided `Writer`s
    */
    static func objects<T: Mappable>(forWriters writers: [Writer]) -> [T] {
        return writers.map { writer in
            var mutableWriter = writer
            
            return object(for: &mutableWriter)
        }
    }
    
    /**
    Get a `Reader` populated with data from the provided object
    */
    static func read<T: Mappable>(_ object: T) -> Reader {
        var reader = Reader(type: T.self)
        
        var readableObject = object
        
        readableObject.map(using: &reader)
        
        return reader
    }
    
    /**
    Get `Reader`s populated with data from the provided objects
    */
    static func read<T: Mappable>(objects: [T]) -> [Reader] {
        return objects.map { object in
            return self.read(object)
        }
    }
    
    /**
    Get a `Reader` populated with the default values of the provided type
    */
    static func read(type: Mappable.Type) -> Reader {
        var reader = Reader(type: type)
        
        var readableObject = type.mappableObject() as! Mappable

        readableObject.map(using: &reader)
        
        return reader
    }
}
