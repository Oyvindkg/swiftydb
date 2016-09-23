//
//  ConfigurationProtocol.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 22/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

/** A database configuration */
public protocol ConfigurationProtocol {
    /**
     Create a new database configuration with the provided name
     
     - parameters:
     - name: name of the database
     */
    init(name: String)
    
    /** Name of the database */
    var name: String { get set }
    
    /** The directory in which to search for, or create, the database. This directory must be writable */
    var directory: String { get set }
    
    /** A database path generated from the path, name and mode */
    var path: String { get }
    
    /** The database mode */
    var mode: DatabaseMode { get set }
}
