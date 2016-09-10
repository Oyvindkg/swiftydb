//
//  StoreableUInts.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 20/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation


//TODO: Can SQLite store undigned 64-bit integers?

extension UInt: StoreableValueConvertible {
    
    public typealias StoreableValueType = Int64
    
    public var storeableValue: StoreableValueType {
        return Int64(self)
    }
    
    public static func fromStoreableValue(storeableValue: StoreableValueType) -> UInt {
        return UInt(storeableValue)
    }
}

extension UInt8: StoreableValueConvertible {
    
    public typealias StoreableValueType = Int64
    
    public var storeableValue: StoreableValueType {
        return Int64(self)
    }
    
    public static func fromStoreableValue(storeableValue: StoreableValueType) -> UInt8 {
        return UInt8(storeableValue)
    }
}

extension UInt16: StoreableValueConvertible {
    
    public typealias StoreableValueType = Int64
    
    public var storeableValue: StoreableValueType {
        return Int64(self)
    }
    
    public static func fromStoreableValue(storeableValue: StoreableValueType) -> UInt16 {
        return UInt16(storeableValue)
    }
}

extension UInt32: StoreableValueConvertible {
    
    public typealias StoreableValueType = Int64
    
    public var storeableValue: StoreableValueType {
        return Int64(self)
    }
    
    public static func fromStoreableValue(storeableValue: StoreableValueType) -> UInt32 {
        return UInt32(storeableValue)

    }
}

extension UInt64: StoreableValueConvertible {
    
    public typealias StoreableValueType = String
    
    public var storeableValue: StoreableValueType {
        return String(self)
    }
    
    public static func fromStoreableValue(storeableValue: StoreableValueType) -> UInt64 {
        return UInt64(storeableValue)!
    }
}