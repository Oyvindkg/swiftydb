//
//  Value.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 24/03/16.
//

import Foundation

public protocol Value {}

extension NSArray: Value {}
extension NSDictionary: Value {}

extension String: Value {}
extension NSString: Value {}
extension Character: Value {}

extension Bool: Value {}

extension Int: Value {}
extension Int8: Value {}
extension Int16: Value {}
extension Int32: Value {}
extension Int64: Value {}
extension UInt: Value {}
extension UInt8: Value {}
extension UInt16: Value {}
extension UInt32: Value {}
extension UInt64: Value {}

extension Float: Value {}
extension Double: Value {}

extension NSData: Value {}
extension NSDate: Value {}
extension NSNumber: Value {}