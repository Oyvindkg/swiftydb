//
//  Mapper.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 21/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

struct Mapper {
    
    static func objectForWriter<T: Mappable>(_ writer: Writer) -> T {
        var object = T.mappableObject() as! T

        object.mapping(map: writer)

        return object
    }
    
    static func objectsForWriters<T: Mappable>(_ writers: [Writer]) -> [T] {
        return writers.map(objectForWriter)
    }
    
    
    static func readerForObject<T: Mappable>(_ object: T) -> Reader {
        var readableObject = object
        
        let reader = Reader(type: T.self)
        
        readableObject.mapping(map: reader)
        
        return reader
    }
    
    static func readersForObjects<T: Mappable>(_ objects: [T]) -> [Reader] {
        return objects.map(readerForObject)
    }
    
    static func readerForType(_ type: Mappable.Type) -> Reader {
        var readableObject = type.mappableObject()
        
        let reader = Reader(type: type)
        
        readableObject.mapping(map: reader)
        
        return reader
    }
}
