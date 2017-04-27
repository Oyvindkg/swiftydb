//
//  SQLiteQueryFactory.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 21/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import TinySQLite

/** Small wrapper for a parameterized SQLite query */
internal struct SQLiteQuery {
    let query: String
    let parameters: [SQLiteValue?]
}

/** Represents an SQLite table column */
internal struct Column {
    
    enum Datatype: String {
        case real       = "REAL"
        case integer    = "INTEGER"
        case blob       = "BLOB"
        case text       = "TEXT"
        
        init?<T>(value: T?) {
            self.init(type: T.self)
        }
        
        init?(type: Any.Type) {
            switch type {
            case is Int.Type, is Int8.Type, is Int16.Type, is Int32.Type, is Int64.Type, is UInt8.Type, is UInt16.Type, is UInt32.Type, is Bool.Type:
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
    
    let name: String
    let type: Datatype
    
    /** String used to define this column in a CREATE TABLE statement */
    var definition: String {
        return "'\(name)' \(type.rawValue)"
    }
}


private enum Operation: String {
    case createTable = "CREATE_TABLE"
    case createIndex = "CREATE_INDEX"
    case insert      = "INSERT"
    case select      = "SELECT"
    case delete      = "DELETE"
}


struct SQLiteQueryFactory {

    static func createIndexQuery(for index: AnyIndex, for type: Storable.Type) -> SQLiteQuery {
        let name = IndexingUtilities.name(of: index, for: type)
        
        var escapedColumnNames: [String] = []
        
        for property in index.properties {
            escapedColumnNames.append("'\(property)'")
        }
        
        let columnsString = escapedColumnNames.joined(separator: ", ")
        
        var query = "CREATE INDEX IF NOT EXISTS '\(name)' ON \(type.name) (\(columnsString))"
        
        
        if let filter = index.filter as? SQLiteFilterStatement {
            
            /* Parameters are not supported when creating indices */
            query += " WHERE \(filter.deparameterizedStatement)"
        }
        
        return SQLiteQuery(query: query, parameters: [])
    }

    static func createTableQuery(for reader: Reader) -> SQLiteQuery {

        let name       = String(describing: reader.type)
        let identifier = reader.storableType.identifier()
        
        var query = "CREATE TABLE '\(name)' ("
        
        var columnDefinitions: [String] = []
        
        for (property, type) in reader.propertyTypes {
            
            let column = columnForProperty(property, withType: type)
            
            var definition = column.definition
            
            if property == identifier {
                definition += " PRIMARY KEY"
            }
            
            columnDefinitions.append( definition )
        }
        
        query += columnDefinitions.joined(separator: ", ")
        query += ")"
        
        return SQLiteQuery(query: query, parameters: [])
    }

    static func selectQuery(for type: Storable.Type, filter: SQLiteFilterStatement?, sorting: Sorting, limit: Int?, offset: Int?) -> SQLiteQuery {
        
        var query = "SELECT * FROM '\(type.name)'"
        var parameters: [SQLiteValue?] = []
        
        if let filter = filter {
            query += " WHERE \(filter.statement)"
            parameters += filter.parameters.to(type: SQLiteValue.self)
        }
        
        query += " \(orderByComponent(for: sorting))"
        
        let (limitComponenet, limitParameters) = limitComponent(forLimit: limit, withOffset: offset)
        
        query      += limitComponenet
        parameters += limitParameters.to(type: SQLiteValue.self)
        
        
        return SQLiteQuery(query: query, parameters: parameters)
    }

    static func deleteQuery(for type: Storable.Type, filter: SQLiteFilterStatement?) -> SQLiteQuery {

        var query = "DELETE FROM \(type.name)"
        var parameters: [SQLiteValue?] = []
        
        if let filter = filter {
            query += " WHERE \(filter.statement)"
            parameters += filter.parameters.to(type: SQLiteValue.self)
        }
        
        return SQLiteQuery(query: query, parameters: parameters)
    }
    

    static func insertQuery(for reader: Reader, replaceIfExists replace: Bool) -> SQLiteQuery {
        
        let onCollision  = replace ? "REPLACE" : "ABORT"
        let properties   = reader.propertyTypes.keys
        let placeholders = properties.map { ":\($0)"}
        
        let escapedProperties = properties.map({"'\($0)'"})
        
        var query = "INSERT OR \(onCollision) INTO '\(reader.type)'"
        
        query += " (" + escapedProperties.joined(separator: ", ") + ")"
        
        query += " VALUES (" + placeholders.joined(separator: ", ") + ")"
        
        let parameters: [SQLiteValue?] = properties.map { reader.storableValues[$0] as? SQLiteValue }
        
        return SQLiteQuery(query: query, parameters: parameters)
    }
    
    private static func columnForProperty(_ property: String, withType type: Any.Type) -> Column {
        guard type is StorableValue.Type else {
            return Column(name: property, type: .text)
        }
        
        let datatype = Column.Datatype(type: type)!
        
        return Column(name: property, type: datatype)
    }
    
    private static  func orderByComponent(for sorting: Sorting) -> String {
        switch sorting {
        case .ascending(let property):
            return " ORDER BY \(property) ASC"
        case .descending(let property):
            return " ORDER BY \(property) DESC"
        case .none:
            return ""
        }
    }
    
    private static  func limitComponent(forLimit limit: Int?, withOffset offset: Int?) -> (String, [SQLiteValue?]) {
        if limit != nil && offset != nil {
            return (" LIMIT ? OFFSET ?", [limit, offset])
        }
        
        if offset != nil {
            return (" LIMIT -1 OFFSET ?", [offset])
        }
        
        if limit != nil {
            return (" LIMIT ?", [limit])
        }
        
        return ("", [])
    }
}
