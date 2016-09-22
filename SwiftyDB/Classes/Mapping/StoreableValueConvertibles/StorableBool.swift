//
//  Bool.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 20/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

extension Bool: StorableProperty {
    public typealias StorableValueType = Int64
    
    public var storableValue: StorableValueType {
        return Int64(self ? 1 : 0)
    }
    
    public static func fromStorableValue(_ storableValue: StorableValueType) -> Bool {
        return storableValue > 0
    }
}
