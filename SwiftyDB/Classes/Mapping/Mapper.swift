//
//  Mapper.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 21/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

struct Mapper {
    
    static func objectForWriter<T: Mappable>(writer: Writer) -> T {
        var object = T.mappableObject() as! T

        object.mapping(writer)

        return object
    }
    
    static func objectsForWriters<T: Mappable>(writers: [Writer]) -> [T] {
        return writers.map(objectForWriter)
    }
    
    
    static func readerForObject<T: Mappable>(object: T) -> Reader {
        var readableObject = object
        
        let reader = Reader(type: T.self)
        
        readableObject.mapping(reader)
        
        return reader
    }
    
    static func readersForObjects<T: Mappable>(objects: [T]) -> [Reader] {
        return objects.map(readerForObject)
    }
    
    static func readerForType(type: Mappable.Type) -> Reader {
        var readableObject = type.mappableObject()
        
        let reader = Reader(type: type)
        
        readableObject.mapping(reader)
        
        return reader
    }
}
