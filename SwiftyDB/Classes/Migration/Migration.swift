//
//  Migration.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 31/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

internal class Migration: MigrationType {
    
    let currentVersion: UInt
    var propertyMigrations: [PropertyMigration] = []
    
    init(currentVersion: UInt) {
        self.currentVersion = currentVersion
    }
    
    func migrate(propertyName: String) -> PropertyMigrationType {
        let propertyMigration = PropertyMigration(propertyName: propertyName)
        
        propertyMigrations.append(propertyMigration)
        
        return propertyMigration
    }
}