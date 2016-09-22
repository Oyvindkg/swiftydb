//
//  StorableNSNumber.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 20/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

extension NSNumber: StorableProperty {
    
    public typealias StorableValueType = Double
    
    public var storableValue: StorableValueType {
        return self.doubleValue
    }
    
    public static func from(storableValue: StorableValueType) -> Self {
        return fromHelper(storableValue: storableValue)
    }
    
    fileprivate static func fromHelper<T: NSNumber>(storableValue: StorableValueType) -> T {
        return T.init(value: storableValue)
    }
}
