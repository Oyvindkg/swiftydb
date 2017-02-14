//
//  Reader.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 22/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

final class Reader: BaseMap {
    
    var types: [String: Any.Type] = [:]
    
    func setCurrent<T: StorableValue>(value: T?, forType type: Any.Type = T.self) {
        guard let key = currentKey else {
            return
        }

        storableValues[key] = value
        types[key] = type
    }
    
    func setCurrent<T: StorableValue>(values: [T]?, forType type: Any.Type = T.self) {
        guard let key = currentKey else {
            return
        }
        
        storableValueArrays[key] = values?.map { $0 }
        types[key] = [T].self
    }
    
    func setCurrent<T: Mappable>(reader: Reader?, forType type: T.Type) {
        guard let key = currentKey else {
            return
        }
        
        mappables[key] = reader
        types[key] = T.self
    }
    
    func setCurrent<T: Mappable>(readers: [Reader]?, forType type: T.Type) {
        guard let key = currentKey else {
            return
        }
        
        mappableArrays[key] = readers?.to(type: Map.self)
        types[key] = [T].self
    }
}

extension Reader: Map {
    subscript(key: String) -> Map {
        currentKey = key
        
        return self
    }
}
