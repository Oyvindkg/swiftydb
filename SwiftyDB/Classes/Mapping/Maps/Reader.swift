//
//  Reader.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 22/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

class Reader: BaseMap {
    
    var types: [String: Any.Type] = [:]
    
    func setCurrentValue<T: StorableValue>(_ value: T?, forType type: Any.Type = T.self) {
        guard let key = currentKey else {
            return
        }

        storableValues[key] = value
        types[key] = type
    }
    
    func setCurrentValue<T: StorableValue>(_ value: [T]?, forType type: Any.Type = T.self) {
        guard let key = currentKey else {
            return
        }
        
        storableValueArrays[key] = value?.map { $0 }
        types[key] = [T].self
    }
    
    func setCurrentValue<T: Mappable>(_ value: Reader?, forType type: T.Type) {
        guard let key = currentKey else {
            return
        }
        
        mappables[key] = value
        types[key] = T.self
    }
    
    func setCurrentValue<T: Mappable>(_ value: [Reader]?, forType type: T.Type) {
        guard let key = currentKey else {
            return
        }
        
        mappableArrays[key] = value?.to(type: Map.self)
        types[key] = [T].self
    }
}

extension Reader: Map {
    subscript(key: String) -> Map {
        currentKey = key
        
        return self
    }
}
