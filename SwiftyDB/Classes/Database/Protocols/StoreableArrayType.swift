//
//  StoreableArrayType.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 25/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation


protocol StoreableArrayType {
    static var storeableType: Storeable.Type? { get }
}

extension Array: StoreableArrayType {
    static var storeableType: Storeable.Type? {
        return Element.self as? Storeable.Type
    }
}