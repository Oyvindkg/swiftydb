//
//  MigratorType.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 03/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation


protocol MigratorType {
    func migrateTypeIfNecessary(_ type: Storable.Type, inSwifty swifty: Swifty) throws
}
