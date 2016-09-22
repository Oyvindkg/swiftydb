//
//  StorableNSData.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 20/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

extension NSData: StorableProperty {
    
    public typealias StorableValueType = String
    
    public var storableValue: StorableValueType {
        return self.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)
    }
    
    public static func from(storableValue: StorableValueType) -> Self {
        return fromHelper(storableValue: storableValue)
    }
    
    fileprivate static func fromHelper<T: NSData>(storableValue: StorableValueType) -> T {
        return T.init(base64Encoded: storableValue, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!
    }
}
