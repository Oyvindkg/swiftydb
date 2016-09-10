//
//  MigrationType.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 10/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

public protocol MigrationType {
    func migrate(property: String) -> PropertyMigrationType
    
    var currentVersion: UInt { get }
}
