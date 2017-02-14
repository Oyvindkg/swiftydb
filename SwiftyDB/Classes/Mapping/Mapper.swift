//
//  Mapper.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 21/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

struct Mapper {
    
    static func object<T: Mappable>(for writer: Writer) -> T {
        var object = T.mappableObject() as! T

        object.mapping(map: writer)

        return object
    }
    
    static func objects<T: Mappable>(forWriters writers: [Writer]) -> [T] {
        return writers.map { writer in
            return object(for: writer)
        }
    }
    
    
    static func reader<T: Mappable>(for object: T) -> Reader {
        var readableObject = object
        
        let reader = Reader(type: T.self)
        
        readableObject.mapping(map: reader)
        
        return reader
    }
    
    static func readers<T: Mappable>(forObjects objects: [T]) -> [Reader] {
        return objects.map { object in
            return self.reader(for: object)
        }
    }
    
    static func reader(for type: Mappable.Type) -> Reader {
        var readableObject = type.mappableObject()
        
        let reader = Reader(type: type)
        
        readableObject.mapping(map: reader)
        
        return reader
    }
}
