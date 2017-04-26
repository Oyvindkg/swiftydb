//
//  StorableValue.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 21/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

/** A basic value that can be added to the database in its current form */
public protocol StorableValue {}

extension String: StorableValue {}
extension Double: StorableValue {}
extension Int: StorableValue {}
extension Data: StorableValue {}
