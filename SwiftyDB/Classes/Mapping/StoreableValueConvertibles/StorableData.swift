//
//  StorableData.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 22/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation


extension Data: StorableProperty {
    
    public typealias RawValue = Data
    
    public var rawValue: Data {
        return self
    }
    
    public init?(rawValue: RawValue) {
        self = rawValue
    }
}
