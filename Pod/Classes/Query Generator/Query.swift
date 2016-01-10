//
//  Query.swift
//  SQLiteGenerator
//
//  Created by Øyvind Grimnes on 22/12/15.
//

import Foundation
import TinySQLite

public struct Query {
    let query: String
    let values: [SQLiteValue?]?
}