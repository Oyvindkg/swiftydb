//
//  Identifiable.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 10/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

/** Protocol used to define an identifying property */
public protocol Identifiable {
    
    /** Returns the name of a property that uniquely identifies an object */
    static func identifier() -> String
}
