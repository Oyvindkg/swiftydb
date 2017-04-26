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
    
    public typealias RawValue = String
    
    public var rawValue: String {
        return String(self)
    }
    
    public init?(rawValue: RawValue) {
        guard let value = UInt(rawValue) else {
            return nil
        }
        
        self = value
    }
    
#else
    
    public typealias RawValue = Int64
    
    public var rawValue: Int64 {
        return Int64(self)
    }
    
    public init?(rawValue: RawValue) {
        self = UInt(rawValue)
    }
    
#endif    
}

extension UInt8: StorableProperty {
    
    public typealias RawValue = Int64
    
    public var rawValue: Int64 {
        return Int64(self)
    }
    
    public init?(rawValue: RawValue) {
        self = UInt8(rawValue)
    }
}

extension UInt16: StorableProperty {
    
    public typealias RawValue = Int64
    
    public var rawValue: Int64 {
        return Int64(self)
    }
    
    public init?(rawValue: RawValue) {
        self = UInt16(rawValue)
    }
}

extension UInt32: StorableProperty {
    
    public typealias RawValue = Int64
    
    public var rawValue: Int64 {
        return Int64(self)
    }
    
    public init?(rawValue: RawValue) {
        self = UInt32(rawValue)
    }
}

extension UInt64: StorableProperty {
    
    public typealias RawValue = String
    
    public var rawValue: String {
        return String(self)
    }
    
    public init?(rawValue: RawValue) {
        guard let value = UInt64(rawValue) else {
            return nil
        }
        
        self = value
    }
}
