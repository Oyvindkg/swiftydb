//
//  IndexingUtils.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 05/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

struct IndexingUtils {
    
    static func name(of index: Index) -> String {
        let filters    = String(describing: index.filter)
        let properties = index.properties.joined(separator: "")
        
        let invalidName = "\(index.type.name):\(properties):\(filters)"
        
        return invalidName.components(separatedBy: CharacterSet.alphanumerics.inverted).joined()
    }
    
    static func indexer(for type: Storable.Type) -> Indexer? {
        if let indexableType = type as? Indexable.Type {
            let indexer = DefaultIndexer(type: type)
            
            indexableType.index(using: indexer)
            
            return indexer
        }
        
        return nil
    }
    
    static func indexNames(for type: Storable.Type) -> Set<String> {
        if let indexer = self.indexer(for: type) {
            var indexNames: Set<String> = []
            
            for indexInstance in indexer.indices {
                let indexName = name(of: indexInstance)
                
                indexNames.insert(indexName)
            }
            
            return indexNames
        }
        
        return []
    }
    
//    static func information(for type: Storable.Type, version: UInt = 0) -> TypeInformation {
//        let name        = String(describing: type)
//        let identifier  = type.identifier()
//        let indexNames  = self.indexNames(for: type)
//    
//        return TypeInformation(name: name,
//                               properties: [:],
//                               version: version,
//                               identifierName: identifier,
//                               indices: indexNames)
//    }
}
