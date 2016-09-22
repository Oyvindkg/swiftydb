//
//  SQLiteDatatype.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 22/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

enum SQLiteDatatype: String {
    case real       = "REAL"
    case integer    = "INTEGER"
    case blob       = "BLOB"
    case text       = "TEXT"
    
    init?<T>(value: T?) {
        self.init(type: T.self)
    }
    
    init?(type: Any.Type) {
        switch type {
        case is Int.Type, is Int8.Type, is Int16.Type, is Int32.Type, is Int64.Type, is UInt.Type, is UInt8.Type, is UInt16.Type, is UInt32.Type, is Bool.Type:
            self.init(rawValue: "INTEGER")
        case is Double.Type, is Float.Type:
            self.init(rawValue: "REAL")
        case is String.Type, is Character.Type:
            self.init(rawValue: "TEXT")
        case is Data.Type:
            self.init(rawValue: "BLOB")
        default:
            return nil
        }
    }
}
