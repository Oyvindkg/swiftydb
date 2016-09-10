//
//  Map+Storeable.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 08/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

extension BaseMap {
    var storeableType: Storeable.Type {
        return type as! Storeable.Type
    }
    
    var identifierValue: StoreableValue {
        let identifier = storeableType.identifier()
        return storeableValues[identifier]!
    }
}