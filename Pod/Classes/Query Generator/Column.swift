//
//  Column.swift
//  SQliteGenerator
//
//  Created by Øyvind Grimnes on 27/12/15.
//

import TinySQLite

enum ColumnRelationship: String {
    case GreaterThan =      ">"
    case LessThan =         "<"
    case EqualTo =          "="
    case ContainedIn =      "IN"
}

public func ==(lhs: Column, rhs: Column) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

public class Column {
    internal var name: String
    internal var columnAlias: String?
    internal var bindingValue: SQLiteValue?
    internal var conflictResolution: SQLiteConflictResolution = .Abort
    
    internal var isAutoincrement: Bool
    
    internal let table: Table
    internal var datatype: SQLiteDatatype?
    internal var isPrimaryKey, isUnique, isNotNull: Bool
    
    
    internal init(name: String, alias: String? = nil, datatype: SQLiteDatatype? = nil, primaryKey: Bool = false, notNull: Bool = false, unique: Bool = false, autoincrement: Bool = false, table: Table) {
        self.name = name
        self.datatype = datatype
        self.table = table
        columnAlias = alias
        isPrimaryKey = primaryKey
        isUnique = unique
        isNotNull = notNull
        isAutoincrement = autoincrement
    }
}

// MARK: - Hashable
extension Column: Hashable {
    public var hashValue: Int {
        return identifier.hashValue
    }
}

// MARK: - Convenience properties
extension Column {
    /** The keypath for the column: 'table'.'name' */
    internal var fullName: String {
        return "\(table.identifier).\(name)"
    }
    
    /** Alias if possible, else the full name */
    internal var identifier: String {
        return columnAlias ?? fullName
    }
    
    /** Defining alias as: 'fullName' AS 'alias' */
    internal var aliasDefinition: String? {
        return columnAlias != nil ? "\(fullName) AS \(columnAlias!)" : nil
    }
    
    /** Returns alias definition if alias is defined, else full name */
    internal var definition: String {
        return fullName
    }
}


// MARK: - WHERE
extension Column {
    public func greaterThan(column: Column) -> Column {
        table.addRelationship(.GreaterThan, betweenColumn: self, andColumn: column)
        return self
    }
    
    public func greaterThan(value: SQLiteValue) -> Column {
        table.addRelationship(.GreaterThan, betweenColumn: self, andValue: value)
        return self
    }
    
    public func lessThan(column: Column) -> Column {
        table.addRelationship(.LessThan, betweenColumn: self, andColumn: column)
        return self
    }
    
    public func lessThan(value: SQLiteValue) -> Column {
        table.addRelationship(.LessThan, betweenColumn: self, andValue: value)
        return self
    }
    
    public func equalTo(column: Column) -> Column {
        table.addRelationship(.EqualTo, betweenColumn: self, andColumn: column)
        return self
    }
    
    public func equalTo(value: SQLiteValue?) -> Column {
        table.addRelationship(.EqualTo, betweenColumn: self, andValue: value)
        return self
    }
    
    public func containedIn(values: [SQLiteValue]) -> Column {
        table.addRelationship(.ContainedIn, betweenColumn: self, andValue: values)
        return self
    }
}

// MARK: - SELECT
extension Column {
    public func alias(alias: String) -> Column {
        self.columnAlias = alias
        return self
    }
}

// MARK: - CREATE
extension Column {
    
    public func autoincrement() -> Column {
        isAutoincrement = true
        return self
    }
    
    public func onConflict(resolution: SQLiteConflictResolution) -> Column {
        conflictResolution = resolution
        return self
    }
    
    public func type(datatype: SQLiteDatatype) -> Column {
        self.datatype = datatype
        return self
    }
    
    public func primaryKey() -> Column {
        isPrimaryKey = true
        return self
    }
    
    public func unique() -> Column {
        isUnique = true
        return self
    }
    
    public func notNull() -> Column {
        isNotNull = true
        return self
    }
}

//MARK: - INSERT, UPDATE
extension Column {
    func value(value: SQLiteValue?) -> Column {
        bindingValue = value
        return self
    }
}
