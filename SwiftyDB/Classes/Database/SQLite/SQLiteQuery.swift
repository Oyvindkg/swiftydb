//
//  SQLiteQuery.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 21/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import TinySQLite

struct SQLiteQuery {
    let query: String
    let parameters: [SQLiteValue?]
}