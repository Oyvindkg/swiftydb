//
//  IndexingUtils.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 05/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

struct IndexingUtils {
    static func nameForIndex(_ index: _IndexInstance) -> String {
        let type       = String(describing: index.type)
        let filters    = String(describing: index.filters)
        let properties = index.properties.joined(separator: "")
        
        return "\(type):\(properties):\(filters)"
    }
    
    static func indexForType(_ type: Storable.Type) -> _Index? {
        if let indexableType = type as? Indexable.Type {
            let index = DefaultIndex(type: type)
            
            indexableType.index(index: index)
            
            return index
        }
        
        return nil
    }
    
    static func indexNamesForType(_ type: Storable.Type) -> Set<String> {
        if let index = indexForType(type) {
            return Set( index.indices.to(type: _IndexInstance.self).map(IndexingUtils.nameForIndex) )
        }
        
        return []
    }
    
    static func informationForType(_ type: Storable.Type, version: UInt = 0) -> TypeInformation {
        let name        = String(describing: type)
        let identifier  = type.identifier()
        let indices     = indexNamesForType(type)
    
        return TypeInformation(name: name, properties: [:], version: version, identifierName: identifier, indices: indices)
    }
}
