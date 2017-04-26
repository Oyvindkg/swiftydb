//
//  Map+Storable.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 08/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

extension Reader {
    var storableType: Storable.Type {
        return type as! Storable.Type
    }
    
    var identifierValue: StorableValue {
        let identifier = storableType.identifier()
        
        return storableValues[identifier]!
    }
}

extension Writer {
    var storableType: Storable.Type {
        return type as! Storable.Type
    }
    
    var identifierValue: StorableValue {
        let identifier = storableType.identifier()
        
        return storableValues[identifier]!
    }
}
