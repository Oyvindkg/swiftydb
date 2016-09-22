//
//  IndexingUtils.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 05/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

struct IndexingUtils {
    static func nameForIndex(_ index: _IndexInstanceType) -> String {
        let type = String(describing: index.type)
        let properties = index.properties.joined(separator: "")
        let filters = String(describing: index.filters)
        
        return "\(type):\(properties):\(filters)"
    }
    
    static func indexForType(_ type: Storable.Type) -> _IndexType? {
        if let indexableType = type as? Indexable.Type {
            let index = Index(type: type)
            
            indexableType.index(index)
            
            return index
        }
        
        return nil
    }
    
    static func indexNamesForType(_ type: Storable.Type) -> Set<String> {
        if let index = indexForType(type) {
            return Set( index.indices.asType(_IndexInstanceType).map(IndexingUtils.nameForIndex) )
        }
        
        return []
    }
    
    static func typeInformationForType(_ type: Storable.Type, version: Int = 0) -> TypeInformation {
        let name        = String(describing: type)
        let identifier  = type.identifier()
        let indices     = indexNamesForType(type)
    
        return TypeInformation(name: name, properties: [:], version: version, identifierName: identifier, indices: indices)
    }
}
