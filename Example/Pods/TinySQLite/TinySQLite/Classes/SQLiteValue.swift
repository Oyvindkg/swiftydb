//
//  SQLiteValue.swift
//  TinySQLite
//
//  Created by Øyvind Grimnes on 13/02/17.
//  Copyright © 2017 Øyvind Grimnes. All rights reserved.
//

import Foundation


/** Valid SQLite types are identified using the 'SQLiteValue' protocol */
public protocol SQLiteValue {}

extension String: SQLiteValue {}
extension NSString: SQLiteValue {}
extension Character: SQLiteValue {}

extension Bool: SQLiteValue {}

extension Int: SQLiteValue {}
extension Int8: SQLiteValue {}
extension Int16: SQLiteValue {}
extension Int32: SQLiteValue {}
extension Int64: SQLiteValue {}
extension UInt: SQLiteValue {}
extension UInt8: SQLiteValue {}
extension UInt16: SQLiteValue {}
extension UInt32: SQLiteValue {}

extension Float: SQLiteValue {}
extension Double: SQLiteValue {}

extension Data: SQLiteValue {}
extension Date: SQLiteValue {}

extension NSData: SQLiteValue {}
extension NSDate: SQLiteValue {}
extension NSNumber: SQLiteValue {}
