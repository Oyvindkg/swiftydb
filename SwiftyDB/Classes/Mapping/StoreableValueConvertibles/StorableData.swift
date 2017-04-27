//
//  StorableData.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 22/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation


extension Data: StorableProperty {
    
    public typealias RawValue = String
    
    public var rawValue: RawValue {
        return base64EncodedString()
    }
    
    public init?(rawValue: RawValue) {
        guard let data = Data(base64Encoded: rawValue) else {
            return nil
        }
        
        self = data
    }
}
