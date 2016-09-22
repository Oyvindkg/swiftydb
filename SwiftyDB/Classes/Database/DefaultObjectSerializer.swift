//
//  ObjectSerializer.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 08/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

struct DefaultObjectSerializer: ObjectSerializer {
    
    static func readersFor<T: Storable>(storable: T?) -> [Reader] {
        guard storable != nil else {
            return []
        }
        
        let reader = Mapper.readerForObject(storable!)
        
        return readersForReader(reader)
    }
        
    /** Extracts nested readers, and prepares new readers to store collections */
    fileprivate static func readersForReader(_ reader: Reader) -> [Reader] {
        var readers = [reader]
        
        readers.append( contentsOf: extractNestedReadersFromReader(reader) )
        
        return readers
    }
    
    fileprivate static func extractNestedReadersFromReader(_ reader: Reader) -> [Reader] {
        var readers: [Reader] = []
        
        for (_, childReader) in reader.mappables {
            readers.append( contentsOf: readersForReader(childReader as! Reader) )
        }
        
        for (_, childMaps) in reader.mappableArrays {
            let childReaders: [Reader] = childMaps.matchType()
            
            for (_, childReader) in childReaders.enumerated() {
                readers.append( contentsOf: readersForReader(childReader) )
            }
        }
        
        return readers
    }
}
