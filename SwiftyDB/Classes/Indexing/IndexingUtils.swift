//
//  IndexingUtils.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 05/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

struct IndexingUtils {
    
    static func name(of index: _IndexInstance) -> String {
        let type       = String(describing: index.type)
        let filters    = String(describing: index.filters)
        let properties = index.properties.joined(separator: "")
        
        return "\(type):\(properties):\(filters)"
    }
    
    static func index(for type: Storable.Type) -> _Index? {
        if let indexableType = type as? Indexable.Type {
            let index = DefaultIndex(type: type)
            
            indexableType.index(index: index)
            
            return index
        }
        
        return nil
    }
    
    static func indexNames(for type: Storable.Type) -> Set<String> {
        if let index = self.index(for: type) {
            var indexNames: Set<String> = []
            
            for indexInstance in index.indices {
                let indexName = name(of: indexInstance)
                
                indexNames.insert(indexName)
            }
            
            return indexNames
        }
        
        return []
    }
    
    static func information(for type: Storable.Type, version: UInt = 0) -> TypeInformation {
        let name        = String(describing: type)
        let identifier  = type.identifier()
        let indexNames  = self.indexNames(for: type)
    
        return TypeInformation(name: name,
                               properties: [:],
                               version: version,
                               identifierName: identifier,
                               indices: indexNames)
    }
}
