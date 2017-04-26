//
//  Int.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 20/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation


extension Int: StorableProperty {
    
    public typealias RawValue = Int64
    
    public var rawValue: Int64 {
        return Int64(self)
    }
    
    public init?(rawValue: RawValue) {
        self = Int(rawValue)
    }
}

extension Int8: StorableProperty {
    
    public typealias RawValue = Int64
    
    public var rawValue: Int64 {
        return Int64(self)
    }
    
    public init?(rawValue: RawValue) {
        self = Int8(rawValue)
    }
}

extension Int16: StorableProperty {
    
    public typealias RawValue = Int64
    
    public var rawValue: Int64 {
        return Int64(self)
    }
    
    public init?(rawValue: RawValue) {
        self = Int16(rawValue)
    }
}

extension Int32: StorableProperty {
    
    public typealias RawValue = Int64
    
    public var rawValue: Int64 {
        return Int64(self)
    }
    
    public init?(rawValue: RawValue) {
        self = Int32(rawValue)
    }
}

extension Int64: StorableProperty {
    
    public typealias RawValue = Int64
    
    public var rawValue: Int64 {
        return self
    }
    
    public init?(rawValue: RawValue) {
        self = rawValue
    }
}
