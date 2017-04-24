//
//  Configuration.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 02/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

/** A database configuration implementation */
public struct Configuration {
    
    /** Name of the database */
    public var name: String
    
    /** The directory of the database. This directory must be writable
     
    The default value is the user documents directory
    */
    public var directory: URL
    
    /** The database mode */
    public var mode: Database.Mode
    
    /** The location of the database file using the current configuration's database mode.
    
    Created using the specified directory and database name.
    */
    public var location: URL {
        return location(for: mode)
    }
    
    /**
    Create a new database configuration with the provided name
     
    - parameters:
        - name: name of the database
    */
    public init(name: String) {
        let userDocumentsDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        self.name       = name
        self.directory  = URL(fileURLWithPath: userDocumentsDirectoryPath)
        self.mode       = .normal
    }
    
    /** Location of the database file for a provided mode
 
    - note: This is the location a database file will be created if this configuration is used to create a database in the provided mode.
 
    - parameters:
        - mode: the database mode for which to build a `URL`
    
    - returns: a `URL` to the database file location for the provided mode
    */
    func location(for mode: Database.Mode) -> URL {
        switch mode {
        case .normal:
            return directory.appendingPathComponent(name).appendingPathExtension("swifty")
        case .sandbox:
            return directory.appendingPathComponent(name).appendingPathExtension("sandbox-swifty")
        }
    }
}
