//
//  StoreableNSData.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 20/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

extension NSData: StoreableValueConvertible {
    
    public typealias StoreableValueType = String
    
    public var storeableValue: StoreableValueType {
        return self.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
    }
    
    public static func fromStoreableValue(storeableValue: StoreableValueType) -> Self {
        return fromStoreableValueHelper(storeableValue)
    }
    
    private static func fromStoreableValueHelper<T: NSData>(storeableValue: StoreableValueType) -> T {
        return T.init(base64EncodedString: storeableValue, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
    }
}