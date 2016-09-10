//
//  IndexingUtils.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 05/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

struct IndexingUtils {
    static func nameForIndex(index: _IndexInstanceType) -> String {
        let type = String(index.type)
        let properties = index.properties.joinWithSeparator("")
        let filters = String(index.filters)
        
        return "\(type):\(properties):\(filters)"
    }
    
    static func indexForType(type: Storeable.Type) -> _IndexType? {
        if let indexableType = type as? Indexable.Type {
            let index = Index(type: type)
            
            indexableType.index(index)
            
            return index
        }
        
        return nil
    }
    
    static func indexNamesForType(type: Storeable.Type) -> Set<String> {
        if let index = indexForType(type) {
            return Set( index.indices.asType(_IndexInstanceType).map(IndexingUtils.nameForIndex) )
        }
        
        return []
    }
    
    static func typeInformationForType(type: Storeable.Type, version: Int = 0) -> TypeInformation {
        let name        = String(type)
        let identifier  = type.identifier()
        let indices     = indexNamesForType(type)
    
        return TypeInformation(name: name, properties: [:], version: version, identifierName: identifier, indices: indices)
    }
}