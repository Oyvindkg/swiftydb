//
//  QueryGenerator.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 27/12/15.
//

import Foundation
import TinySQLite

internal class QueryHandler {
    
    internal class func createTableQueryForTypeRepresentedByObject <S: Storable> (object: S) -> Query {
        let tableName =  tableNameForType(S)
        
        let table = Table(tableName)
        
        var primaryKeys: Set<String> = []
        if let primaryKeysType = S.self as? PrimaryKeys.Type {
            primaryKeys = primaryKeysType.primaryKeys()
        }
        
        for propertyData in PropertyData.validPropertyDataForObject(object) {
            let isPrimaryKey = primaryKeys.contains(propertyData.name!)
            
            let datatype = QueryHandler.SQLiteDatatypeForBindingType(propertyData.type!)
            
            let column = table.column(propertyData.name!).type(datatype)
            if isPrimaryKey {
                column.primaryKey()
            } else if !propertyData.isOptional {
                column.notNull()
            }
        }
        
        return QueryGenerator.createTableQueryForTable(table)
    }
    
    internal class func insertQueryForData(data: [String: Binding?], forType type: Storable.Type, update: Bool) -> Query {
        let table = Table(tableNameForType(type))
        table.onConflict(update ? .Replace : .Abort)
        
        for (columnName, value) in data {
            table.column(columnName).value(value)
        }
        
        return QueryGenerator.insertQueryForTable(table)
    }
    
    internal class func selectQueryForType(type: Storable.Type, matchingFilters filters: [String: Binding?]) -> Query {
        
        let tableName =  tableNameForType(type)
        
        let table = Table(tableName)
        
        table.selectAll()
        
        for (columnName, value) in filters {
            table.column(columnName).equalTo(value)
        }
        
        return QueryGenerator.selectForTable(table)
    }
    
    internal class func deleteQueryForType(type: Storable.Type, matchingFilters filters: [String: Binding?]) -> Query {
        
        let tableName =  tableNameForType(type)
        
        let table = Table(tableName)
        
        for (columnName, value) in filters {
            table.column(columnName).equalTo(value)
        }
        
        return QueryGenerator.deleteForTable(table)
    }
    
    
    
    /** Name of the table representing a class */
    private class func tableNameForType(type: Storable.Type) -> String {
        return String(type)
    }
    
    private class func SQLiteDatatypeForBindingType(type: Binding.Type) -> SQLiteDatatype {
        switch type {
        case is Int.Type, is Int8.Type, is Int16.Type, is Int32.Type, is Int64.Type, is UInt8.Type, is UInt16.Type, is UInt32.Type, is UInt64.Type, is Bool.Type:
            return .Integer
        case is Float.Type, is Double.Type, is Float80.Type, is NSDate.Type:
            return .Real
        case is NSNumber.Type:
            return .Numeric
        case is NSData.Type:
            return .Blob
        case is String.Type, is NSString.Type:
            return .Text
        default:
            fatalError("Binding type \(type) is not configured")
        }
    }
}