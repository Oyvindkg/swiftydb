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
}

/** A basic value that can be added to the database in its current form */
public protocol StorableValue {}

extension String: StorableValue {}
extension Double: StorableValue {}
extension Int: StorableValue {}
extension Data: StorableValue {}
