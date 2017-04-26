//
//  StorableUUID.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 13/02/17.
//  Copyright © 2017 Øyvind Grimnes. All rights reserved.
//

import Foundation


extension UUID: StorableProperty {
    
    public typealias RawValue = String

    public var rawValue: String {
        return uuidString
    }
    
    public init?(rawValue: RawValue) {
        guard let uuid = UUID(uuidString: rawValue) else {
            return nil
        }
        
        self = uuid
    }
}
