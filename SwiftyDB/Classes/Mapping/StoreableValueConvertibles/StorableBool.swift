//
//  Bool.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 20/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

extension Bool: StorableProperty {
    public typealias RawValue = Int
    
    public var rawValue: Int {
        return Int(self ? 1 : 0)
    }
    
    public init?(rawValue: RawValue) {
        self = rawValue == 1
    }
}
