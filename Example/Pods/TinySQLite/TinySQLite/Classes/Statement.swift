//
//  Statement.swift
//  TinySQLite
//
//  Created by Øyvind Grimnes on 25/12/15.
//

import sqlite3

public enum Datatype: String {
    case Text       = "TEXT"
    case Integer    = "INTEGER"
    case Real       = "REAL"
    case Blob       = "BLOB"
    case Numeric    = "NUMERIC"
    case Null       = "NULL"
}

//TODO: Dates should be stored as ISO strings to preserve time xone information etc.
public class Statement {
    fileprivate var statementHandle: OpaquePointer?
    
    public let query: String
    
    var isBusy: Bool {
        return NSNumber(value: sqlite3_stmt_busy(statementHandle) as Int32).boolValue
    }
    
    lazy var indexToNameMapping: [Int32: String] = {
        var mapping: [Int32: String] = [:]
        
        for index in 0..<sqlite3_column_count(self.statementHandle) {
            let name =  NSString(utf8String: sqlite3_column_name(self.statementHandle, index)) as! String
            mapping[index] = name
        }
        
        return mapping
    }()
    
    lazy var nameToIndexMapping: [String: Int32] = {
        var mapping: [String: Int32] = [:]
        
        for index in 0..<sqlite3_column_count(self.statementHandle) {
            let name =  NSString(utf8String: sqlite3_column_name(self.statementHandle, index)) as! String
            mapping[name] = index
        }
        
        return mapping
    }()
    
    
    public init(_ query: String, handle: OpaquePointer? = nil) {
        self.query = query
        self.statementHandle = handle
    }
    
    /** Next row in results */
    public func step() throws -> Bool {
        let result = sqlite3_step(statementHandle)
        
        try ResultHandler.verifyResult(code: result)
        
        if result == SQLITE_DONE {
            return false
        }
        
        return true
    }
    
    /** Clear memory */
    public func finalize() throws {
        try ResultHandler.verifyResult(code: sqlite3_finalize(statementHandle))
    }
    
    /** ID of the last row inserted */
    public func lastInsertRowId() -> Int? {
        let id = Int(sqlite3_last_insert_rowid(statementHandle))
        
        return id > 0 ? id : nil
    }
    
    // MARK: - Execute query
    
    /**
     Execute a write-only update with an array of variables to bind to placeholders in the prepared query
     
     - parameter value:  array of values that will be bound to parameters in the prepared query
     
     - returns:          `self`
     */
    @discardableResult public func executeUpdate(withParameters parameters: [SQLiteValue?] = []) throws -> Statement {
        _ = try execute(withParameters: parameters)
        _ = try step()
        
        return self
    }
    
    /**
     Execute a write-only update with a dictionary of variables to bind to placeholders in the prepared query
     
     - parameter namedValue: dictionary of values that will be bound to parameters in the prepared query
     
     - returns:              `self`
     */
    @discardableResult public func executeUpdate(withParameterMapping parameterMapping: [String: SQLiteValue?]) throws -> Statement {
        _ = try execute(withParameterMapping: parameterMapping)
        _ = try step()
        
        return self
    }
    
    /**
    Execute a query with a dictionary of variables to bind to placeholders in the prepared query
    Finalize the statement when you are done by calling `finalize()`
     
    - parameter namedValue: dictionary of values that will be bound to parameters in the prepared query
     
    - returns:              `self`
    */
    public func execute(withParameterMapping parameterMapping: [String: SQLiteValue?]) throws -> Statement {
        try bind(parameterMapping: parameterMapping)
        
        return self
    }
    
    /**
    Execute a query with an array of variables to bind to placeholders in the prepared query
    Finalize the statement when you are done by calling `finalize()`
     
    - parameter value:  array of values that will be bound to parameters in the prepared query
     
    - returns:          `self`
    */
    public func execute(withParameters parameters: [SQLiteValue?] = []) throws -> Statement {
        try bind(parameters)
        
        return self
    }
    
    // MARK: - Internal methods
    
    fileprivate func reset() throws {
        try ResultHandler.verifyResult(code: sqlite3_reset(statementHandle))
    }
    
    fileprivate func clearBindings() throws {
        guard statementHandle != nil else {
            return
        }
        
        try ResultHandler.verifyResult(code: sqlite3_clear_bindings(statementHandle))
    }
    
