//
//  StorableNSNumber.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 20/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

extension NSNumber: StorableValueConvertible {
    
    public typealias StorableValueType = Double
    
    public var storableValue: StorableValueType {
        return self.doubleValue
    }
    
    public static func fromStorableValue(storableValue: StorableValueType) -> Self {
        return fromStorableValueHelper(storableValue)
    }
    
    private static func fromStorableValueHelper<T: NSNumber>(storableValue: StorableValueType) -> T {
        return T.init(double: storableValue)
    }
}
