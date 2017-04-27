//
//  IndexingUtils.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 05/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

struct IndexingUtilities {

    static func name(of index: AnyIndex, for type: Storable.Type) -> String {
        
        let filters    = String(describing: index.filter)
        let properties = index.properties.sorted().joined(separator: "")
        
        let invalidName = "\(type.name):\(properties):\(filters)"
        
        return invalidName.components(separatedBy: CharacterSet.alphanumerics.inverted).joined()
    }
    
    static func indexNames(for type: Storable.Type) -> Set<String> {
        guard let indexableType = type as? Indexable.Type else {
            return []
        }
        
        var indexNames: Set<String> = []
        
        for index in indexableType.indices() {
            let indexName = name(of: index, for: type)
            
            indexNames.insert(indexName)
        }
        
        return indexNames
    }
}
