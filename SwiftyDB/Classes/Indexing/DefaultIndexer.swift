//
//  Indexer.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 05/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation



class DefaultIndexer: Indexer {
    
    var validTypes: Set<String> = []
    
    // TODO: Rename and clean these
    
    /** Creates indices for the provided type, and its nested types */
    func indexIfNecessary(type: Storable.Type, inSwifty swifty: Swifty) throws {
        let typeName = String(describing: type)
        
        guard !validTypes.contains(typeName) else {
            return
        }
        
        for (_, childType) in Mapper.readerForType(type).types {
            guard let storableChildType = childType as? Storable.Type else {
                continue
            }
            
            try indexIfNecessary(type: storableChildType, inSwifty: swifty)
        }
        
        try indexThisIfNecessary(type: type, inSwifty: swifty)
        
        validTypes.insert(typeName)
    }
    
    /** Creates indices for the provided type */
    fileprivate func indexThisIfNecessary(type: Storable.Type, inSwifty swifty: Swifty) throws {
        guard type is Indexable.Type else {
            return
        }
        
        let query = Query<TypeInformation>().filter("name" == String(describing: type))
        
        let result = swifty.getSync(query)
        
        var typeInformation: TypeInformation
        
        if let existingTypeInformation = result.value?.first {
            typeInformation = existingTypeInformation
        } else {
            typeInformation = IndexingUtils.typeInformationForType(type)
        }
        
        if typeInformation.indices == IndexingUtils.indexNamesForType(type) {
            return
        }
        
        if let index = IndexingUtils.indexForType(type) {
            try swifty.database.create(index: index)
        }
        
        
        typeInformation.indices = IndexingUtils.indexNamesForType(type)
        
        swifty.addSync([typeInformation])
    }
    
}
