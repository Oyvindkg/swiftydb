//
//  SwiftyDB.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 03/11/15.
//


import Foundation


/** All objects in the database must conform to the 'Storable' protocol. This is easily achieved by subclassing NSObject */
@objc public protocol Storable {
    /** Used to initialize an object retrieved from the database */
    init()

    /** Used to assign values to object when retrieved. Currently easiest to achieve through subclassing of NSObject */
    func setValue(value: AnyObject?, forKey key: String)
    
    /** Implement this method to support updates and improved indexing */
    optional static func primaryKeys() -> Set<String>
    
    /** Define a set of properties to be ignored */
    optional static func ignoredProperties() -> Set<String>
}


/** A simple class wrapping an SQLite3 database abstracting the creation of tables, insertion, update, and retrieval */
public class SwiftyDB {
    private let databaseQueue : FMDatabaseQueue

    
    public init(databaseName: String) {
        let documentsDir : String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
        let databasePath = documentsDir+"/\(databaseName).sqlite"

//        try? NSFileManager.defaultManager().removeItemAtPath(databasePath)
        
        let shouldCreateDatabase = !NSFileManager.defaultManager().fileExistsAtPath(databasePath)
        
        databaseQueue = FMDatabaseQueue(path: databasePath)
        
        /* Initialize a new database if it did not exist */
        if shouldCreateDatabase {
            initializeDatabase()
        }
        let _ = createTableForType(Dog.self)
    }
    
    internal func initializeDatabase() {}
    
    
    
    /**
     Creates a new table for the specified type based on the provided column definitions
     
     - parameter type:              type of objects data in the table represents
     
     - returns:                     boolean indicating the success of the operation
     */
    
    public func createTableForType (type: Storable.Type) -> Bool {
        
        let object = type.init()
        
        /* Strings defining the columns in the table for objects of type T */
        var columnStrings: [String] = []
        
        for propertyData in PropertyData.propertyDataForObject(object) {
            if !propertyData.isValid {
                continue
            }
            
            if let columnString = propertyData.SQLiteColumnDefinition() {
                columnStrings.append(columnString)
            }
        }

        let tableName =  tableNameForType(type)
        let sql = "CREATE TABLE \(tableName) (\(columnStrings.joinWithSeparator(", ")))"

        return self.exequteStatement(sql)
    }
    
    /**
     Add an object to the database
     
     - parameter object:     object to be added to the database
     - parameter update:     indicates whether the record should be updated if already present
     
     - returns:              boolean indicating the success of the query
     */
    
    public func addObject(object: Storable, update: Bool = true) -> Bool {
        let validData     = dataFromObject(object)
        
        let sql = insertObjectStatement(validData, type: object.dynamicType, update: update)
        
        return self.exequteStatement(sql, parameters: validData)
    }
    
    /**
     Add objects to the database
     
     - parameter objects:    objects to be added to the database
     - parameter update:     indicates whether the record should be updated if already present
     
     - returns:              boolean indicating the success of the query
     */
    
    public func addObjects <T: Storable> (objects: [T], update: Bool = true) -> Bool {
        var isSuccess = true
        
        databaseQueue.inTransaction { (database, rollback) -> Void in
            for object in objects {
                
                let validData   = self.dataFromObject(object)
                let sql         = self.insertObjectStatement(validData, type: T.self, update: update)
                
                if !database.executeUpdate(sql, withParameterDictionary: validData) {
                    rollback.initialize(true)
                    isSuccess = false
                    return
                }
            }
        }
        
        return isSuccess
    }
    
    
    /** 
    Constructs an SQLite statement inserting and/or updating an object in the database
     
    - parameter data:   dictionary containing data representing an object
    - parameter type:   type of the object to be inserted
    
    - returns:          SQLite statement
    */
    
    private func insertObjectStatement (data: [String: AnyObject], type: Storable.Type, update: Bool = true) -> String {
        let valuesString    = data.keys.sort().map {":\($0)"}.joinWithSeparator(", ")
        let keysString      = data.keys.sort().map {"\($0)"}.joinWithSeparator(", ")
        let tableName       = tableNameForType(type)
        let method          = update ? "INSERT OR REPLACE" : "INSERT"
        
        return "\(method) INTO \(tableName) (\(keysString)) VALUES (\(valuesString))"
    }
    
    
    /**
     Remove objects of a specified type, matching a set of parameters, from the database
     
     - parameter parameters: dictionary containing the parameters identifying objects to be deleted
     - parameter type:       type of the objects to be deleted
     
     - returns:              boolean indicating the success of the request
     */
    
