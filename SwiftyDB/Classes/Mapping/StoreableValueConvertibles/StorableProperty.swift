//
//  Parseable.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 20/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

/** 
 Defines values that can be converted from and to storable values.
 
 All property values you wish to store must conform to this protocol
 */
public protocol StorableProperty: RawRepresentable {
    
    /** The underlying type used to store this type in the database */
    associatedtype RawValue: StorableValue
//    
//    /** Get a storable representation of the value */
//    var storableValue: StorableValue { get }
//    
//    /** Convert a storable value to its original type */
//    static func from(storableValue: StorableValue) -> Self
}
