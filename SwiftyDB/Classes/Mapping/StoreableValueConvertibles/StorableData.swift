//
//  StorableData.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 22/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation


extension Data: StorableProperty {
    
    public typealias StorableValueType = String
    
    public var storableValue: StorableValueType {
        return self.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)
    }
    
    public static func fromStorableValue(_ storableValue: StorableValueType) -> Data {
        return Data(base64Encoded: storableValue)!
    }
}
