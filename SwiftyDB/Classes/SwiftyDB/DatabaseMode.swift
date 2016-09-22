//
//  DatabaseMode.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 22/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

/**
 The available modes for the database
 
 - normal:  all objects are stored persistently.
 - sandbox: copies the current database and creates a new dummy database. Any changes made in sandbox mode will not affect the original database, and will be lost when the Swifty instance is destroyed.
 */
public enum DatabaseMode {
    case normal
    case sandbox
}
