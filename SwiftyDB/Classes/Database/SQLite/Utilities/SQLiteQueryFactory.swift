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

class SQLiteQueryFactory {
    
    var queryCache: [String: SQLiteQuery] = [:]
    
    // MARK: Create table
    
    func createTableQueryFor(reader: Reader) -> SQLiteQuery {
        if let query = cachedQueryFor(type: reader.storableType, andOperation: .createTable) {
            return query
        }
        
        let query = buildCreateTableQueryFor(reader: reader)
        
        cache(query: query, forType: reader.storableType, andOperation: .createTable)
        
        return query
    }
    
    fileprivate func buildCreateTableQueryFor(reader: Reader) -> SQLiteQuery {
        let name       = String(describing: reader.type)
        let identifier = reader.storableType.identifier()
        
        var query = "CREATE TABLE '\(name)' ("
        
        var columnDefinitions: [String] = []
        
        for (property, type) in reader.types {
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
    
    // MARK: Insert
    
    func insertQueryFor(reader: Reader, update: Bool = true) -> SQLiteQuery {
        /* Does not work for optional values in the current implementation */
//        if let query = cachedQueryForType(reader.storableType, andOperation: .Insert) {
//            return query
//        }
        
        let query = buildInsertQueryFor(reader: reader)
        
        cache(query: query, forType: reader.storableType, andOperation: .insert)
        
        return query
    }
    
    fileprivate func buildInsertQueryFor(reader: Reader, update: Bool = true) -> SQLiteQuery {
        let onCollision  = update ? "REPLACE" : "ABORT"
        let properties   = reader.types.keys
        let placeholders = properties.map { ":\($0)"}
        
        let escapedProperties = properties.map({"'\($0)'"})
        
        var query = "INSERT OR \(onCollision) INTO '\(reader.type)'"
        
        query += " (" + escapedProperties.joined(separator: ", ") + ")"
        
        query += " VALUES (" + placeholders.joined(separator: ", ") + ")"
        
        let parameters: [SQLiteValue?] = properties.map { reader.storableValues[$0] as? SQLiteValue }
        
        return SQLiteQuery(query: query, parameters: parameters)
    }
    
    // MARK: Select
    
    func selectQueryFor(type: Storable.Type, andFilter filter: SQLiteFilterStatement?, sorting: Sorting, limit: Int?, offset: Int?) -> SQLiteQuery {
        return buildSelectQueryFor(type: type, andFilter: filter, sorting: sorting, limit: limit, offset: offset)
    }
    
    func buildSelectQueryFor(type: Storable.Type, andFilter filter: SQLiteFilterStatement?, sorting: Sorting, limit: Int?, offset: Int?) -> SQLiteQuery {
        
        var query = "SELECT * FROM '\(type)'"
        var parameters: [SQLiteValue?] = []
        
        if let filter = filter {
            query += " WHERE \(filter.statement)"
            parameters += filter.parameters.to(type: SQLiteValue.self)
        }
        
        query += " \(orderByComponentFor(sorting: sorting))"
    
        let (limitComponenet, limitParameters) = limitComponentFor(limit: limit, andOffset: offset)
        
        query      += limitComponenet
        parameters += limitParameters.to(type: SQLiteValue.self)
        
        
        return SQLiteQuery(query: query, parameters: parameters)
    }
    
    fileprivate func orderByComponentFor(sorting: Sorting) -> String {
        switch sorting {
        case .ascending(let property):
            return " ORDER BY \(property) ASC"
        case .descending(let property):
            return " ORDER BY \(property) DESC"
        case .none:
            return ""
        }
    }
    
    fileprivate func limitComponentFor(limit: Int?, andOffset offset: Int?) -> (String, [SQLiteValue?]) {
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
    
    // MARK: - Create index
    
    func createIndexQueryFor(index: _IndexInstance) -> SQLiteQuery {
        return buildCreateIndexQueryFor(index: index)
    }
    
    func buildCreateIndexQueryFor(index: _IndexInstance) -> SQLiteQuery {
        let name = IndexingUtils.nameFor(index: index)
        
        var query = "CREATE INDEX IF NOT EXISTS '\(name)' ON '\(index.type)' (\(index.properties.joined(separator: ", ")))"
        var parameters: [SQLiteValue?] = []
        
        if let filter = index.filters as? SQLiteFilterStatement {
            query += " WHERE \(filter.statement)"
            parameters += filter.parameters.to(type: SQLiteValue.self)
        }
        
        return SQLiteQuery(query: query, parameters: parameters)
    }
    
    // MARK: - Delete 
    
    func deleteQueryFor(type: Storable.Type, withFilter filter: SQLiteFilterStatement?) -> SQLiteQuery {
        if let query = cachedQueryFor(type: type, andOperation: .delete) {
            return query
        }
        
        let query = buildDeleteQueryFor(type: type, withFilter: filter)
        
        return query
    }
    
    func buildDeleteQueryFor(type: Storable.Type, withFilter filter: SQLiteFilterStatement?) -> SQLiteQuery {
        var query = "DELETE FROM \(type)"
        var parameters: [SQLiteValue?] = []
        
        if let filter = filter {
            query      += " WHERE \(filter.statement)"
            parameters += filter.parameters.to(type: SQLiteValue.self)
        }
        
        return SQLiteQuery(query: query, parameters: parameters)
    }
    
    // MARK: - Cache
    
    fileprivate func cachedQueryFor(type: Storable.Type, andOperation operation: Operation) -> SQLiteQuery? {
        return queryCache["\(operation.rawValue):\(type)"]
    }
    
    fileprivate func cache(query: SQLiteQuery, forType type: Storable.Type, andOperation operation: Operation) {
        queryCache["\(operation.rawValue):\(type)"] = query
    }
}
