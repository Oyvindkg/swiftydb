//
//  Parseable.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 20/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

/** Defines values that can be converted to storable values */
public protocol StorableValueConvertible {
    
    /** The type used to store this type in the database */
    associatedtype StorableValueType: StorableValue
    
    /** Get a storable representation of the value */
    var storableValue: StorableValueType { get }
    
    /** Convert a storable value to its original type */
    static func fromStorableValue(storableValue: StorableValueType) -> Self
}
