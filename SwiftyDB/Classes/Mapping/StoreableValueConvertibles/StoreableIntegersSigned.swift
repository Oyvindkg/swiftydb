//
//  Int.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 20/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

extension Int: StorableValueConvertible {
    
    public typealias StorableValueType = Int64
    
    public var storableValue: StorableValueType{
        return Int64(self)
    }
    
    public static func fromStorableValue(storableValue: StorableValueType) -> Int {
        return Int(storableValue)
    }
}

extension Int8: StorableValueConvertible {
    
    public typealias StorableValueType = Int64
    
    public var storableValue: StorableValueType{
        return Int64(self)
    }
    
    public static func fromStorableValue(storableValue: StorableValueType) -> Int8 {
        return Int8(storableValue)
    }
}

extension Int16: StorableValueConvertible {
    
    public typealias StorableValueType = Int64
    
    public var storableValue: StorableValueType{
        return Int64(self)
    }
    
    public static func fromStorableValue(storableValue: StorableValueType) -> Int16 {
        return Int16(storableValue)
    }
}

extension Int32: StorableValueConvertible {
    
    public typealias StorableValueType = Int64
    
    public var storableValue: StorableValueType {
        return Int64(self)
    }
    
    public static func fromStorableValue(storableValue: StorableValueType) -> Int32 {
        return Int32(storableValue)
    }
}

extension Int64: StorableValueConvertible {
    
    public typealias StorableValueType = Int64
    
    public var storableValue: StorableValueType{
        return self
    }
    
    public static func fromStorableValue(storableValue: StorableValueType) -> Int64 {
        return storableValue
    }
}
