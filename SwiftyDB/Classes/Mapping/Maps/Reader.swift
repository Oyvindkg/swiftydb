//
//  Reader.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 22/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

final class Reader: BaseMap, Map {
    
    /** The original property type for all values stored in the reader */
    var propertyTypes: [String: Any.Type] = [:]
    
    func setCurrent<T: StorableValue>(value: T?, forType type: Any.Type = T.self) {
        guard let key = currentKey else {
            return
        }

        storableValues[key] = value
        propertyTypes[key]  = type
    }
    
    func setCurrent<T: StorableValue>(values: [T]?, forType type: Any.Type = T.self) {
        guard let key = currentKey else {
            return
        }
        
        storableValueArrays[key] = values?.map { $0 }
        propertyTypes[key]       = [T].self
    }
    
    func setCurrent<T: Mappable>(reader: Reader?, forType type: T.Type) {
        guard let key = currentKey else {
            return
        }
        
        mappables[key]     = reader
        propertyTypes[key] = T.self
    }
    
    func setCurrent<T: Mappable>(readers: [Reader]?, forType type: T.Type) {
        guard let key = currentKey else {
            return
        }
        
        mappableArrays[key] = readers?.to(type: Map.self)
        propertyTypes[key]  = [T].self
    }

    subscript(key: String) -> Map {
        currentKey = key
        
        return self
    }
}
