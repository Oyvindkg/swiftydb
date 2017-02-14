//
//  Double.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 20/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

extension Double: StorableProperty {
    
    public typealias StorableValueType = Double
    
    public var storableValue: StorableValueType {
        return self
    }
    
    public static func from(storableValue: StorableValueType) -> Double {
        return storableValue
    }
}