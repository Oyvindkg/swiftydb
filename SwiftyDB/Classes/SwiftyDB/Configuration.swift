//
//  Configuration.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 02/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

public protocol ConfigurationProtocol {
    init(databaseName: String)
    
    var databaseName: String { get set }
    var databaseDirectory: String { get set }
    var databasePath: String { get }
    
    var mode: DatabaseMode { get set }
}

public enum DatabaseMode {
    case normal
    case sandbox
}

public struct Configuration: ConfigurationProtocol {
    
    public var databaseName: String
    public var databaseDirectory: String
    
    public var mode: DatabaseMode
    
    public var databasePath: String {
        return databaseDirectory + "/" + databaseName
    }
    
    public init(databaseName: String) {
        self.databaseName = databaseName
        self.databaseDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        
        self.mode       = .normal
    }
}
