//
//  SwiftyDB.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 03/11/15.
//


import Foundation
import TinySQLite

/** All objects in the database must conform to the 'Storable' protocol */
public protocol Storable {
    /** Used to initialize an object to get information about its properties */
    init()
}

/** Implement this protocol to use primary keys */
public protocol PrimaryKeys {
    /**
     Method used to define a set of primary keys for the types table
     
     - returns:  set of property names
     */
    static func primaryKeys() -> Set<String>
}

/** Implement this protocol to ignore arbitrary properties */
public protocol IgnoredProperties {
    /**
     Method used to define a set of ignored properties
     
     - returns:  set of property names
     */
    static func ignoredProperties() -> Set<String>
}


/** A class wrapping an SQLite3 database abstracting the creation of tables, insertion, update, and retrieval */
public class SwiftyDB {
    
    /** The database queue that will be used to access the database */
    private let databaseQueue : DatabaseQueue
    
    /** Path to the database that should be used */
    private let path: String
    
    /** A cache containing existing table names */
    private var existingTables: Set<String> = []
    
//    MARK: -
    
    /**
    Creates a new instance of SwiftyDB using a database in the documents directory. If the database does not exist, it will be created.
    
    - parameter databaseName:  name of the database
    
    - returns:                 an instance of SwiftyDB
    */
    
    public init(databaseName: String) {
        let documentsDir : String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
        path = documentsDir+"/\(databaseName).sqlite"
        
        databaseQueue = DatabaseQueue(path: path)
    }
    
    
// MARK: - Database operations
    
    /**
    Add an object to the database
    
    - parameter object:     object to be added to the database
    - parameter update:     indicates whether the record should be updated if already present
    
    - returns:              Result type indicating the success of the query
    */
    
    public func addObject <S: Storable> (object: S, update: Bool = true) -> Result<Bool> {
        return self.addObjects([object], update: update)
    }
    
    /**
     Add objects to the database
     
     - parameter objects:    objects to be added to the database
     - parameter update:     indicates whether the record should be updated if already present
     
     - returns:              Result type indicating the success of the query
     */
    
    public func addObjects <S: Storable> (objects: [S], update: Bool = true) -> Result<Bool> {
        guard objects.count > 0 else {
            return Result.Success(true)
        }
        
        do {
            if !(try tableExistsForType(S)) {
                createTableForTypeRepresentedByObject(objects.first!)
            }
            
            let insertStatement = StatementGenerator.insertStatementForType(S.self, update: update)
            
            try databaseQueue.transaction { (database) -> Void in
                let statement = try database.prepare(insertStatement)
                
                defer {
                    /* If an error occurs, try to finalize the statement */
                    let _ = try? statement.finalize()
                }
                
                for object in objects {
                    let data   = self.dataFromObject(object)
                    try statement.executeUpdate(data)
                }
            }
        } catch let error {
            return Result.Error(error)
        }
        
        return Result.Success(true)
    }
    
    /**
     Add objects to the database
     
     - parameter object:        object to be added to the database
     - parameter moreObjects:   more objects to be added to the database
     
     - returns:                 Result type indicating the success of the query
     */
    
    public func addObjects <S: Storable> (object: S, _ moreObjects: S...) -> Result<Bool> {
        return addObjects([object] + moreObjects)
    }
    
    /**
     Remove objects of a specified type, matching a set of filters, from the database
     
     - parameter filters:   dictionary containing the filters identifying objects to be deleted
     - parameter type:      type of the objects to be deleted
     
     - returns:             Result type indicating the success of the query
     */
    
    public func deleteObjectsForType (type: Storable.Type, matchingFilters filters: Filter? = nil) -> Result<Bool> {
        do {
            guard try tableExistsForType(type) else {
                return Result.Success(true)
            }
            
            let deleteStatement = StatementGenerator.deleteStatementForType(type, matchingFilters: filters)
            
            try databaseQueue.database { (database) -> Void in
                try database.prepare(deleteStatement)
                            .executeUpdate(filters?.parameters() ?? [:])
                            .finalize()
            }
        } catch let error {
            return .Error(error)
        }
        
        return .Success(true)
    }
    