    internal func prepareForDatabase(_ databaseHandle: OpaquePointer) throws {
        try ResultHandler.verifyResult(code: sqlite3_prepare_v2(databaseHandle, query, -1, &statementHandle, nil))
    }
    
    fileprivate func bind(parameterMapping: [String: SQLiteValue?]) throws {
        
        let totalBindCount = sqlite3_bind_parameter_count(statementHandle)
        
        var parameters: [SQLiteValue?] = Array(repeating: nil, count: Int(totalBindCount))
        
        for (name, value) in parameterMapping {
            let index = sqlite3_bind_parameter_index(statementHandle, ":\(name)")
            
            parameters[index-1] = value
        }
        
        try bind(parameters)
    }
    
    fileprivate func bind(_ parameters: [SQLiteValue?]) throws {
        try reset()
        try clearBindings()
        
        let totalBindCount = sqlite3_bind_parameter_count(statementHandle)
        
        var bindCount: Int32 = 0
        
        for (index, value) in parameters.enumerated() {
            try bind(value: value, to: Int32(index+1))
            
            bindCount += 1
        }
        
        if bindCount != totalBindCount {
            throw TinyError.numberOfBindings
        }
    }
    
    // MARK: - Private methods
    
    fileprivate func bind(value: SQLiteValue?, to index: Int32) throws {
        if value == nil {
            try ResultHandler.verifyResult(code: sqlite3_bind_null(statementHandle, index))
            return
        }
        
        let result: Int32
        
        switch value {
            
            /* Bind special values */
        case let dateValue as Date:
            result = sqlite3_bind_double(statementHandle, index, dateValue.timeIntervalSince1970)
            
        case let dataValue as Data:
            if dataValue.count == 0 {
                print("[ WARNING: Data values with zero bytes are treated as NULL by SQLite ]")
            }
            
            result = sqlite3_bind_blob(statementHandle, index, (dataValue as NSData).bytes, Int32(dataValue.count), SQLITE_TRANSIENT)
            
        case let numberValue as NSNumber:
            result = try bind(number: numberValue, forIndex: index)
            
            /* Bind integer values */
        case let integerValue as Int:
            result = sqlite3_bind_int64(statementHandle, index, Int64(integerValue))
        case let integerValue as UInt:
            result = sqlite3_bind_int64(statementHandle, index, Int64(integerValue))
        case let integerValue as Int8:
            result = sqlite3_bind_int64(statementHandle, index, Int64(integerValue))
        case let integerValue as Int16:
            result = sqlite3_bind_int64(statementHandle, index, Int64(integerValue))
        case let integerValue as Int32:
            result = sqlite3_bind_int64(statementHandle, index, Int64(integerValue))
        case let integerValue as Int64:
            result = sqlite3_bind_int64(statementHandle, index, Int64(integerValue))
        case let integerValue as UInt8:
            result = sqlite3_bind_int64(statementHandle, index, Int64(integerValue))
        case let integerValue as UInt16:
            result = sqlite3_bind_int64(statementHandle, index, Int64(integerValue))
        case let integerValue as UInt32:
            result = sqlite3_bind_int64(statementHandle, index, Int64(integerValue))
            
            /* Bind boolean values */
        case let boolValue as Bool:
            result = sqlite3_bind_int64(statementHandle, index, boolValue ? 1 : 0)
            
            /* Bind real values */
        case let floatValue as Float:
            result = sqlite3_bind_double(statementHandle, index, Double(floatValue))
        case let doubleValue as Double:
            result = sqlite3_bind_double(statementHandle, index, doubleValue)
            
            /* Bind text values */
        case let stringValue as String:
            result = sqlite3_bind_text(statementHandle, index, stringValue, -1, SQLITE_TRANSIENT)
        case let stringValue as NSString:
            result = sqlite3_bind_text(statementHandle, index, stringValue.utf8String, -1, SQLITE_TRANSIENT)
        case let characterValue as Character:
            result = sqlite3_bind_text(statementHandle, index, String(characterValue), -1, SQLITE_TRANSIENT)
            
        default:
            result = sqlite3_bind_text(statementHandle, index, value as! String, -1, SQLITE_TRANSIENT)
        }
        
        try ResultHandler.verifyResult(code: result)
    }
    
