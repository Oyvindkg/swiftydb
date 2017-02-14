//
//  StorableUUID.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 13/02/17.
//  Copyright © 2017 Øyvind Grimnes. All rights reserved.
//

import Foundation


extension UUID: StorableProperty {
    public typealias StorableValueType = String
    
    
    public var storableValue: StorableValueType {
        return uuidString
    }
    
    public static func from(storableValue: StorableValueType) -> UUID {
        return UUID(uuidString: storableValue)!
    }
}
