//
//  Bool.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 20/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

extension Bool: StoreableValueConvertible {
    public typealias StoreableValueType = Int64
    
    public var storeableValue: StoreableValueType {
        return Int64(self ? 1 : 0)
    }
    
    public static func fromStoreableValue(storeableValue: StoreableValueType) -> Bool {
        return storeableValue > 0
    }
}