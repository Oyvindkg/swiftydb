//
//  StorableData.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 22/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation


extension Data: StorableProperty {
    
    public typealias StorableValueType = Data
    
    public var storableValue: StorableValueType {
        return self
    }
    
    public static func from(storableValue: StorableValueType) -> Data {
        return storableValue
    }
}
