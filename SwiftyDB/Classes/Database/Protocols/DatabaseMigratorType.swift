//
//  DatabaseMigratorType.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 03/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

protocol DatabaseMigratorType {
    
    func migrateType(type: Storeable.Type, fromTypeInformation typeInformation: TypeInformation) throws
    func migrateType(type: Storeable.Type) throws
    
}