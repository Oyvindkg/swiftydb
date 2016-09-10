//
//  Configuration.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 02/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

public protocol ConfigurationType {
    init(databaseName: String)
    
    var databaseName: String { get set }
    var databaseDirectory: String { get set }
    var databasePath: String { get }
    
    var dryRun: Bool { get set }
}

public struct Configuration: ConfigurationType {
    
    public var databaseName: String
    public var databaseDirectory: String
    
    public var dryRun: Bool
    
    public var databasePath: String {
        return databaseDirectory + "/" + databaseName
    }
    
    public init(databaseName: String) {
        self.databaseName = databaseName
        self.databaseDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        
        self.dryRun       = false
    }
}