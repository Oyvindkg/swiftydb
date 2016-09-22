//
//  StorableCharacter.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 20/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

extension Character: StorableValueConvertible {
    public typealias StorableValueType = String
    
    public var storableValue: StorableValueType {
        return String(self)
    }
    
    public static func fromStorableValue(storableValue: StorableValueType) -> Character {
        return storableValue.characters.first!
    }
}