    /** Bind the value wrapped in an NSNumber object based on the values type */
    fileprivate func bind(number: NSNumber, forIndex index: Int32) throws -> Int32 {
        
        let type = String(cString: number.objCType)
        
        if type.isEmpty {
            throw TinyError.bindingType
        }
        
        let result: Int32
        
        switch type {
        case "c":
            result = sqlite3_bind_int64(statementHandle, index, Int64(number.int8Value))
        case "i":
            result = sqlite3_bind_int64(statementHandle, index, Int64(number.int32Value))
        case "s":
            result = sqlite3_bind_int64(statementHandle, index, Int64(number.int16Value))
        case "l":
            result = sqlite3_bind_int64(statementHandle, index, Int64(number.intValue))
        case "q":
            result = sqlite3_bind_int64(statementHandle, index, number.int64Value)
        case "C":
            result = sqlite3_bind_int64(statementHandle, index, Int64(number.int8Value))
        case "I":
            result = sqlite3_bind_int64(statementHandle, index, Int64(number.uint32Value))
        case "S":
            result = sqlite3_bind_int64(statementHandle, index, Int64(number.uint16Value))
        case "L":
            result = sqlite3_bind_int64(statementHandle, index, Int64(number.uintValue))
        case "Q":
            result = sqlite3_bind_int64(statementHandle, index, Int64(number.uint64Value))
        case "B":
            result = sqlite3_bind_int64(statementHandle, index, Int64(number.boolValue ? 1 : 0))
        case "f", "d":
            result = sqlite3_bind_double(statementHandle, index, number.doubleValue)
        default:
            result = sqlite3_bind_text(statementHandle, index, number.description, -1, SQLITE_TRANSIENT)
        }
        
        return result
    }
}





//MARK: - Values for indexed columns
extension Statement {
    
    /** Returns the datatype for the column given by an index */
    public func typeForColumn(at index: Int32) -> Datatype? {
        switch sqlite3_column_type(statementHandle, index) {
        case SQLITE_INTEGER:
            return .Integer
        case SQLITE_FLOAT:
            return .Real
        case SQLITE_TEXT, SQLITE3_TEXT:
            return .Text
        case SQLITE_BLOB:
            return .Blob
        case SQLITE_NULL:
            return .Null
        default:
            return nil
        }
    }
    
    /** Returns a value for the column given by the index based on the columns datatype */
    public func valueForColumn(at index: Int32) -> SQLiteValue? {
        let columnType = sqlite3_column_type(statementHandle, index)
        
        switch columnType {
        case SQLITE_INTEGER:
            return integer64ForColumn(at: index)
        case SQLITE_FLOAT:
            return doubleForColumn(at: index)
        case SQLITE_TEXT:
            return stringForColumn(at: index)
        case SQLITE_BLOB:
            return dataForColumn(at: index)
        case SQLITE_NULL:
            fallthrough
        default:
            return nil
        }
    }
    
    /** Returns an integer for the column given by the index */
    public func integerForColumn(at index: Int32) -> Int? {
        if let value = integer64ForColumn(at: index) {
            return Int(value)
        }
        return nil
    }
    
    /** Returns a 64-bit integer for the column given by the index */
    public func integer64ForColumn(at index: Int32) -> Int64? {
        if typeForColumn(at: index) == .Null {
            return nil
        }
        return sqlite3_column_int64(statementHandle, index)
    }
    
    /** Returns a 32-bit integer for the column given by the index */
    public func integer32ForColumn(at index: Int32) -> Int32? {
        if let value = integer64ForColumn(at: index) {
            return Int32(value)
        }
        return nil
    }
    
    /** Returns a 16-bit integer for the column given by the index */
    public func integer16ForColumn(at index: Int32) -> Int16? {
        if let value = integer64ForColumn(at: index) {
            return Int16(value)
        }
        return nil
    }
    
    /** Returns a 8-bit integer for the column given by the index */
    public func integer8ForColumn(at index: Int32) -> Int8? {
        if let value = integer64ForColumn(at: index) {
            return Int8(value)
        }
        return nil
    }
    
    /** Returns an unsigned 64-bit integer for the column given by the index */
    public func unsignedInteger64ForColumn(at index: Int32) -> UInt64? {
        if let value = integer64ForColumn(at: index) {
            return UInt64(value)
        }
        return nil
    }
    
    /** Returns an unsigned 32-bit integer for the column given by the index */
    public func unsignedInteger32ForColumn(at index: Int32) -> UInt32? {
        if let value = integer64ForColumn(at: index) {
            return UInt32(value)
        }
        return nil
    }
    
