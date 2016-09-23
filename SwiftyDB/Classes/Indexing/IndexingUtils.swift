//
//  IndexingUtils.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 05/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

struct IndexingUtils {
    static func nameFor(index: _IndexInstance) -> String {
        let type       = String(describing: index.type)
        let filters    = String(describing: index.filters)
        let properties = index.properties.joined(separator: "")
        
        return "\(type):\(properties):\(filters)"
    }
    
    static func indexFor(type: Storable.Type) -> _Index? {
        if let indexableType = type as? Indexable.Type {
            let index = DefaultIndex(type: type)
            
            indexableType.index(index: index)
            
            return index
        }
        
        return nil
    }
    
    static func indexNamesFor(type: Storable.Type) -> Set<String> {
        if let index = indexFor(type: type) {
            return Set( index.indices.to(type: _IndexInstance.self).map(IndexingUtils.nameFor) )
        }
        
        return []
    }
    
    static func typeInformationFor(type: Storable.Type, version: Int = 0) -> TypeInformation {
        let name        = String(describing: type)
        let identifier  = type.identifier()
        let indices     = indexNamesFor(type: type)
    
        return TypeInformation(name: name, properties: [:], version: version, identifierName: identifier, indices: indices)
    }
}
