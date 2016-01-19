//
//  QueryGenerator.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 27/12/15.
//

import Foundation
import TinySQLite

internal enum SQLiteDatatype: String {
    case Text       = "TEXT"
    case Integer    = "INTEGER"
    case Real       = "REAL"
    case Blob       = "BLOB"
    case Numeric    = "NUMERIC"
    case Null       = "NULL"
    
    init?(type: SQLiteValue.Type) {
        switch type {
        case is Int.Type, is Int8.Type, is Int16.Type, is Int32.Type, is Int64.Type, is UInt.Type, is UInt8.Type, is UInt16.Type, is UInt32.Type, is UInt64.Type, is Bool.Type:
            self.init(rawValue: "INTEGER")
        case is Double.Type, is Float.Type, is NSDate.Type:
            self.init(rawValue: "REAL")
        case is NSData.Type:
            self.init(rawValue: "BLOB")
        case is NSNumber.Type:
            self.init(rawValue: "NUMERIC")
        case is String.Type, is NSString.Type, is Character.Type:
            self.init(rawValue: "TEXT")
        default:
            fatalError("DSADSASA")
        }
    }
}

internal class StatementGenerator {
    
    internal class func createTableStatementForTypeRepresentedByObject <S: Storable> (object: S) -> String {
        let tableName =  tableNameForType(S)
        
        var statement = "CREATE TABLE " + tableName + " ("
        
        for propertyData in PropertyData.validPropertyDataForObject(object) {
            statement += "\(propertyData.name!) \(SQLiteDatatype(type: propertyData.type!)!.rawValue)"
            statement += propertyData.isOptional ? "" : " NOT NULL"
            statement += ", "
        }
        
        if S.self is PrimaryKeys.Type {
            let primaryKeysType = S.self as! PrimaryKeys.Type
            statement += "PRIMARY KEY (\(primaryKeysType.primaryKeys().joinWithSeparator(", ")))"
        }
        
        statement += ")"
        
        return statement
    }
    
    internal class func insertStatementForType(type: Storable.Type, update: Bool) -> String {
        var statement = "INSERT OR " + (update ? "REPLACE" : "ABORT") + " INTO " + tableNameForType(type)
        
        let propertyData = PropertyData.validPropertyDataForObject(type.init())
        
        let columns = propertyData.map {$0.name!}
        let namedParameters = columns.map {":" + $0}
        
        /* Columns to be inserted */
        statement += " (" + columns.joinWithSeparator(", ") + ") "
        
        /* Values to be inserted */
        statement += "VALUES (" + namedParameters.joinWithSeparator(", ") + ")"
        
        return statement
    }
    
    internal class func selectStatementForType(type: Storable.Type, matchingFilters filters: Filter?) -> String {
        
        let tableName =  tableNameForType(type)
        
        var statement = "SELECT ALL * FROM \(tableName)"
        
        guard filters != nil else {
            return statement
        }
        
        statement += " " + filters!.whereStatement()
        
        return statement
    }
    
    internal class func deleteStatementForType(type: Storable.Type, matchingFilters filters: Filter?) -> String {
        
        let tableName =  tableNameForType(type)
        
        var statement = "DELETE FROM \(tableName)"
        
        guard filters != nil else {
            return statement
        }
                
        statement += " \(filters!.whereStatement())"
        
        return statement
    }
    
    
    
    /** Name of the table representing a class */
    private class func tableNameForType(type: Storable.Type) -> String {
        return String(type)
    }
    
    private class func SQLiteDatatypeForBindingType(type: SQLiteValue.Type) -> SQLiteDatatype {
        switch type {
        case is Int.Type, is Int8.Type, is Int16.Type, is Int32.Type, is Int64.Type, is UInt.Type, is UInt8.Type, is UInt16.Type, is UInt32.Type, is UInt64.Type, is Bool.Type:
            return .Integer
        case is Float.Type, is Double.Type, is NSDate.Type:
            return .Real
        case is NSNumber.Type:
            return .Numeric
        case is NSData.Type:
            return .Blob
        case is String.Type, is NSString.Type, is Character.Type:
            return .Text
        default:
            fatalError("SQLiteValue type \(type) is not configured")
        }
    }
}