    /** Returns an unsigned 16-bit integer for the column given by the index */
    public func unsignedInteger16ForColumn(at index: Int32) -> UInt16? {
        if let value = integer64ForColumn(at: index) {
            return UInt16(value)
        }
        return nil
    }
    
    /** Returns an unsigned 8-bit integer for the column given by the index */
    public func unsignedInteger8ForColumn(at index: Int32) -> UInt8? {
        if let value = integer64ForColumn(at: index) {
            return UInt8(value)
        }
        return nil
    }
    
    /** Returns an unsigned integer for the column given by the index */
    public func unsignedIntegerForColumn(at index: Int32) -> UInt? {
        if let value = integer64ForColumn(at: index) {
            return UInt(value)
        }
        return nil
    }
    
    /** Returns a double for the column given by the index */
    public func doubleForColumn(at index: Int32) -> Double? {
        if typeForColumn(at: index) == .Null {
            return nil
        }
        return sqlite3_column_double(statementHandle, index)
    }
    
    /** Returns a float for the column given by the index */
    public func floatForColumn(at index: Int32) -> Float? {
        if let value = doubleForColumn(at: index) {
            return Float(value)
        }
        return nil
    }
    
    /** Returns a boolean for the column given by the index */
    public func boolForColumn(at index: Int32) -> Bool? {
        if let value = integerForColumn(at: index) {
            return value > 0
        }
        return nil
    }
    
    /** Returns a data for the column given by the index */
    public func dataForColumn(at index: Int32) -> Data? {
        if typeForColumn(at: index) == .Null {
            return nil
        }
        
        let byteCount = Int(sqlite3_column_bytes(statementHandle, index))
        
        guard let bytes = sqlite3_column_blob(statementHandle, index) else {
            return nil
        }
        
        return Data(bytes: bytes, count: byteCount)
    }
    
    /** Returns an date for the column given by the index */
    public func dateForColumn(at index: Int32) -> Date? {
        if typeForColumn(at: index) == .Null {
            return nil
        }
        
        guard let timeInterval = doubleForColumn(at: index) else {
            return nil
        }
        
        return Date(timeIntervalSince1970: timeInterval)
    }
    
    /** Returns a string for the column given by the index */
    public func stringForColumn(at index: Int32) -> String? {
        return nsstringForColumn(at: index) as? String
    }
    
    /** Returns a character for the column given by the index */
    public func characterForColumn(at index: Int32) -> Character? {
        return stringForColumn(at: index)?.characters.first
    }
    
    /** Returns a string for the column given by the index */
    public func nsstringForColumn(at index: Int32) -> NSString? {
        return NSString(bytes: sqlite3_column_text(statementHandle, index), length: Int(sqlite3_column_bytes(statementHandle, index)), encoding: String.Encoding.utf8.rawValue)
    }
    
    /** Returns a number for the column given by the index */
    public func numberForColumn(at index: Int32) -> NSNumber? {
        switch sqlite3_column_type(statementHandle, index) {
        case SQLITE_INTEGER:
            return integerForColumn(at: index) as NSNumber?
        case SQLITE_FLOAT:
            return doubleForColumn(at: index) as NSNumber?
        case SQLITE_TEXT:
            if let stringValue = stringForColumn(at: index) {
                return Int(stringValue) as NSNumber?
            }
            return nil
        default:
            return nil
        }
    }
}





//MARK: - Dictionary representation of row
extension Statement {
    
    /** A dictionary representation of the data contained in the row */
    public var dictionary: [String: SQLiteValue?] {
        var dictionary: [String: SQLiteValue?] = [:]
        
        for i in 0..<sqlite3_column_count(statementHandle) {
            dictionary[indexToNameMapping[i]!] = valueForColumn(at: i)
        }
        
        return dictionary
    }
}





//MARK: - Values for named columns
extension Statement {
    
    /** Returns the datatype for the column given by a column name */
    public func typeForColumn(_ name: String) -> Datatype? {
        return typeForColumn(at: nameToIndexMapping[name]!)
    }
    
    /** Returns a value for the column given by the column name, based on the SQLite datatype of the column */
    public func valueForColumn(_ name: String) -> SQLiteValue? {
        return valueForColumn(at: nameToIndexMapping[name]!)
    }
    
