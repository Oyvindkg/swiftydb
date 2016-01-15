//
//  PropertyData.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 20/12/15.
//

import Foundation
import TinySQLite

/*


*/

internal struct PropertyData {
    
    internal let isOptional: Bool
    internal var type:       SQLiteValue.Type?  = nil
    internal var name:       String?
    internal var value:      SQLiteValue?               = nil
    
    internal var isValid: Bool {
        return type != nil && name != nil
    }
    
    internal init(property: Mirror.Child) {
        self.name = property.label
        
        let mirror = Mirror(reflecting: property.value)
        isOptional = mirror.displayStyle == .Optional
        value = unwrap(property.value) as? SQLiteValue
        
        type = typeForMirror(mirror)
    }
    
    internal func typeForMirror(mirror: Mirror) -> SQLiteValue.Type? {
        if !isOptional {
            return mirror.subjectType as? SQLiteValue.Type
        }
        
        // TODO: Find a better way to unwrap optional types
        // Can easily be done using mirror if the encapsulated value is not nil
        
        switch mirror.subjectType {
        case is Optional<String>.Type:      return String.self
        case is Optional<NSString>.Type:    return NSString.self
        case is Optional<Character>.Type:   return Character.self
            
        case is Optional<NSDate>.Type:      return NSDate.self
        case is Optional<NSNumber>.Type:    return NSNumber.self
        case is Optional<NSData>.Type:      return NSData.self
            
        case is Optional<Bool>.Type:        return Bool.self
            
        case is Optional<Int>.Type:         return Int.self
        case is Optional<Int8>.Type:        return Int8.self
        case is Optional<Int16>.Type:       return Int16.self
        case is Optional<Int32>.Type:       return Int32.self
        case is Optional<Int64>.Type:       return Int64.self
        case is Optional<UInt>.Type:        return UInt.self
        case is Optional<UInt8>.Type:       return UInt8.self
        case is Optional<UInt16>.Type:      return UInt16.self
        case is Optional<UInt32>.Type:      return UInt32.self
        case is Optional<UInt64>.Type:      return UInt64.self
            
        case is Optional<Float>.Type:       return Float.self
        case is Optional<Double>.Type:      return Double.self
        default:                            return nil
        }
    }
    
    /**
     
     Unwraps any value
     
     - parameter value:  The value to unwrap
     
     */
    
    internal func unwrap(value: Any) -> Any? {
        let mirror = Mirror(reflecting: value)
        
        /* Raw value */
        if mirror.displayStyle != .Optional {
            return value
        }
        
        /* The encapsulated optional value if not nil, otherwise nil */
        return mirror.children.first?.value
    }
}

extension PropertyData {
    internal static func validPropertyDataForObject (object: Storable) -> [PropertyData] {
        return validPropertyDataForMirror(Mirror(reflecting: object))
    }
    
    private static func validPropertyDataForMirror(mirror: Mirror, var ignoredProperties: Set<String> = []) -> [PropertyData] {
        if mirror.subjectType is IgnoredProperties.Type {
            ignoredProperties = ignoredProperties.union((mirror.subjectType as! IgnoredProperties.Type).ignoredProperties())
        }
        
        var propertyData: [PropertyData] = []
        
        /* Allow inheritance from storable superclasses using reccursion */
        if let superclassMirror = mirror.superclassMirror() where superclassMirror.subjectType is Storable.Type {
            propertyData += validPropertyDataForMirror(superclassMirror, ignoredProperties: ignoredProperties)
        }
        
        /* Map children to property data and filter out ignored or invalid properties */
        propertyData += mirror.children.map {
                PropertyData(property: $0)
            }.filter({
                $0.isValid && !ignoredProperties.contains($0.name!)
            })
        
        return propertyData
    }
}