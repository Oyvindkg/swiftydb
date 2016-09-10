//
//  Array+Mapping.swift
//  ORM
//
//  Created by Øyvind Grimnes on 17/08/16.
//  Copyright © 2016 Øyvind Grimnes. All rights reserved.
//

import Foundation

extension Array {
    
    func mapping<Key: Hashable, Value>(block: (Index, Element) -> (Key, Value?)) -> [Key: Value?] {
        var mapping: [Key: Value?] = [:]
        
        for (index, element) in self.enumerate() {
            let (key, value) = block(index, element)
            mapping[key] = value
        }
        
        return mapping
    }
    
    func asType<T>(type: T.Type) -> [T?] {
        return self.map { $0 as? T }
    }
    
    func asType<T>(type: T.Type) -> [T] {
        return self.map { $0 as! T }
    }
    
    func matchType<T>() -> [T] {
        return self.map { $0 as! T }
    }
    
    func matchType<T>() -> [T?] {
        return self.map { $0 as? T }
    }
}