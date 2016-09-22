//
//  Parseable.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 20/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

/** Defines values that can be converted to storable values */
public protocol StoreableValueConvertible {
    
    /** The type used to store this type in the database */
    associatedtype StoreableValueType: StoreableValue
    
    /** Get a storable representation of the value */
    var storeableValue: StoreableValueType { get }
    
    /** Convert a storable value to its original type */
    static func fromStoreableValue(storeableValue: StoreableValueType) -> Self
}
