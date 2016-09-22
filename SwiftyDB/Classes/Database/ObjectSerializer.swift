//
//  ObjectSerializer.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 08/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

struct ObjectSerializer: ObjectSerializerType {
    
    static func readersForStorable<T: Storable>(storable: T?) -> [Reader] {
        guard storable != nil else {
            return []
        }
        
        let reader = Mapper.readerForObject(storable!)
        
        return readersForReader(reader)
    }
        
    /** Extracts nested readers, and prepares new readers to store collections */
    private static func readersForReader(reader: Reader) -> [Reader] {
        var readers = [reader]
        
        readers.appendContentsOf( extractNestedReadersFromReader(reader) )
        
        return readers
    }
    
    private static func extractNestedReadersFromReader(reader: Reader) -> [Reader] {
        var readers: [Reader] = []
        
        for (_, childReader) in reader.mappables {
            readers.appendContentsOf( readersForReader(childReader as! Reader) )
        }
        
        for (_, childMaps) in reader.mappableArrays {
            let childReaders: [Reader] = childMaps.matchType()
            
            for (_, childReader) in childReaders.enumerate() {
                readers.appendContentsOf( readersForReader(childReader) )
            }
        }
        
        return readers
    }
}
