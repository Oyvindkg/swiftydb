//
//  ObjectSerializerType.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 08/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

protocol ObjectSerializer {
    
    /** Get an array of `Reader`s representing the `Storable` object and any nested  `Storable`s */
    static func readers<T: Storable>(for storable: T?) -> [Reader]
}
