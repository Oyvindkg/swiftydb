//
//  Storable.swift
//  ORM
//
//  Created by Øyvind Grimnes on 17/08/16.
//  Copyright © 2016 Øyvind Grimnes. All rights reserved.
//

import Foundation

/** Protocol used to define an identifying property */
public protocol Identifiable {
    
    /** Returns the name of a property that uniquely identifies an object */
    static func identifier() -> String
}

/** 
 Defines an object that can be stored in the database 
 
 The object must be mappable in order to retrieve objects from the database
 
 The object must be identifiable to let Swifty manage references and unique objects
 */
public protocol Storable: Identifiable, Mappable {}

extension Storable {
    internal static var name: String {
        return "\(self)"
    }
}

/** This protocol is used to read the element type of array during object retrieval */
internal protocol StorableArray {
    static var storableType: Storable.Type? { get }
}

extension Array: StorableArray {
    static var storableType: Storable.Type? {
        return Element.self as? Storable.Type
    }
}
