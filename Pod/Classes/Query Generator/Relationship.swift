//
//  Relationship.swift
//  SQLiteGenerator
//
//  Created by Øyvind Grimnes on 28/12/15.
//

import TinySQLite

internal struct Relationship {
    let column: Column
    let relationship: ColumnRelationship
    let value: Any?
    
    func statement() -> String {
        switch relationship {
        case .GreaterThan, .LessThan, .EqualTo:
            return "\(column.identifier) \(relationship.rawValue) \(value!)"
        case .ContainedIn:
            let values = value as! [SQLiteValue]
            return "\(column.identifier) \(relationship.rawValue) (\(values.map({String($0)}).joinWithSeparator(", ")))"
        }
    }
}