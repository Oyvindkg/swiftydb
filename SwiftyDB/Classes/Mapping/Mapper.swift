//
//  Mapper.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 21/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

struct Mapper {
    
    static func objectFor<T: Mappable>(writer: Writer) -> T {
        var object = T.mappableObject() as! T

        object.mapping(map: writer)

        return object
    }
    
    static func objectsFor<T: Mappable>(writers: [Writer]) -> [T] {
        return writers.map(objectFor)
    }
    
    
    static func readerFor<T: Mappable>(object: T) -> Reader {
        var readableObject = object
        
        let reader = Reader(type: T.self)
        
        readableObject.mapping(map: reader)
        
        return reader
    }
    
    static func readersFor<T: Mappable>(objects: [T]) -> [Reader] {
        return objects.map(readerFor)
    }
    
    static func readerFor(type: Mappable.Type) -> Reader {
        var readableObject = type.mappableObject()
        
        let reader = Reader(type: type)
        
        readableObject.mapping(map: reader)
        
        return reader
    }
}
