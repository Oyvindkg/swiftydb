//
//  Configuration.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 02/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

/** A database configuration implementation */
public struct Configuration: ConfigurationProtocol {
    
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
        self.directory  = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        self.mode       = .normal
    }
}
