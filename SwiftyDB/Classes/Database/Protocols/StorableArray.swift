//
//  StorableArrayType.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 25/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation


protocol StorableArray {
    static var storableType: Storable.Type? { get }
}

extension Array: StorableArray {
    static var storableType: Storable.Type? {
        return Element.self as? Storable.Type
    }
}
