//
//  Storable.swift
//  ORM
//
//  Created by Øyvind Grimnes on 17/08/16.
//  Copyright © 2016 Øyvind Grimnes. All rights reserved.
//

import Foundation

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