    /**
     Get data for a specified type, matching a set of filters, from the database
     
     - parameter filters:   dictionary containing the filters identifying objects to be retrieved
     - parameter type:      type of the objects for which to retrieve data
     
     - returns:             Result type wrapping an array with the dictionaries representing objects, or an error if unsuccessful
     */
    
    public func dataForType <S: Storable> (type: S.Type, matchingFilters filters: Filter? = nil) -> Result<[[String: SQLiteValue?]]> {
        
        var results: [[String: SQLiteValue?]] = []
        do {
            guard try tableExistsForType(type) else {
                return Result.Success([])
            }
            
            /* Generate statement */
            let query = StatementGenerator.selectStatementForType(type, matchingFilters: filters)
            
            try databaseQueue.database { (database) -> Void in
                let statement = try! database.prepare(query)
                                             .execute(filters?.parameters() ?? [:])
                
                /* Create a dummy object used to extract property data */
                let object = type.init()
                let objectPropertyData = PropertyData.validPropertyDataForObject(object)
                
                results = statement.map { row in
                    self.parsedDataForRow(row, forPropertyData: objectPropertyData)
                }
                
                try statement.finalize()
            }
        } catch let error {
            return .Error(error)
        }
        
        return .Success(results)
    }
    
    
    
// MARK: - Private functions
    
    /**
    Creates a new table for the specified type based on the provided column definitions
    
    The parameter is an object, instead of a type, to avoid forcing the user to implement initialization methods such as 'init'
    
    - parameter type:   type of objects data in the table represents
    
    - returns:          Result type indicating the success of the query
    */
    
    private func createTableForTypeRepresentedByObject <S: Storable> (object: S) -> Result<Bool> {
        
        let statement = StatementGenerator.createTableStatementForTypeRepresentedByObject(object)
        
        do {
            try databaseQueue.database({ (database) -> Void in
                try database.prepare(statement)
                            .executeUpdate()
                            .finalize()
            })
        } catch let error {
            return .Error(error)
        }
        
        existingTables.insert(tableNameForType(S))
        
        return .Success(true)
    }
    
    /**
     Serialize the object
     
     - parameter object:    object containing the data to be extracted
     
     - returns:             dictionary containing the data from the object
     */
    
    private func dataFromObject (object: Storable) -> [String: SQLiteValue?] {
        var dictionary: [String: SQLiteValue?] = [:]
        
        for propertyData in PropertyData.validPropertyDataForObject(object) {
            dictionary[propertyData.name!] = propertyData.value
        }
        
        return dictionary
    }
    
    /**
     Check whether a table representing a type exists, or not
     
     - parameter type:  type implementing the Storable protocol
     
     - returns:         boolean indicating if the table exists
     */
    
    private func tableExistsForType(type: Storable.Type) throws -> Bool {
        let tableName = tableNameForType(type)
        
        var exists: Bool = existingTables.contains(tableName)
        
        /* Return true if the result is cached */
        guard !exists else {
            return exists
        }
        
        try databaseQueue.database({ (database) in
            exists = try database.containsTable(tableName)
        })
        
        /* Cache the result */
        if exists {
            existingTables.insert(tableName)
        }
        
        return exists
    }
    
    /**
     Used to create name of the table representing a type
     
     - parameter type:  type for which to generate a table name
     
     - returns:         table name as a String
     */
    private func tableNameForType(type: Storable.Type) -> String {
        return String(type)
    }
    
    /**
     Create a dictionary with values matching datatypes based on some property data
     
     - parameter row:           row, in the form of a wrapped SQLite statement, from which to receive values
     - parameter propertyData:  array containing information about property names and datatypes
     
     - returns:                 dictionary containing data of types matching the properties of the target type
     */
    
