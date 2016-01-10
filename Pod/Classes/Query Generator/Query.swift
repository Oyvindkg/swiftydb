//
//  Query.swift
//  SQLiteGenerator
//
//  Created by Øyvind Grimnes on 22/12/15.
//

import Foundation
import TinySQLite

// MARK: - Setup SQLiteValue protocol for all supported  datatypes

/** Valid SQLite types are marked using the 'SQLiteValue' protocol */
//public protocol SQLiteValue {}

//extension String: SQLiteValue {}
//extension NSString: SQLiteValue {}
//extension Character: SQLiteValue {}
//
//extension Bool: SQLiteValue {}
//
//extension Int: SQLiteValue {}
//extension Int8: SQLiteValue {}
//extension Int16: SQLiteValue {}
//extension Int32: SQLiteValue {}
//extension Int64: SQLiteValue {}
//extension UInt: SQLiteValue {}
//extension UInt8: SQLiteValue {}
//extension UInt16: SQLiteValue {}
//extension UInt32: SQLiteValue {}
//extension UInt64: SQLiteValue {}
//
//extension Float: SQLiteValue {}
//extension Float80: SQLiteValue {}
//extension Double: SQLiteValue {}
//
//extension NSData: SQLiteValue {}
//extension NSNumber: SQLiteValue {}
//
//extension NSDate: SQLiteValue {} //TODO: Should dates be accespted?
//


public struct Query {
    let query: String
    let values: [SQLiteValue?]?
}