//
//  StorableFloat.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 20/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

extension Float: StorableProperty {

    public typealias RawValue = Double
    
    public var rawValue: Double {
        return Double(self)
    }
    
    public init?(rawValue: RawValue) {
        self = Float(rawValue)
    }
}
