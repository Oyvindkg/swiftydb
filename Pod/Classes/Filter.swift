//
//  Filter.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 17/01/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import TinySQLite

/** 
An instance of the Filter class is used to filter query results
All filters are automatically converted into SQLite statements when querying the database.
 
To make filtering easier, and backwards compatibility, it is possible to instantiate a filter object as a dictionary literal

**Example:**
 
Return any objects with the name 'Ghost'
 
```
let filter: Filter = ["name": "Ghost"]

let filter = Filter.equal("name", value: "Ghost")
```
*/

public class Filter: DictionaryLiteralConvertible {
    public typealias Key = String
    public typealias Value = SQLiteValue?
    
    
    private enum Relationship: String {
        case Equal =            "="
        case Less =             "<"
        case Greater =          ">"
        case NotEqual =         "!="
        case In =               "IN"
        case NotIn =            "NOT IN"
        case Like =             "LIKE"
        case NotLike =          "NOT LIKE"
        case LessOrEqual =      "<="
        case GreaterOrEqual =   ">="
    }
    
    /** Represent a part of the total filters (e.g. 'id = 2') */
    private struct FilterComponent {
        let propertyName: String
        let relationship: Relationship
        let value: Any?
        
        func statement() -> String {
            switch relationship {
            case .Equal, .NotEqual, .Greater, .GreaterOrEqual, .Less, .LessOrEqual, .Like, .NotLike:
                return "\(propertyName) \(relationship.rawValue) :\(propertyName)"
            case .In, .NotIn:
                let array = value as! [SQLiteValue?]
                let placeholderString = (0..<array.count).map {":\(propertyName)\($0)"}
                                                         .joinWithSeparator(", ")

                return "\(propertyName) \(relationship.rawValue) (\(placeholderString))"
            }
        }
    }
    
    
    private var components: [FilterComponent] = []
    
    
// MARK: - Initializers
    
    /** Initialize a Filter object using a dictionary. All property-value pairs will limit the results to objects where property's value is equal to the provided value */
    public required init(dictionaryLiteral elements: (Key, Value)...) {
        elements.forEach { (propertyName, value) in
            components.append(FilterComponent(propertyName: propertyName, relationship: .Equal, value: value))
        }
    }
    
    /** Initialize a new, empty Filter object */
    public init() {}
    
// MARK: - Filters
    
    /** Evaluated as true if the value of the property is equal to the provided value
     
    - parameter propertyName:  name of the property to be evaluated
    - parameter array:         value that will be compared to the property value

    - returns:                 `self`, to enable chaining of statements
    */
    
    public func equal(propertyName: String, value: SQLiteValue?) -> Filter {
        components.append(FilterComponent(propertyName: propertyName, relationship: .Equal, value: value))
        return self
    }
    
    /** Evaluated as true if the value of the property is less than the provided value
     
    - parameter propertyName:  name of the property to be evaluated
    - parameter array:         value that will be compared to the property value
     
    - returns:                 `self`, to enable chaining of statements
    */
    public func lessThan(propertyName: String, value: SQLiteValue?) -> Filter {
        components.append(FilterComponent(propertyName: propertyName, relationship: .Less, value: value))
        return self
    }
    
    /** Evaluated as true if the value of the property is less or equal to the provided value
    
    - parameter propertyName:  name of the property to be evaluated
    - parameter array:         value that will be compared to the property value
     
    - returns:                 `self`, to enable chaining of statements
    */
    public func lessOrEqual(propertyName: String, value: SQLiteValue?) -> Filter {
        components.append(FilterComponent(propertyName: propertyName, relationship: .LessOrEqual, value: value))
        return self
    }
    
    /** Evaluated as true if the value of the property is less than the provided value
     
    - parameter propertyName:  name of the property to be evaluated
    - parameter array:         value that will be compared to the property value
     
    - returns:                 `self`, to enable chaining of statements
    */
    public func greaterThan(propertyName: String, value: SQLiteValue?) -> Filter {
        components.append(FilterComponent(propertyName: propertyName, relationship: .Greater, value: value))
        return self
    }
    
