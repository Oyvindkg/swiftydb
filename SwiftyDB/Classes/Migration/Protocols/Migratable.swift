//
//  Migratable.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 01/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

public protocol Migratable {
    static func migrate(migration: MigrationType)
}