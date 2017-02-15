//
//  Indexer.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 05/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation


//TODO: Maybe this could be limited to accepting only Indexable types?

class DefaultTypeIndexer: TypeIndexer {
    
    var validTypes: Set<String> = []
    
    
    /** Creates indices for the provided type, and its nested types */
    func indexTypeIfNecessary(_ type: Storable.Type, in swifty: Swifty) throws {
        
        guard !validTypes.contains("\(type)") else {
            return
        }
        
        for (_, childType) in Mapper.reader(for: type).propertyTypes {
            guard let storableChildType = childType as? Storable.Type else {
                continue
            }
            
            try indexTypeIfNecessary(storableChildType, in: swifty)
        }
        
        try indexTypeNonrecursiveIfNecessary(type, in: swifty)
        
        /* The type is successfully indexed. Cache the type to avoid unnecessary processing */
        validTypes.insert("\(type)")
    }
    
    /** Creates indices for the provided type */
    fileprivate func indexTypeNonrecursiveIfNecessary(_ type: Storable.Type, in swifty: Swifty) throws {
        
        guard type is Indexable.Type else {
            return
        }
        
        let storedTypeInformation  = retrieveTypeInformation(for: type, from: swifty)
        let currentTypeInformation = IndexingUtils.information(for: type)
        
        /* Dont update indices if the current database indices matches the types defined indices */
        guard storedTypeInformation?.indices != currentTypeInformation.indices else {
            return
        }
        
        /* Create indices for type if any */
        if let indexer = IndexingUtils.indexer(for: type) {
            try swifty.database.createIndex(from: indexer)
        }
        
        /* Store the current type information */
        _ = swifty.addSync([currentTypeInformation])
    }
    
    fileprivate func retrieveTypeInformation(for type: Storable.Type, from swifty: Swifty) -> TypeInformation? {
        let query = Query<TypeInformation>().filter("name" == "\(type)")
        
        let result = swifty.getSync(query)
        
        switch result {
        case .success(let typeInformation):
            return typeInformation.first
        default:
            return nil
        }
    }
}