    public func deleteObjectsForType (type: Storable.Type, withParameters parameters: [String: AnyObject] = [:]) -> Bool {
        let tableName       = tableNameForType(type)
        let sql             = "DELETE FROM \(tableName)" + whereClauseForParameters(parameters)
        
        return self.exequteStatement(sql, parameters: parameters)
    }
    
    
    /**
     Get objects of a specified type, matching a set of parameters, from the database
     
     - parameter parameters: dictionary containing the parameters identifying objects to be retrieved
     - parameter type:       type of the objects to be retrieved
     
     - returns:              array containing the retrieved objects
     */
    
    public func getObjectsForType <T: Storable> (type: T.Type, withParameters parameters: [String: AnyObject]? = nil) -> [T] {
        let tableName       = tableNameForType(T)
        let sql             = "SELECT * FROM \(tableName)" + whereClauseForParameters(parameters)
        
        var results: [T] = []
        
        databaseQueue.inDatabase { (database) -> Void in
            let resultSet = database.executeQuery(sql, withParameterDictionary: parameters)
            
            if resultSet != nil {
                while resultSet.next() {
                    
                    let object = type.init()
                    
                    var dictionary: [String: AnyObject] = [:]
                    for propertyData in PropertyData.propertyDataForObject(object) {
                        if !propertyData.isValid {
                            continue
                        }
                        
                        if let value = self.valueForPropertyData(propertyData, inResultSet: resultSet) {
                            dictionary[propertyData.name!] = value
                        }
                    }

                    let objectWithData = self.objectWithData(dictionary, forType: T.self) as! T
                    results.append(objectWithData)
                }
                
                resultSet.close()
            }
        }
        
        return results
    }
    
    private func valueForPropertyData(propertyData: PropertyData, inResultSet resultSet: FMResultSet) -> AnyObject? {
        switch propertyData.type {
        case is String.Type:
            return resultSet.stringForColumn(propertyData.name!)
        case is Bool.Type:
            return resultSet.boolForColumn(propertyData.name!)
        case is NSNumber.Type:
            return NSNumber(double: resultSet.doubleForColumn(propertyData.name!))
        case is Int.Type:
            return Int(resultSet.intForColumn(propertyData.name!))
        case is Float.Type:
            return Float(resultSet.doubleForColumn(propertyData.name!))
        case is Double.Type:
            return Double(resultSet.doubleForColumn(propertyData.name!))
        case is NSData.Type:
            return resultSet.dataForColumn(propertyData.name!)
        case is NSDate.Type:
            return resultSet.dateForColumn(propertyData.name!)
        default:
            return nil
        }
    }
    
    /** Name of the table representing a class */
    private func tableNameForType(type: Storable.Type) -> String {
        return NSStringFromClass(type).componentsSeparatedByString(".").last!
    }
    
    /**
    Construct a where clause for the provided parameters

    - parameter parameters: dictionary containing columns and values
    - returns:              SQLite where clause
    */
    
    private func whereClauseForParameters(parameters: [String: AnyObject]?) -> String {
        if parameters == nil {
            return ""
        }
        
        let segments = parameters?.map { "\($0.0) = :\($0.0)" }
        
        return " WHERE " + segments!.joinWithSeparator(" AND ")
    }
    
    /**
    Executes an update on the database
     
    - parameter statement:  statement
    - parameter parameters: parameters for statement
     
    - returns:              boolean indicating the success of the update
    */
    
    private func exequteStatement(statement: String, parameters: [String: AnyObject] = [:]) -> Bool {
        var isSuccess: Bool = false
        databaseQueue.inDatabase { (database) -> Void in
            isSuccess = database.executeUpdate(statement, withParameterDictionary: parameters)
        }
        
        return isSuccess
    }
    
    
    /**
     Creates a new object of a specified type and populates it with data from the provided dictionary
     
     - parameter data:   dictionary containing data
     - parameter type:   type of object the data represents
     
     - returns:          object of the provided type populated with the provided data
     */
    
    private func objectWithData (data: [String: AnyObject], forType type: Storable.Type) -> Storable {
        let object = type.init()
        
        for propertyData in PropertyData.propertyDataForObject(object) {
            if !propertyData.isValid || data[propertyData.name!] == nil {
                continue
            }

            object.setValue(data[propertyData.name!], forKey: propertyData.name!)
        }
        
        return object
    }
    
    /**
     Serialize the object
     
     - parameter object:    object containing the data to be extracted
     
     - returns:             dictionary containing the data from the object
     */
    
    private func dataFromObject (object: Storable) -> [String: AnyObject] {
        var dictionary: [String: AnyObject] = [:]
        
        for propertyData in PropertyData.propertyDataForObject(object) {
            if !propertyData.isValid || propertyData.value == nil {
                continue
            }

            dictionary[propertyData.name!] = propertyData.value as? AnyObject
        }
        
        return dictionary
    }
}