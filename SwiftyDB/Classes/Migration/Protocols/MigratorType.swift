//
//  MigratorType.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 03/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation


protocol MigratorType {
    func migrateTypeIfNecessary(type: Storeable.Type, inSwifty swifty: Swifty) throws
}