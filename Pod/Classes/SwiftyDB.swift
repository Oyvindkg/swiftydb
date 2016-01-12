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
    init()
}

/** Implement this protocol to use primary keys */
public protocol PrimaryKeys {
    static func primaryKeys() -> Set<String>
}

/** Implement this protocol to ignore arbitrary properties */
public protocol IgnoredProperties {
    static func ignoredProperties() -> Set<String>
}




/** A class wrapping an SQLite3 database abstracting the creation of tables, insertion, update, and retrieval */
public class SwiftyDB {
    
    private let databaseQueue : DatabaseQueue
    private let path: String
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
    
//    MARK: - Database operations
    
    /**
    Add an object to the database
    
    - parameter object:     object to be added to the database
    - parameter update:     indicates whether the record should be updated if already present
    */
    
    public func addObject <S: Storable> (object: S, update: Bool = true) throws {
        try self.addObjects([object], update: update)
    }
    
    /**
     Add objects to the database
     
     - parameter objects:    objects to be added to the database
     - parameter update:     indicates whether the record should be updated if already present
     */
    
    public func addObjects <S: Storable> (objects: [S], update: Bool = true) throws {
        guard objects.count > 0 else {
            return
        }
        
        let tableExists = try tableExistsForType(S)
        if !tableExists {
            try createTableForTypeRepresentedByObject(objects.first!)
        }
        
        try databaseQueue.transaction { (database) -> Void in
            for object in objects {
                let validData   = self.dataFromObject(object)
                let query = QueryHandler.insertQueryForData(validData, forType: S.self, update: update)
                try database.executeUpdate(query)
            }
        }
    }
    
    /**
     Add objects to the database
     
     - parameter object:        object to be added to the database
     - parameter moreObjects:   more objects to be added to the database
     */
    
    public func addObjects <S: Storable> (object: S, _ moreObjects: S...) throws {
        try addObjects([object] + moreObjects)
    }
    
    /**
     Remove objects of a specified type, matching a set of parameters, from the database
     
     - parameter parameters: dictionary containing the parameters identifying objects to be deleted
     - parameter type:       type of the objects to be deleted
     */
    
    public func deleteObjectsForType (type: Storable.Type, matchingFilters filters: [String: SQLiteValue?] = [:]) throws {
        guard try tableExistsForType(type) else {
            return
        }
        
        let query = QueryHandler.deleteQueryForType(type, matchingFilters: filters)
        try databaseQueue.database { (database) -> Void in
            try database.executeUpdate(query)
        }
    }
    
    /**
     Get data for a specified type, matching a set of parameters, from the database
     
     - parameter parameters: dictionary containing the parameters identifying objects to be retrieved
     - parameter type:       type of the objects for which to retrieve data
     
     - returns:              array containing the dictionaries of data representing objects
     */
    
    public func dataForType <S: Storable> (type: S.Type, matchingFilters filters: [String: SQLiteValue?] = [:]) throws -> [[String: SQLiteValue?]] {
        guard try tableExistsForType(type) else {
            return []
        }
        
        /* Generate query */
        let query = QueryHandler.selectQueryForType(type, matchingFilters: filters)
        
        var results: [[String: SQLiteValue?]] = []
        
        try databaseQueue.database { (database) -> Void in
            let statement = try database.executeQuery(query)
            
            /* Create a dummy object used to extract property data */
            let object = type.init()
            let objectPropertyData = PropertyData.validPropertyDataForObject(object)
            
            results = statement.map { row in
                self.parsedDataForRow(row, forPropertyData: objectPropertyData)
            }
        }
        
        return results
    }
    
    
    
//    MARK: - Internal functions
    
    /**
    Creates a new table for the specified type based on the provided column definitions
    
    The parameter is an object, instead of a type, to avoid forcing the user to implement initialization methods such as 'init'
    
    - parameter type:   type of objects data in the table represents
    */
    
    internal func createTableForTypeRepresentedByObject <S: Storable> (object: S) throws {
        
        let query = QueryHandler.createTableQueryForTypeRepresentedByObject(object)
        
        try databaseQueue.database({ (database) -> Void in
            try database.executeUpdate(query)
        })
        
        existingTables.insert(tableNameForType(S))
    }
    
    /**
     Serialize the object
     
     - parameter object:    object containing the data to be extracted
     
     - returns:             dictionary containing the data from the object
     */
    
    internal func dataFromObject (object: Storable) -> [String: SQLiteValue?] {
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
    
    internal func tableExistsForType(type: Storable.Type) throws -> Bool {
        let tableName = tableNameForType(type)
        
        /* Return true if the result is cached */
        guard !existingTables.contains(tableName) else {
            return true
        }
        
        var exists: Bool = false
        
        try databaseQueue.database({ (database) in
            exists = try database.containsTable(tableName)
        })
        
        /* Cache the result */
        if exists {
            existingTables.insert(tableName)
        }
        
        return exists
        
    }
    
    /** Name of the table representing a class */
    internal func tableNameForType(type: Storable.Type) -> String {
        return String(type)
    }
    
    /**
     Create a dictionary with values matching datatypes based on some property data
     
     - parameter row:           row, in the form of a wrapped SQLite statement, from which to receive values
     - parameter propertyData:  array containing information about property names and datatypes
     
     - returns:                 dictionary containing data of types matching the properties of the target type
     */
    
    internal func parsedDataForRow(row: Statement, forPropertyData propertyData: [PropertyData]) -> [String: SQLiteValue?] {
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
    
    internal func valueForProperty(propertyData: PropertyData, inRow row: Statement) -> SQLiteValue? {
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
        case is Float80.Type:   return row.float80ForColumn(propertyData.name!)
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


// MARK: - Dynamic initialization extension
extension SwiftyDB {
    
    /**
     Get objects of a specified type, matching a set of parameters, from the database
     
     - parameter parameters: dictionary containing the parameters identifying objects to be retrieved
     - parameter type:       type of the objects to be retrieved
     
     - returns:              array containing the retrieved objects
     */
    
    public func objectsForType <D where D: Storable, D: NSObject> (type: D.Type, matchingFilters filters: [String: SQLiteValue?] = [:]) throws -> [D] {
        
        return try dataForType(D.self, matchingFilters: filters).map {
            objectWithData($0, forType: D.self)
        }
    }
    
    /**
     Creates a new dynamic object of a specified type and populates it with data from the provided dictionary
     
     - parameter data:   dictionary containing data
     - parameter type:   type of object the data represents
     
     - returns:          object of the provided type populated with the provided data
     */
    
    internal func objectWithData <D where D: Storable, D: NSObject> (data: [String: SQLiteValue?], forType type: D.Type) -> D {
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