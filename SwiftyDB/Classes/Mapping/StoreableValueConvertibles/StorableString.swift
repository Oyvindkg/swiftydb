//
//  String.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 20/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

extension String: StorableProperty {
    
    public typealias RawValue = String
    
    public var rawValue: String {
        return self
    }
    
    public init?(rawValue: RawValue) {
        self = rawValue
    }
}
