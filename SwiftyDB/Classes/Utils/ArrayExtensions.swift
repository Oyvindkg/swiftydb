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

extension Collection {
    
    func asType<T>(_ type: T.Type) -> [T?] {
        return self.map { $0 as? T }
    }
    
    func asType<T>(_ type: T.Type) -> [T] {
        return self.map { $0 as! T }
    }
    
    func matchType<T>() -> [T] {
        return self.map { $0 as! T }
    }
    
    func matchType<T>() -> [T?] {
        return self.map { $0 as? T }
    }

    var elementType: Iterator.Element.Type {
        return Iterator.Element.self
    }
    
    func groupBy<T: Hashable>(_ keyBlock: (Iterator.Element) -> T) -> [T: [Iterator.Element]] {
        var grouped: [T: [Iterator.Element]] = [:]
        
        let keys = Set(self.map(keyBlock))
        
        for key in keys {
            grouped[key] = self.filter { keyBlock($0) == key }
        }
        
        return grouped
    }
}
