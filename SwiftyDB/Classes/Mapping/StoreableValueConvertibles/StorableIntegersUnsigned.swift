//
//  StorableUInts.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 20/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation


extension UInt: StorableProperty {
    public typealias RawValue = String
    
    /* This could be changed to an Int for storing the bit pattern, but that will break value comparisons in the database */
    public var rawValue: String {
        return String(self)
    }
    
    public init?(rawValue: RawValue) {
        guard let value = UInt(rawValue) else {
            return nil
        }
        
        self = value
    }
}

extension UInt8: StorableProperty {
    
    public typealias RawValue = Int
    
    public var rawValue: Int {
        return Int(self)
    }
    
    public init?(rawValue: RawValue) {
        self = UInt8(rawValue)
    }
}

extension UInt16: StorableProperty {
    
    public typealias RawValue = Int
    
    public var rawValue: Int {
        return Int(self)
    }
    
    public init?(rawValue: RawValue) {
        self = UInt16(rawValue)
    }
}

extension UInt32: StorableProperty {
    
    public typealias RawValue = Int
    
    public var rawValue: Int {
        return Int(self)
    }
    
    public init?(rawValue: RawValue) {
        self = UInt32(rawValue)
    }
}

extension UInt64: StorableProperty {
    
    /* This could be changed to an Int for storing the bit pattern, but that will break value comparisons in the database */
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
