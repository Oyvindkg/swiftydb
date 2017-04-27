//
//  Array+Mapping.swift
//  ORM
//
//  Created by Øyvind Grimnes on 17/08/16.
//  Copyright © 2016 Øyvind Grimnes. All rights reserved.
//

import Foundation

extension Array {
    
    func mapping<Key: Hashable, Value>(_ block: (Index, Element) -> (Key, Value?)) -> [Key: Value?] {
        var mapping: [Key: Value?] = [:]
        
        for (index, element) in self.enumerated() {
            let (key, value) = block(index, element)
            mapping[key] = value
        }
        
        return mapping
    }
}

extension Dictionary {
    func map<NewKey, NewValue>(mapping: (Key, Value) -> (NewKey, NewValue)) -> [NewKey: NewValue] {
        var dictionary: [NewKey: NewValue] = [:]
        
        for (key, value) in self {
            let (newKey, newValue) = mapping(key, value)
            
            dictionary[newKey] = newValue
        }
        
        return dictionary
    }
}

extension Collection {
    
    func group<T: Hashable>(by block: (Iterator.Element) -> T) -> [T: [Iterator.Element]] {
        var grouped: [T: [Iterator.Element]] = [:]
        
        let keys = Set(map(block))
        
        for key in keys {
            grouped[key] = filter { block($0) == key }
        }
        
        return grouped
    }
}