    /** Evaluated as true if the value of the property is greater or equal to the provided value
     
    - parameter propertyName:  name of the property to be evaluated
    - parameter array:         value that will be compared to the property value
     
    - returns:                 `self`, to enable chaining of statements
    */
    public func greaterOrEqual(propertyName: String, value: SQLiteValue?) -> Filter {
        components.append(FilterComponent(propertyName: propertyName, relationship: .GreaterOrEqual, value: value))
        return self
    }
    
    /** Evaluated as true if the value of the property is not equal to the provided value
     
    - parameter propertyName:  name of the property to be evaluated
    - parameter array:         value that will be compared to the property value
     
    - returns:                 `self`, to enable chaining of statements
    */
    public func notEqual(propertyName: String, value: SQLiteValue?) -> Filter {
        components.append(FilterComponent(propertyName: propertyName, relationship: .NotEqual, value: value))
        return self
    }
    
    /** Evaluated as true if the value of the property is contained in the array 
    
    - parameter propertyName:  name of the property to be evaluated
    - parameter array:         array that should contain the property value
     
    - returns:                 `self`, to enable chaining of statements
    */
    public func contains(propertyName: String, array: [SQLiteValue?]) -> Filter {
        components.append(FilterComponent(propertyName: propertyName, relationship: .In, value: array))
        return self
    }

    /** Evaluated as true if the value of the property is not contained in the array
     
    - parameter propertyName:  name of the property to be evaluated
    - parameter array:         array that should not contain the property value
     
    - returns:                 `self`, to enable chaining of statements
    */
    public func notContains(propertyName: String, array: [SQLiteValue?]) -> Filter {
        components.append(FilterComponent(propertyName: propertyName, relationship: .NotIn, value: array))
        return self
    }
    
    /** 
    Evaluated as true if the value of the property matches the pattern.
     
    **%** matches any string
     
    **_** matches a single character
        
    'Dog' LIKE 'D_g'    = true
        
    'Dog' LIKE 'D%'     = true
     
     
    - parameter propertyName:  name of the property to be evaluated
    - parameter array:         array that should contain the property value
     
    - returns:                 `self`, to enable chaining of statements
    */
    public func like(propertyName: String, pattern: String) -> Filter {
        components.append(FilterComponent(propertyName: propertyName, relationship: .Like, value: pattern))
        return self
    }
    
    /**
     Evaluated as true if the value of the property matches the pattern.
     
     **%** matches any string
     
     **_** matches a single character
     
     'Dog' NOT LIKE 'D_g'    = false
     
     'Dog' NOT LIKE 'D%'     = false
     
     
     - parameter propertyName:  name of the property to be evaluated
     - parameter array:         array that should contain the property value
     
     - returns:                 `Filter` intance
     */
    public func notLike(propertyName: String, pattern: String) -> Filter {
        components.append(FilterComponent(propertyName: propertyName, relationship: .NotLike, value: pattern))
        return self
    }
    
// MARK: - Internal methods
    
    internal func whereStatement() -> String {
        let statement = "WHERE " + self.components.map {$0.statement()}.joinWithSeparator(" AND ")
        return statement
    }
    
    internal func parameters() -> [String: SQLiteValue?] {
        var parameters: [String: SQLiteValue?] = [:]
        
        for filterComponent in components {
            if let arrayValue = filterComponent.value as? [SQLiteValue?] {
                for (index, value) in arrayValue.enumerate() {
                    parameters["\(filterComponent.propertyName)\(index)"] = value
                }
            } else {
                parameters[filterComponent.propertyName] = filterComponent.value as? SQLiteValue
            }
        }
        
        return parameters
    }
}

/** Convenience methods */
extension Filter {

// MARK: - Convenience filter initializers
    
    /** Evaluated as true if the value of the property is equal to the provided value
    
    - parameter propertyName:   name of the property to be evaluated
    - parameter array:          value that will be compared to the property value
    
    - returns:                  `Filter` intance
    */
    
