//
//  Indexer.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 05/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation



class Indexer: IndexerType {
    
    var validTypes: Set<String> = []
    
    /** Creates indices for the provided type, and its nested types */
    func indexTypeIfNecessary(type: Storeable.Type, inSwifty swifty: Swifty) throws {
        let typeName = String(type)
        
        guard !validTypes.contains(typeName) else {
            return
        }
        
        for (_, childType) in Mapper.readerForType(type).types {
            guard let storeableChildType = childType as? Storeable.Type else {
                continue
            }
            
            try indexTypeIfNecessary(storeableChildType, inSwifty: swifty)
        }
        
        try indexThisTypeIfNecessary(type, inSwifty: swifty)
        
        validTypes.insert(typeName)
    }
    
    /** Creates indices for the provided type */
    private func indexThisTypeIfNecessary(type: Storeable.Type, inSwifty swifty: Swifty) throws {
        guard type is Indexable.Type else {
            return
        }
        
        let query = Query<TypeInformation>().filter("name" == String(type))
        
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
            try swifty.database.create(index)
        }
        
        
        typeInformation.indices = IndexingUtils.indexNamesForType(type)
        
        swifty.addSync([typeInformation])
    }
    
}