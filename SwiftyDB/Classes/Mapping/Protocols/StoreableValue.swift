//
//  StoreableValue.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 21/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

/** A basic value that can be added to the database in its current form */
public protocol StoreableValue {}

extension String: StoreableValue {}
extension Double: StoreableValue {}
extension Int64: StoreableValue {}
