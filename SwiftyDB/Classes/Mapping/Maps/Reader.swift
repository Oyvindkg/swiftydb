//
//  Reader.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 22/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

final class Reader: Mapper {
    
    let type: Mappable.Type
    var currentKey: String?
    
    var storableValues: [String: StorableValue]         = [:]
    var storableValueArrays: [String: [StorableValue?]] = [:]
    
    var mappables: [String: Reader]        = [:]
    var mappableArrays: [String: [Reader]] = [:]
    
    init(type: Mappable.Type) {
        self.type = type
    }
    
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
        
        mappableArrays[key] = readers
        propertyTypes[key]  = [T].self
    }

    subscript(key: String) -> Reader {
        currentKey = key
        
        return self
    }
}
