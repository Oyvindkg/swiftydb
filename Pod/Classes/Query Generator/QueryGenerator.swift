//
//  QueryBuilder.swift
//  SQLiteGenerator
//
//  Created by Øyvind Grimnes on 26/12/15.
//

import TinySQLite

// TODO: Clean this generator mess up and create a separate module

public class QueryGenerator {
    
    
    public class func createTableQueryForTable(table: Table) -> Query {
        var statement = table.isTemporary ? "CREATE TEMPORARY TABLE " : "CREATE TABLE "
        statement += " \(table.name) (\n"
        
        var primaryKeys: Set<String> = []
        var unique: Set<String> = []
        
        let columnDefinitions = table.columns.values.map { (column) -> String in
            var columnDefinition = " \(column.name) \(column.datatype!.rawValue) "
            
            if column.isPrimaryKey {
                primaryKeys.insert(column.name)
            } else if column.isUnique {
                unique.insert(column.name)
            }
            
            if column.isNotNull {
                columnDefinition += " NOT NULL ON CONFLICT \(column.conflictResolution.rawValue)"
            }
            
            return columnDefinition
        }
        
        statement += columnDefinitions.joinWithSeparator(", \n")
        if !primaryKeys.isEmpty {
            statement += ",\n PRIMARY KEY (\(primaryKeys.joinWithSeparator(" ,"))) ON CONFLICT \(table.conflictResolution.rawValue)"
        }
        
        if !unique.isEmpty {
            statement += ",\n UNIQUE (\(unique.joinWithSeparator(" ,"))) ON CONFLICT \(table.conflictResolution.rawValue)"
        }
        
        statement += "\n)"
        
        return Query(query: statement, values: nil)
    }
    
    
    
    public class func insertQueryForTable(table: Table) -> Query {
        var statement = "INSERT OR \(table.conflictResolution.rawValue) INTO "
        statement += table.identifier
        statement += " (\(table.columns.values.map({"\($0.name)"}).joinWithSeparator(", "))) "
        statement += " VALUES (\(table.columns.values.map({_ in "?"}).joinWithSeparator(", ")));"
        
        let values: [SQLiteValue?] = table.columns.map { (_, column) in
            column.bindingValue
        }
        
        return Query(query: statement, values: values)
    }
    
    
    public class func updateQueryForTable(table: Table) -> Query {
        var statement = "UPDATE OR \(table.conflictResolution.rawValue) "
        statement += table.identifier
        statement += " SET \(table.columns.values.map({"\($0.name) = ?"}).joinWithSeparator(", ")) "
        
        let filters: [String] = table.relationships.map({$0.statement()})
        if !filters.isEmpty {
            statement += " \nWHERE \(filters.joinWithSeparator(" AND "))"
        }
        
        let values: [SQLiteValue?] = table.columns.map { (_, column) in
            column.bindingValue
        }
        
        return Query(query: statement, values: values)
    }
    
    
    
    public class func selectForTable(table: Table) -> Query {
        return selectForTables([table])
    }
    
    public class func selectForTables(table: Table, _ moreTables: Table...) -> Query {
        return selectForTables([table] + moreTables)
    }
    
    public class func selectForTables(tables: [Table]) -> Query {
        var statement = "SELECT ALL "
        
        let columns = tables.filter({$0.shouldSelectAll}).map({$0.identifier + ".*"}) + tables.flatMap({$0.columns.map({$0.1.aliasDefinition ?? $0.1.definition})})
        statement += columns.joinWithSeparator(", ")
        
        statement += " \nFROM \(tables.map({$0.aliasDefinition ?? $0.definition}).joinWithSeparator(", "))"
        
        let filters: [String] = tables.flatMap({$0.relationships.map({$0.statement()})})
        if !filters.isEmpty {
            statement += " \nWHERE \(filters.joinWithSeparator(" AND "))"
        }
        
        statement += ";"
        
        return Query(query: statement, values: nil)
    }
    
    
    
    public class func deleteForTable(table: Table) -> Query {
        
        var statement = "DELETE FROM \(table.name)"
        
        let filters: [String] = table.relationships.map({$0.statement()})
        if !filters.isEmpty {
            statement += " \nWHERE \(filters.joinWithSeparator(" AND "))"
        }
        
        return Query(query: statement, values: nil)
    }
}