//
//  Configuration.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 02/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

extension Database {
    /** A database configuration implementation */
    public struct Configuration {
        
        /** Name of the database */
        public var name: String
        
        /** 
        The directory of the database. This directory must be writable
         
        The default value is the user documents directory
        */
        public var directory: URL
        
        /** The database mode */
        public var mode: Database.Mode
        
        /**
        Create a new database configuration with the provided name
         
        - parameters:
            - name: name of the database
        */
        public init(name: String) {
            self.name       = name
            self.directory  = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            self.mode       = .normal
        }
    }
}

extension Database.Configuration {
    
    /** The location of the database file using the current configuration's database mode.
     
     Created using the specified directory and database name.
     */
    public var location: URL {
        return location(for: mode)
    }
    
    /** Location of the database file for a provided mode
     
     - note: This is the location a database file will be created if this configuration is used to create a database in the provided mode.
     
     - parameters:
     - mode: the database mode for which to build a `URL`
     
     - returns: a `URL` to the database file location for the provided mode
     */
    func location(for mode: Database.Mode) -> URL {

        let url = directory.appendingPathComponent(name)
                            .appendingPathComponent(mode.rawValue)
                            .appendingPathComponent("database")
                            .appendingPathExtension("sqlite")
 
        try? FileManager.default.createDirectory(at: url.deletingLastPathComponent(),
                                                 withIntermediateDirectories: true,
                                                 attributes: nil)
        
        return url
    }
}
