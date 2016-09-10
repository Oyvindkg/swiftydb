//
//  Parseable.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 20/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

public protocol StoreableValueConvertible {
    associatedtype StoreableValueType: StoreableValue
    
    var storeableValue: StoreableValueType { get }
    
    static func fromStoreableValue(storeableValue: StoreableValueType) -> Self
}