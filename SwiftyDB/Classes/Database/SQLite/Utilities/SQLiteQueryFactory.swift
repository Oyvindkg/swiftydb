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
    
    func createTableQueryForReader(reader: Reader) -> SQLiteQuery {
        if let query = cachedQueryForType(reader.storeableType, andOperation: .createTable) {
            return query
        }
        
        let query = buildCreateTableQueryForReader(reader)
        
        cacheQuery(query, forType: reader.storeableType, andOperation: .createTable)
        
        return query
    }
    
    private func buildCreateTableQueryForReader(reader: Reader) -> SQLiteQuery {
        let name       = String(reader.type)
        let identifier = reader.storeableType.identifier()
        
        var query = "CREATE TABLE '\(name)' ("
        
        var columnDefinitions: [String] = []
        
        for (property, type) in reader.types {
            guard type is StoreableValue.Type else {
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
        
        query += columnDefinitions.joinWithSeparator(", ")
        query += ")"
        
        return SQLiteQuery(query: query, parameters: [])
    }
    
    // MARK: Insert
    
    func insertQueryForReader(reader: Reader, update: Bool = true) -> SQLiteQuery {
        /* Does not work for optional values in the current implementation */
//        if let query = cachedQueryForType(reader.storeableType, andOperation: .Insert) {
//            return query
//        }
        
        let query = buildInsertQueryForReader(reader)
        
        cacheQuery(query, forType: reader.storeableType, andOperation: .insert)
        
        return query
    }
    
    private func buildInsertQueryForReader(reader: Reader, update: Bool = true) -> SQLiteQuery {
        let onCollision  = update ? "REPLACE" : "ABORT"
        let properties   = reader.types.keys
        let placeholders = properties.map { ":\($0)"}
        
        let escapedProperties = properties.map({"'\($0)'"})
        
        var query = "INSERT OR \(onCollision) INTO '\(reader.type)'"
        
        query += " (" + escapedProperties.joinWithSeparator(", ") + ")"
        
        query += " VALUES (" + placeholders.joinWithSeparator(", ") + ")"
        
        let parameters: [SQLiteValue?] = properties.map { reader.storeableValues[$0] as? SQLiteValue }
        
        return SQLiteQuery(query: query, parameters: parameters)
    }
    
    // MARK: Select
    
    func selectQueryForType(type: Storeable.Type, andFilter filter: SQLiteFilterStatement?, sorting: Sorting, limit: Int?, offset: Int?) -> SQLiteQuery {
        return buildSelectQueryForType(type, andFilter: filter, sorting: sorting, limit: limit, offset: offset)
    }
    
    func buildSelectQueryForType(type: Storeable.Type, andFilter filter: SQLiteFilterStatement?, sorting: Sorting, limit: Int?, offset: Int?) -> SQLiteQuery {
        
        var query = "SELECT * FROM '\(type)'"
        var parameters: [SQLiteValue?] = []
        
        if let filter = filter {
            query += " WHERE \(filter.statement)"
            parameters += filter.parameters.asType(SQLiteValue.self)
        }
        
        query += " \(orderByComponentForSorting(sorting))"
    
        let (limitComponenet, limitParameters) = limitComponentForLimit(limit, andOffset: offset)
        
        query      += limitComponenet
        parameters += limitParameters.asType(SQLiteValue.self)
        
        
        return SQLiteQuery(query: query, parameters: parameters)
    }
    
    private func orderByComponentForSorting(sorting: Sorting) -> String {
        switch sorting {
        case .ascending(let property):
            return " ORDER BY \(property) ASC"
        case .descending(let property):
            return " ORDER BY \(property) DESC"
        case .none:
            return ""
        }
    }
    
    private func limitComponentForLimit(limit: Int?, andOffset offset: Int?) -> (String, [SQLiteValue?]) {
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
    
    func createIndexQueryFor(index: _IndexInstanceType) -> SQLiteQuery {
        return buildCreateIndexQueryFor(index)
    }
    
    func buildCreateIndexQueryFor(index: _IndexInstanceType) -> SQLiteQuery {
        let name = IndexingUtils.nameForIndex(index)
        
        var query = "CREATE INDEX IF NOT EXISTS '\(name)' ON '\(index.type)' (\(index.properties.joinWithSeparator(", ")))"
        var parameters: [SQLiteValue?] = []
        
        if let filter = index.filters as? SQLiteFilterStatement {
            query += " WHERE \(filter.statement)"
            parameters += filter.parameters.asType(SQLiteValue.self)
        }
        
        return SQLiteQuery(query: query, parameters: parameters)
    }
    
    // MARK: - Delete 
    
    func deleteQueryForType(type: Storeable.Type, withFilter filter: SQLiteFilterStatement?) -> SQLiteQuery {
        if let query = cachedQueryForType(type, andOperation: .delete) {
            return query
        }
        
        let query = buildDeleteQueryForType(type, withFilter: filter)
        
        return query
    }
    
    func buildDeleteQueryForType(type: Storeable.Type, withFilter filter: SQLiteFilterStatement?) -> SQLiteQuery {
        var query = "DELETE FROM \(type)"
        var parameters: [SQLiteValue?] = []
        
        
        if let filter = filter {
            query += " WHERE \(filter.statement)"
            parameters += filter.parameters.asType(SQLiteValue.self)
        }
        
        return SQLiteQuery(query: query, parameters: parameters)
    }
    
    // MARK: - Cache
    
    private func cachedQueryForType(type: Storeable.Type, andOperation operation: Operation) -> SQLiteQuery? {
        return queryCache["\(operation.rawValue):\(type)"]
    }
    
    private func cacheQuery(query: SQLiteQuery, forType type: Storeable.Type, andOperation operation: Operation) {
        queryCache["\(operation.rawValue):\(type)"] = query
    }
}
