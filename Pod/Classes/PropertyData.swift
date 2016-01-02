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
    
    var type:       Binding.Type?   = nil
    var name:       String?
    var value:      Any?            = nil
    
    var isValid: Bool {
        if type == nil {
            return false
        }
        
        return true
    }
    
    init(property: Mirror.Child) {
        self.name = property.label
        
        let mirror = Mirror(reflecting: property.value)
        isOptional = mirror.displayStyle == .Optional
        dynamic = true
        value = unwrap(property.value)
        
        type = typeForMirror(mirror)
    }
    
    internal func typeForMirror(mirror: Mirror) -> Binding.Type? {
        // TODO: Find a better way to unwrap optional types
        // Can easily be done using mirror if the encapsulated value is not nil
        if isOptional {
            switch mirror.subjectType {
            case is Optional<String>.Type:
                return String.self
            case is Optional<NSString>.Type:
                return NSString.self
            case is Optional<NSDate>.Type:
                return NSDate.self
            case is Optional<Bool>.Type:
                return Bool.self
            case is Optional<NSNumber>.Type:
                return NSNumber.self
            case is Optional<NSData>.Type:
                return NSData.self
            case is Optional<Int>.Type:
                return Int.self
            case is Optional<Float>.Type:
                return Float.self
            case is Optional<Double>.Type:
                return Double.self
            default:
                fatalError("Datatype '\(mirror.subjectType)' is not configured")
                return nil
            }
        }
        
        return mirror.subjectType as? Binding.Type
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