//
//  StoreableCharacter.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 20/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

extension Character: StoreableValueConvertible {
    public typealias StoreableValueType = String
    
    public var storeableValue: StoreableValueType {
        return String(self)
    }
    
    public static func fromStoreableValue(storeableValue: StoreableValueType) -> Character {
        return storeableValue.characters.first!
    }
}