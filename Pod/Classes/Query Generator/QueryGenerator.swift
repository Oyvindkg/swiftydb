//
//  QueryBuilder.swift
//  SQLiteGenerator
//
//  Created by Øyvind Grimnes on 26/12/15.
//

import TinySQLite

// TODO: Clean this generator mess up and create a separate module

internal class QueryGenerator {
    
    internal class func createTableQueryForTable(table: Table) -> Query {
        var statement = "CREATE " + table.type.rawValue + " TABLE " + table.name + " ("
        
        /* Create column definitions */
        let columnDefinitions = table.columns.values.map { (column) -> String in
            var columnDefinition = " \(column.name) \(column.datatype!.rawValue) "
            
            if column.isNotNull {
                columnDefinition += " NOT NULL ON CONFLICT " + column.conflictResolution.rawValue
            }
            
            return columnDefinition
        }
        
        statement += columnDefinitions.joinWithSeparator(",")
        
        /* Define primary keys and unique keys */
        for columnType in [ColumnType.PrimaryKey, ColumnType.Unique] {
            if let typeKeysStatement = compoundKeysForTable(table, type: columnType) {
                statement += ", " + typeKeysStatement
            }
        }
        
        /* End the statement */
        statement += ")"
        
        return Query(query: statement, values: nil)
    }
    
    internal class func insertQueryForTable(table: Table) -> Query {
        var statement = "INSERT OR " + table.conflictResolution.rawValue + " INTO " + table.identifier
        
        var columnNames: [String] = []
        var columnValues: [SQLiteValue?] = []
        
        table.columns.values.forEach {
            columnNames.append($0.name)
            columnValues.append($0.bindingValue)
        }
        
        /* Columns to be inserted */
        statement += " (" + columnNames.joinWithSeparator(", ") + ") "
        
        /* Values to be inserted */
        let valuePlaceholders = Array<String>(count: columnNames.count, repeatedValue: "?")
        statement += "VALUES (" + valuePlaceholders.joinWithSeparator(", ") + ")"
        
        return Query(query: statement, values: columnValues)
    }
    
    
    internal class func updateQueryForTable(table: Table) -> Query {
        var statement = "UPDATE OR " + table.conflictResolution.rawValue + table.identifier
        
        let assignments  = table.columns.values.map {"\($0.name) = ?"}
        statement += " SET " + assignments.joinWithSeparator(", ") + " "
        
        statement += self.whereStatementForRelationships(table.relationships) ?? ""

        let values: [SQLiteValue?] = table.columns.map { (_, column) in
            column.bindingValue
        }
        
        return Query(query: statement, values: values)
    }
    
    internal class func selectForTable(table: Table) -> Query {
        return selectForTables([table])
    }
    
    internal class func selectForTables(table: Table, _ moreTables: Table...) -> Query {
        return selectForTables([table] + moreTables)
    }
    
    internal class func selectForTables(tables: [Table]) -> Query {
        var statement = "SELECT ALL "
        
        let columns = tables.filter({$0.shouldSelectAll}).map({$0.identifier + ".*"}) + tables.flatMap({$0.columns.map({$0.1.definition})})
        statement += columns.joinWithSeparator(", ")
        
        statement += " FROM " + tables.map {$0.definition}.joinWithSeparator(", ") + " "
        
        let relationships = tables.reduce([]) { (memory, table) in
            return memory + table.relationships
        }
        
        statement += self.whereStatementForRelationships(relationships) ?? ""
        
        return Query(query: statement, values: nil)
    }
    
    
    // TODO: Use bindings here
    internal class func deleteForTable(table: Table) -> Query {
        var statement = "DELETE FROM \(table.name) "
        statement += whereStatementForRelationships(table.relationships) ?? ""
        
        return Query(query: statement, values: nil)
    }
    
    
    
    
    private class func whereStatementForRelationships(relationships: [Relationship]) -> String? {
        guard relationships.count > 0 else {
            return nil
        }
        
        let components: [String] = relationships.map { $0.statement() }
        
        return  "WHERE \(components.joinWithSeparator(" AND "))"
    }
    
    private class func compoundPrimaryKeysForTable(table: Table) -> String? {
        return self.compoundKeysForTable(table, type: .PrimaryKey)
    }
    
    private class func compoundUniqueKeysForTable(table: Table) -> String? {
        return self.compoundKeysForTable(table, type: .Unique)
    }
    
    private class func compoundKeysForTable(table: Table, type: ColumnType) -> String? {
        let columnNames: [String] = table.columns.values.filter {$0.type == type} .map {$0.name}
        
        guard columnNames.count > 0 else {
            return nil
        }
        
        return type.rawValue + " (" + columnNames.joinWithSeparator(" ,") + ") ON CONFLICT " + table.conflictResolution.rawValue
    }
}