    /** Returns an integer for the column given by the column name */
    public func integerForColumn(_ name: String) -> Int? {
        return integerForColumn(at: nameToIndexMapping[name]!)
    }
    
    /** Returns a 64-bit integer for the column given by the column name  */
    public func integer64ForColumn(_ name: String) -> Int64? {
        return  integer64ForColumn(at: nameToIndexMapping[name]!)
    }
    
    /** Returns a 32-bit integer for the column given by the column name  */
    public func integer32ForColumn(_ name: String) -> Int32? {
        return integer32ForColumn(at: nameToIndexMapping[name]!)
    }
    
    /** Returns a 16-bit integer for the column given by the column name  */
    public func integer16ForColumn(_ name: String) -> Int16? {
        return integer16ForColumn(at: nameToIndexMapping[name]!)
    }
    
    /** Returns a 8-bit integer for the column given by the column name  */
    public func integer8ForColumn(_ name: String) -> Int8? {
        return integer8ForColumn(at: nameToIndexMapping[name]!)
    }
    
    /** Returns an unsigned 64-bit integer for the column given by the column name  */
    public func unsignedInteger64ForColumn(_ name: String) -> UInt64? {
        return unsignedInteger64ForColumn(at: nameToIndexMapping[name]!)
    }
    
    /** Returns an unsigned 32-bit integer for the column given by the column name  */
    public func unsignedInteger32ForColumn(_ name: String) -> UInt32? {
        return unsignedInteger32ForColumn(at: nameToIndexMapping[name]!)
    }
    
    /** Returns an unsigned 16-bit integer for the column given by the column name  */
    public func unsignedInteger16ForColumn(_ name: String) -> UInt16? {
        return unsignedInteger16ForColumn(at: nameToIndexMapping[name]!)
    }
    
    /** Returns an unsigned 8-bit integer for the column given by the index */
    public func unsignedInteger8ForColumn(_ name: String) -> UInt8? {
        return unsignedInteger8ForColumn(at: nameToIndexMapping[name]!)
    }
    
    /** Returns an unsigned integer for the column given by the column name  */
    public func unsignedIntegerForColumn(_ name: String) -> UInt? {
        return unsignedIntegerForColumn(at: nameToIndexMapping[name]!)
    }
    
    /** Returns a double for the column given by the column name */
    public func doubleForColumn(_ name: String) -> Double? {
        return doubleForColumn(at: nameToIndexMapping[name]!)
    }
    
    /** Returns a float for the column given by the column name */
    public func floatForColumn(_ name: String) -> Float? {
        return floatForColumn(at: nameToIndexMapping[name]!)
    }
    
    /** Returns a boolean for the column given by the column name */
    public func boolForColumn(_ name: String) -> Bool? {
        return boolForColumn(at: nameToIndexMapping[name]!)
    }
    
    /** Returns data for the column given by the column name */
    public func dataForColumn(_ name: String) -> Data? {
        return dataForColumn(at: nameToIndexMapping[name]!)
    }
    
    /** Returns a date for the column given by the column name */
    public func dateForColumn(_ name: String) -> Date? {
        return dateForColumn(at: nameToIndexMapping[name]!)
    }
    
    /** Returns a string for the column given by the column name */
    public func stringForColumn(_ name: String) -> String? {
        return stringForColumn(at: nameToIndexMapping[name]!)
    }
    
    /** Returns a character for the column given by the column name */
    public func characterForColumn(_ name: String) -> Character? {
        return characterForColumn(at: nameToIndexMapping[name]!)
    }
    
    /** Returns a string for the column given by the column name */
    public func nsstringForColumn(_ name: String) -> NSString? {
        return nsstringForColumn(at: nameToIndexMapping[name]!)
    }
    
    /** Returns a number for the column given by the column name */
    public func numberForColumn(_ name: String) -> NSNumber? {
        return numberForColumn(at: nameToIndexMapping[name]!)
    }
}

// MARK: - Generator and sequence type
extension Statement: IteratorProtocol, Sequence {
    
    /** Easily iterate through the rows. Performs a sqlite_step() and returns itself */
    public func next() -> Statement? {
        do {
            let moreRows = try step()
            return moreRows ? self : nil
        } catch {
            return nil
        }
    }
    
    public func makeIterator() -> Statement {
        let _ = try? self.reset()
        return self
    }
}
