//
//  StorableUInts.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 20/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation


//TODO: Can SQLite store undigned 64-bit integers?

extension UInt: StorableProperty {
    
    public typealias StorableValueType = Int64
    
    public var storableValue: StorableValueType {
        return Int64(self)
    }
    
    public static func from(storableValue: StorableValueType) -> UInt {
        return UInt(storableValue)
    }
}

extension UInt8: StorableProperty {
    
    public typealias StorableValueType = Int64
    
    public var storableValue: StorableValueType {
        return Int64(self)
    }
    
    public static func from(storableValue: StorableValueType) -> UInt8 {
        return UInt8(storableValue)
    }
}

extension UInt16: StorableProperty {
    
    public typealias StorableValueType = Int64
    
    public var storableValue: StorableValueType {
        return Int64(self)
    }
    
    public static func from(storableValue: StorableValueType) -> UInt16 {
        return UInt16(storableValue)
    }
}

extension UInt32: StorableProperty {
    
    public typealias StorableValueType = Int64
    
    public var storableValue: StorableValueType {
        return Int64(self)
    }
    
    public static func from(storableValue: StorableValueType) -> UInt32 {
        return UInt32(storableValue)

    }
}

extension UInt64: StorableProperty {
    
    public typealias StorableValueType = String
    
    public var storableValue: StorableValueType {
        return String(self)
    }
    
    public static func from(storableValue: StorableValueType) -> UInt64 {
        return UInt64(storableValue)!
    }
}
