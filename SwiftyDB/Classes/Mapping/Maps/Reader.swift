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
    
    func setCurrentValue<T: StoreableValue>(value: T?, forType type: Any.Type = T.self) {
        guard let key = currentKey else {
            return
        }

        storeableValues[key] = value
        types[key] = type
    }
    
    func setCurrentValue<T: StoreableValue>(value: [T]?, forType type: Any.Type = T.self) {
        guard let key = currentKey else {
            return
        }
        
        storeableValueArrays[key] = value?.map { $0 }
        types[key] = [T].self
    }
    
    func setCurrentValue<T: Mappable>(value: Reader?, forType type: T.Type) {
        guard let key = currentKey else {
            return
        }
        
        mappables[key] = value
        types[key] = T.self
    }
    
    func setCurrentValue<T: Mappable>(value: [Reader]?, forType type: T.Type) {
        guard let key = currentKey else {
            return
        }
        
        mappableArrays[key] = value?.map { $0 as MapType }
        types[key] = [T].self
    }
}

extension Reader: MapType {
    subscript(key: String) -> MapType {
        currentKey = key
        
        return self
    }
}