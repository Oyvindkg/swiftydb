//
//  MigratorType.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 03/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation


protocol Migrator {
    func migrateTypeIfNecessary(_ type: Storable.Type, in database: Database) throws
}