    private func parsedDataForRow(row: Statement, forPropertyData propertyData: [PropertyData]) -> [String: SQLiteValue?] {
        var rowData: [String: SQLiteValue?] = [:]
        
        for propertyData in propertyData {
            rowData[propertyData.name!] = valueForProperty(propertyData, inRow: row)
        }
        
        return rowData
    }
    
    /**
     Retrieve the value for a property with the correct datatype
     
     - parameter propertyData:  object containing information such as property name and type
     - parameter row:           row, in the form of a wrapped SQLite statement, from which to retrieve the value
     
     - returns:                 optional value for the property
     */
    
    private func valueForProperty(propertyData: PropertyData, inRow row: Statement) -> SQLiteValue? {
        if row.typeForColumn(propertyData.name!) == .Null {
            return nil
        }
        
        switch propertyData.type {
        case is NSDate.Type:    return row.dateForColumn(propertyData.name!)
        case is NSData.Type:    return row.dataForColumn(propertyData.name!)
        case is NSNumber.Type:  return row.numberForColumn(propertyData.name!)
            
        case is String.Type:    return row.stringForColumn(propertyData.name!)
        case is NSString.Type:  return row.nsstringForColumn(propertyData.name!)
        case is Character.Type: return row.characterForColumn(propertyData.name!)
            
        case is Double.Type:    return row.doubleForColumn(propertyData.name!)
        case is Float.Type:     return row.floatForColumn(propertyData.name!)
            
        case is Int.Type:       return row.integerForColumn(propertyData.name!)
        case is Int8.Type:      return row.integer8ForColumn(propertyData.name!)
        case is Int16.Type:     return row.integer16ForColumn(propertyData.name!)
        case is Int32.Type:     return row.integer32ForColumn(propertyData.name!)
        case is Int64.Type:     return row.integer64ForColumn(propertyData.name!)
        case is UInt.Type:      return row.unsignedIntegerForColumn(propertyData.name!)
        case is UInt8.Type:     return row.unsignedInteger8ForColumn(propertyData.name!)
        case is UInt16.Type:    return row.unsignedInteger16ForColumn(propertyData.name!)
        case is UInt32.Type:    return row.unsignedInteger32ForColumn(propertyData.name!)
        case is UInt64.Type:    return row.unsignedInteger64ForColumn(propertyData.name!)
            
        case is Bool.Type:      return row.boolForColumn(propertyData.name!)
            
        default:                return nil
        }
    }
}



extension SwiftyDB {
    
// MARK: - Dynamic initialization
    
    /**
     Get objects of a specified type, matching a set of filters, from the database
     
     - parameter filters:   dictionary containing the filters identifying objects to be retrieved
     - parameter type:      type of the objects to be retrieved
     
     - returns:             Result wrapping the objects, or an error, if unsuccessful
     */
    
    public func objectsForType <D where D: Storable, D: NSObject> (type: D.Type, matchingFilters filters: Filter? = nil) -> Result<[D]> {
        let dataResults = dataForType(D.self, matchingFilters: filters)
        
        if !dataResults.isSuccess {
            return .Error(dataResults.error!)
        }
        
        let objects: [D] = dataResults.value!.map {
            objectWithData($0, forType: D.self)
        }
        
        return .Success(objects)
    }
    
    /**
     Creates a new dynamic object of a specified type and populates it with data from the provided dictionary
     
     - parameter data:   dictionary containing data
     - parameter type:   type of object the data represents
     
     - returns:          object of the provided type populated with the provided data
     */
    
    private func objectWithData <D where D: Storable, D: NSObject> (data: [String: SQLiteValue?], forType type: D.Type) -> D {
        let object = (type as NSObject.Type).init() as! D
        
        var validData: [String: AnyObject] = [:]
        
        data.forEach { (name, value) -> () in
            if let validValue = value as? AnyObject {
                validData[name] = validValue
            }
        }
        
        object.setValuesForKeysWithDictionary(validData)

        return object
    }
}