//
//  ObjectSerializer.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 08/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

struct DefaultObjectSerializer: ObjectSerializer {
    
    static func readers<T: Storable>(for storable: T?) -> [Reader] {
        guard storable != nil else {
            return []
        }
        
        let reader = ObjectMapper.read(storable!)
        
        return readers(forReader: reader)
    }
        
    /** Extracts nested readers, and prepares new readers to store collections */
    fileprivate static func readers(forReader reader: Reader) -> [Reader] {
        var readers = [reader]
        
        readers.append( contentsOf: extractNestedReaders(from: reader) )
        
        return readers
    }
    
    fileprivate static func extractNestedReaders(from reader: Reader) -> [Reader] {
        var readers: [Reader] = []
        
        for (_, childReader) in reader.mappables {
            readers.append( contentsOf: self.readers(forReader: childReader) )
        }
        
        for (_, childMaps) in reader.mappableArrays {
            let childReaders: [Reader] = childMaps.matchType()
            
            for (_, childReader) in childReaders.enumerated() {
                readers.append( contentsOf: self.readers(forReader: childReader) )
            }
        }
        
        return readers
    }
}
