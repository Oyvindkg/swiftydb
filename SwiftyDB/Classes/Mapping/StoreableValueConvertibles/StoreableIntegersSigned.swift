//
//  Int.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 20/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

extension Int: StoreableValueConvertible {
    
    public typealias StoreableValueType = Int64
    
    public var storeableValue: StoreableValueType{
        return Int64(self)
    }
    
    public static func fromStoreableValue(storeableValue: StoreableValueType) -> Int {
        return Int(storeableValue)
    }
}

extension Int8: StoreableValueConvertible {
    
    public typealias StoreableValueType = Int64
    
    public var storeableValue: StoreableValueType{
        return Int64(self)
    }
    
    public static func fromStoreableValue(storeableValue: StoreableValueType) -> Int8 {
        return Int8(storeableValue)
    }
}

extension Int16: StoreableValueConvertible {
    
    public typealias StoreableValueType = Int64
    
    public var storeableValue: StoreableValueType{
        return Int64(self)
    }
    
    public static func fromStoreableValue(storeableValue: StoreableValueType) -> Int16 {
        return Int16(storeableValue)
    }
}

extension Int32: StoreableValueConvertible {
    
    public typealias StoreableValueType = Int64
    
    public var storeableValue: StoreableValueType {
        return Int64(self)
    }
    
    public static func fromStoreableValue(storeableValue: StoreableValueType) -> Int32 {
        return Int32(storeableValue)
    }
}

extension Int64: StoreableValueConvertible {
    
    public typealias StoreableValueType = Int64
    
    public var storeableValue: StoreableValueType{
        return self
    }
    
    public static func fromStoreableValue(storeableValue: StoreableValueType) -> Int64 {
        return storeableValue
    }
}
