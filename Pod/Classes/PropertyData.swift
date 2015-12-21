//
//  PropertyData.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 20/12/15.
//

import Foundation

/*


*/

internal struct PropertyData {
    
    let isOptional: Bool
    let dynamic:    Bool
    
    var objectType: Storeable.Type
    var type:       Any.Type?       = nil
    var name:       String?
    var value:      Any?            = nil
    
    var isValid: Bool {
        return type != nil && !(objectType.ignoredProperties?().contains(name!) ?? false)
    }
    
    init(property: Mirror.Child, objectType: Storeable.Type) {
        self.objectType = objectType
        self.name = property.label
        
        let mirror = Mirror(reflecting: property.value)
        isOptional = mirror.displayStyle == .Optional
        dynamic = true
        value = unwrap(property.value)
        
        if let validType = typeForMirror(mirror) {
            type = validType
        }
    }
    
    internal func typeForMirror(mirror: Mirror) -> Any.Type? {
        
        // TODO: Find a better way to unwrap optional types
        // Can easily be done using mirror if the encapsulated value is not nil
        if isOptional {
            switch mirror.subjectType {
            case is (String?).Type:
                return String.self
            case is (NSDate?).Type:
                return NSDate.self
            case is (Bool?).Type:
                return Bool.self
            case is (NSNumber?).Type:
                return NSNumber.self
            case is (NSData?).Type:
                return NSData.self
//            case is (Int?).Type:
//                return Int.self
//            case is (Float?).Type:
//                return Float.self
//            case is (Double?).Type:
//                return Double.self
            default:
                return nil
            }
        }
        
        return mirror.subjectType
    }
    
    /**
     
     Unwraps optional values
     
     - parameter value:  The value to unwrap
     
     */
    
    internal func unwrap(value: Any) -> Any? {
        let mirror = Mirror(reflecting: value)
        
        /* Raw value */
        if mirror.displayStyle != .Optional {
            return value
        }
        
        /* An the encapsulated optional value if not nil, otherwise nil */
        return mirror.children.first?.value
    }
}

extension PropertyData {
    internal static func propertyDataForObject (object: Storeable) -> [PropertyData] {
        let mirror = Mirror(reflecting: object)
        return mirror.children.map {
            PropertyData(property: $0, objectType: object.dynamicType)
        }
    }
}

extension PropertyData {
    internal func SQLiteColumnDefinition() -> String? {
        /* Contains strings used to build the column definition */
        var segments = [self.name!]
        
        /* Retrieve a valid SQLite datatype for the property type, or return nil */
        if let sqliteDatatype = self.SQLiteDatatype() {
            segments.append(sqliteDatatype)
        } else {
            return nil
        }
        
        /* If the property is not optional, it is never null */
        if !self.isOptional {
            segments.append("NOT NULL")
        }
        
        /* Mark as primary key if necessary */
        if self.objectType.primaryKeys?().contains(self.name!) ?? false {
            segments.append("PRIMARY KEY")
        }
        
        /* Join the segments into a string and return the complete column definition */
        return segments.joinWithSeparator(" ")
    }
    
    internal func SQLiteDatatype() -> String? {
        switch self.type {
        case is String.Type, is NSDate.Type:
            return "TEXT"
        case is Bool.Type, is Int.Type:
            return "INT"
        case is NSNumber.Type, is Float.Type, is Double.Type:
            return "REAL"
        case is NSData.Type:
            return "BLOB"
        default:
            return nil
        }
    }
}