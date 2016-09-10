//
//  StoreableNSNumber.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 20/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

extension NSNumber: StoreableValueConvertible {
    
    public typealias StoreableValueType = Double
    
    public var storeableValue: StoreableValueType {
        return self.doubleValue
    }
    
    public static func fromStoreableValue(storeableValue: StoreableValueType) -> Self {
        return fromStoreableValueHelper(storeableValue)
    }
    
    private static func fromStoreableValueHelper<T: NSNumber>(storeableValue: StoreableValueType) -> T {
        return T.init(double: storeableValue)
    }
}