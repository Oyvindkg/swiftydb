//
//  SQLiteQueryFactory.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 21/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import TinySQLite

private enum Operation: String {
    case createTable = "CREATE_TABLE"
    case createIndex = "CREATE_INDEX"
    case insert = "INSERT"
    case select = "SELECT"
    case delete = "DELETE"
}

protocol SQLiteFilterDeparameterizer {
    static func deaprameterizedStatement(for filter: SQLiteFilterStatement) -> String
}

extension SQLiteFilterDeparameterizer {
    
    static func deaprameterizedStatement(for filter: SQLiteFilterStatement) -> String {
        let statement  = filter.statement
        let parameters = filter.parameters
        
        var statementComponents = statement.components(separatedBy: "?")
        
        for i in statementComponents.indices {
            guard i < parameters.count else {
                break
            }
            
            let literalValue = self.literalValue(of: parameters[i])
            
            statementComponents.insert(literalValue, at: i*2 + 1)
        }
        
        return statementComponents.joined()
    }
    
    private static func literalValue(of storableValue: StorableValue?) -> String {
        switch storableValue {
        case let string as String:
            return "'\(string)'"
        case let double as Double:
            return "\(double)"
        case let int as Int64:
            return "\(int)"
        default:
            return "NULL"
        }
    }
}

protocol SQLiteIndexQueryFactory: SQLiteFilterDeparameterizer {
    static func createIndexQuery(for index: Index) -> SQLiteQuery
}

extension SQLiteIndexQueryFactory {
    
    static func createIndexQuery(for index: Index) -> SQLiteQuery {
        let name = IndexingUtils.name(of: index)
        
        
        var escapedColumnNames: [String] = []
        
        for property in index.properties {
            escapedColumnNames.append("'\(property)'")
        }
        
        let columnsString = escapedColumnNames.joined(separator: ", ")
        
        var query = "CREATE INDEX IF NOT EXISTS '\(name)' ON \(index.type) (\(columnsString))"
        
        
        if let filter = index.filter as? SQLiteFilterStatement {
            
            /* Parameters are not supported when creating indices */
            let unparameterizedFilterStatement = self.deaprameterizedStatement(for: filter)
            
            query += " WHERE \(unparameterizedFilterStatement)"
        }
        
        return SQLiteQuery(query: query, parameters: [])
    }
}

protocol SQLiteTableQueryFactory {
    static func createTableQuery(for reader: Reader) -> SQLiteQuery
}

extension SQLiteTableQueryFactory {
    
    static func createTableQuery(for reader: Reader) -> SQLiteQuery {

        let name       = String(describing: reader.type)
        let identifier = reader.storableType.identifier()
        
        var query = "CREATE TABLE '\(name)' ("
        
        var columnDefinitions: [String] = []
        
        for (property, type) in reader.propertyTypes {
            guard type is StorableValue.Type else {
                columnDefinitions.append( "'\(property)' TEXT" )
                continue
            }
            
            let datatype = SQLiteDatatype(type: type)
            
            var columnDefinition = "'\(property)' \(datatype!.rawValue)"
            
            if property == identifier {
                columnDefinition += " PRIMARY KEY"
            }
            
            columnDefinitions.append( columnDefinition )
        }
        
        query += columnDefinitions.joined(separator: ", ")
        query += ")"
        
        return SQLiteQuery(query: query, parameters: [])
    }
}


protocol SQLiteSelectQueryFactory {
    static func selectQuery(for type: Storable.Type, filter: SQLiteFilterStatement?, sorting: Sorting, limit: Int?, offset: Int?) -> SQLiteQuery
}

extension SQLiteSelectQueryFactory {
    
    static func selectQuery(for type: Storable.Type, filter: SQLiteFilterStatement?, sorting: Sorting, limit: Int?, offset: Int?) -> SQLiteQuery {
        
        var query = "SELECT * FROM '\(type)'"
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


protocol SQLiteDeleteQueryFactory {
    static func deleteQuery(for type: Storable.Type, filter: SQLiteFilterStatement?) -> SQLiteQuery
}

extension SQLiteDeleteQueryFactory {
    static func deleteQuery(for type: Storable.Type, filter: SQLiteFilterStatement?) -> SQLiteQuery {

        var query = "DELETE FROM \(type)"
        var parameters: [SQLiteValue?] = []
        
        if let filter = filter {
            query += " WHERE \(filter.statement)"
            parameters += filter.parameters.to(type: SQLiteValue.self)
        }
        
        return SQLiteQuery(query: query, parameters: parameters)
    }
}

protocol SQLiteInsertQueryFactory {
    static func insertQuery(for reader: Reader, update: Bool) -> SQLiteQuery
}

extension SQLiteInsertQueryFactory {
    
    static func insertQuery(for reader: Reader) -> SQLiteQuery {
        return insertQuery(for: reader, update: true)
    }
    
    static func insertQuery(for reader: Reader, update: Bool) -> SQLiteQuery {
        
        let onCollision  = update ? "REPLACE" : "ABORT"
        let properties   = reader.propertyTypes.keys
        let placeholders = properties.map { ":\($0)"}
        
        let escapedProperties = properties.map({"'\($0)'"})
        
        var query = "INSERT OR \(onCollision) INTO '\(reader.type)'"
        
        query += " (" + escapedProperties.joined(separator: ", ") + ")"
        
        query += " VALUES (" + placeholders.joined(separator: ", ") + ")"
        
        let parameters: [SQLiteValue?] = properties.map { reader.storableValues[$0] as? SQLiteValue }
        
        return SQLiteQuery(query: query, parameters: parameters)
    }
}


struct SQLiteQueryFactory: SQLiteTableQueryFactory, SQLiteInsertQueryFactory, SQLiteDeleteQueryFactory, SQLiteSelectQueryFactory, SQLiteIndexQueryFactory {
}
