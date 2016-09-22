//
//  StorableFloat.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 20/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

extension Float: StorableProperty {

    public typealias StorableValueType = Double
    
    public var storableValue: StorableValueType {
        return Double(self)
    }
    
    public static func from(storableValue: StorableValueType) -> Float {
        return Float(storableValue)
    }
}
