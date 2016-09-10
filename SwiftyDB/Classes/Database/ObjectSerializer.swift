//
//  ObjectSerializer.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 08/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

struct ObjectSerializer: ObjectSerializerType {
    
    static func readersForStoreable<T: Storeable>(storeable: T?) -> [Reader] {
        guard storeable != nil else {
            return []
        }
        
        let reader = Mapper.readerForObject(storeable!)
        
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
        
        for (property, childReader) in reader.mappables {
            readers.appendContentsOf( readersForChildReader(childReader as! Reader, forProperty: property, inReader: reader) )
        }
        
        for (property, childMaps) in reader.mappableArrays {
            let childReaders: [Reader] = childMaps.matchType()
            
            for (index, childReader) in childReaders.enumerate() {
                readers.appendContentsOf( readersForChildReader(childReader, forProperty: property, inReader: reader, index: String(index)) )
            }
        }
        
        return readers
    }
    
    private static func readersForChildReader(childReader: Reader, forProperty property: String, inReader reader: Reader, index: String = "") -> [Reader] {
        let parentIdentifier = reader.storeableType.identifier()
        let parentType = String(reader.type)
        let parentID = String(reader.storeableValues[parentIdentifier]!)
        
        let childIdentifier = childReader.storeableType.identifier()
        let childType = String(childReader.type)
        let childID = String(childReader.storeableValues[childIdentifier]!)
        
        var readers: [Reader] = readersForReader(childReader)
        
        /* Create an object connecting the parent with the child mappable */
        let hasStoreable = HasStoreable(parentType: parentType, parentID: parentID, parentProperty: property, childType: childType, childID: childID, index: index)
        
        readers.append(Mapper.readerForObject(hasStoreable))
        
        return readers
    }
}