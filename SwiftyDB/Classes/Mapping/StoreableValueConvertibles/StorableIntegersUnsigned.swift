//
//  StorableUInts.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 20/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation


//TODO: Should this simply be a string?

/* UInt is 64 bit on 64 bit systems. Detect and store as string if necessary */
extension UInt: StorableProperty {
#if arch(x86_64) || arch(arm64)
    public typealias StorableValueType = String

    public var storableValue: StorableValueType {
        return String(self)
    }
    
    public static func from(storableValue: StorableValueType) -> UInt {
        return UInt(storableValue)!
    }
#else
    public typealias StorableValueType = Int64
    
    public var storableValue: StorableValueType {
        return Int64(self)
    }
    
    public static func from(storableValue: StorableValueType) -> UInt {
        return UInt(storableValue)
    }
#endif    
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