    public class func equal(propertyName: String, value: SQLiteValue?) -> Filter {
        return Filter().equal(propertyName, value: value)
    }
    
    /** Evaluated as true if the value of the property is less than the provided value
    
    - parameter propertyName:  name of the property to be evaluated
    - parameter array:         value that will be compared to the property value
    
    - returns:                 `Filter` intance
    */
    public class func lessThan(propertyName: String, value: SQLiteValue?) -> Filter {
        return Filter().lessThan(propertyName, value: value)
    }
    
    /** Evaluated as true if the value of the property is less or equal to the provided value
     
    - parameter propertyName:  name of the property to be evaluated
    - parameter array:         value that will be compared to the property value
     
    - returns:                 `Filter` intance
    */
    public class func lessOrEqual(propertyName: String, value: SQLiteValue?) -> Filter {
        return Filter().lessOrEqual(propertyName, value: value)
    }
    
    /** 
    Evaluated as true if the value of the property is greater than the provided value
    
    - parameter propertyName:  name of the property to be evaluated
    - parameter array:         value that will be compared to the property value
    
    - returns:                 `Filter` intance
    */
    public class func greaterThan(propertyName: String, value: SQLiteValue?) -> Filter {
        return Filter().greaterThan(propertyName, value: value)
    }
    
    /**
    Evaluated as true if the value of the property is greater or equal to the provided value
     
    - parameter propertyName:  name of the property to be evaluated
    - parameter array:         value that will be compared to the property value
     
    - returns:                 `Filter` intance
    */
    public class func greaterOrEqual(propertyName: String, value: SQLiteValue?) -> Filter {
        return Filter().greaterOrEqual(propertyName, value: value)
    }
    
    /** 
    Evaluated as true if the value of the property is not equal to the provided value
    
    - parameter propertyName:  name of the property to be evaluated
    - parameter array:         value that will be compared to the property value
    
    - returns:                 `Filter` intance
    */
    public class func notEqual(propertyName: String, value: SQLiteValue?) -> Filter {
        return Filter().notEqual(propertyName, value: value)
    }
    
    /** 
    Evaluated as true if the value of the property is contained in the array
     
    - parameter propertyName:  name of the property to be evaluated
    - parameter array:         array that should contain the property value
    
    - returns:                 `Filter` intance
    */
    public class func contains(propertyName: String, array: [SQLiteValue?]) -> Filter {
        return Filter().contains(propertyName, array: array)
    }
    
    /** 
    Evaluated as true if the value of the property is not contained in the array
     
    - parameter propertyName:  name of the property to be evaluated
    - parameter array:         array that should not contain the property value
     
    - returns:                 `Filter` intance
    */
    public class func notContains(propertyName: String, array: [SQLiteValue?]) -> Filter {
        return Filter().notContains(propertyName, array: array)
    }
    
    /** 
    Evaluated as true if the value of the property matches the pattern.
     
    **%** matches any string
     
    **_** matches a single character
     
    'Dog' LIKE 'D_g'    = true
    
    'Dog' LIKE 'D%'     = true
     
     
    - parameter propertyName:  name of the property to be evaluated
    - parameter array:         array that should contain the property value
    
    - returns:                 `Filter` intance
    */
    public class func like(propertyName: String, pattern: String) -> Filter {
        return Filter().like(propertyName, pattern: pattern)
    }
    
    /**
     Evaluated as true if the value of the property matches the pattern.
     
     **%** matches any string
     
     **_** matches a single character
     
     'Dog' NOT LIKE 'D_g'    = false
     
     'Dog' NOT LIKE 'D%'     = false
     
     
     - parameter propertyName:  name of the property to be evaluated
     - parameter array:         array that should contain the property value
     
     - returns:                 `Filter` intance
     */
    public class func notLike(propertyName: String, pattern: String) -> Filter {
        return Filter().notLike(propertyName, pattern: pattern)
    }
}
