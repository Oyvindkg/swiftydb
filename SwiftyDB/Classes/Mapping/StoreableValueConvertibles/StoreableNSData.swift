//
//  StorableNSData.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 20/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

extension NSData: StorableValueConvertible {
    
    public typealias StorableValueType = String
    
    public var storableValue: StorableValueType {
        return self.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
    }
    
    public static func fromStorableValue(storableValue: StorableValueType) -> Self {
        return fromStorableValueHelper(storableValue)
    }
    
    private static func fromStorableValueHelper<T: NSData>(storableValue: StorableValueType) -> T {
        return T.init(base64EncodedString: storableValue, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
    }
}
