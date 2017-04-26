//
//  StorableCharacter.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 20/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

extension Character: StorableProperty {
    public typealias RawValue = String
    
    public var rawValue: RawValue {
        return String(self)
    }
    
    public init?(rawValue: RawValue) {
        guard !rawValue.characters.isEmpty else {
            return nil
        }
        
        self = rawValue.characters.first!
    }
}
