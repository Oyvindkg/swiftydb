//
//  Configuration.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 02/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

/** A database configuration */
public protocol ConfigurationType {
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

/**
 The available modes for the database
 
 - normal:  all objects are stored persistently.
 - sandbox: copies the current database and creates a new dummy database. Any changes made in sandbox mode will not affect the original database, and will be lost when the Swifty instance is destroyed.
 */
public enum DatabaseMode {
    case normal
    case sandbox
}

/** A database configuration implementation */
public struct Configuration: ConfigurationType {
    
    public var name: String
    
    public var directory: String
    
    public var mode: DatabaseMode
    
    public var path: String {
        switch mode {
        case .normal:
            return directory + "/" + name
        case .sandbox:
            return directory + "/sandbox-" + name
        }
    }
    
    public init(name: String) {
        self.name       = name
        self.directory  = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        self.mode       = .normal
    }
}
