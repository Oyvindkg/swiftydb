//
//  JSONSerialisation.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 24/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

struct JSONSerialisation {
    fileprivate static let separator: String = "||…||"
    
    // MARK: - To JSON
    static func JSONFor<T: Collection>(collection: T) -> String {
        return JSONFor(collection: collection)!
    }
    
    static func JSONFor<T: Collection>(collection: T?) -> String? {
        return collection?.map({ String(describing: $0) }).joined(separator: separator)
    }
    
    static func JSONFor<T: StorableProperty, U: StorableProperty>(_ dictionary: [T:U]) -> String where T.StorableValueType: Hashable {
        
        var optionalDictionary: [T: U?] = [:]
        
        for (key, value) in dictionary {
            optionalDictionary[key] = value
        }
        
        return JSONFor(optionalDictionary)
        
    }
    
    static func JSONFor<T: StorableProperty, U: StorableProperty>(_ dictionary: [T:U?]) -> String where T.StorableValueType: Hashable {
        let strings = dictionary.map { (key, value) -> String in
            let keyString = String(describing: key.storableValue)
            let valueString = value != nil ? String(describing: value!.storableValue) : "nil"
            
            return keyString + separator + valueString
        }
        
        return strings.joined(separator: separator)
    }
    
    static func JSONFor<T: StorableProperty, U: StorableProperty>(_ dictionary: [T:U?]?) -> String? where T.StorableValueType: Hashable {
        guard dictionary != nil else {
            return nil
        }
        
        return JSONFor(dictionary!) as String
    }
    
    static func JSONFor<T: StorableProperty, U: StorableProperty>(_ dictionary: [T:U]?) -> String? where T.StorableValueType: Hashable {
        guard dictionary != nil else {
            return nil
        }
        
        return JSONFor(dictionary!) as String
    }
    
    static func JSONFor<T: StorableProperty>(_ array: [T?]) -> String {
        let storableValues = array.map { $0?.storableValue }
        
        return JSONFor(collection: storableValues)
    }
    
    static func JSONFor<T: StorableProperty>(_ array: [T]) -> String {
        let storableValues = array.map { $0.storableValue }
        
        return JSONFor(collection: storableValues)
    }
    
    static func JSONFor<T: StorableProperty>(_ array: [T]?) -> String? {

        let storableValues = array?.map { $0.storableValue }
        
        return JSONFor(collection: storableValues)
    }
    
    // MARK: - From JSON
    
    static func arrayFor<T: StorableValue>(_ JSON: String) -> [T?] {
        guard !JSON.isEmpty else {
            return []
        }
        
        let array: [String] = JSON.components(separatedBy: separator)
        
        if T.self is String.Type {
            return array.asType(T.self)
        }
        
        if T.self is Double.Type {
            return array.map { Double($0) as? T }
        }
        
        return array.map { Int64($0) as? T }
    }
    
    static func arrayFor<T: StorableValue>(_ JSON: String) -> [T] {
        let array: [T?] = arrayFor(JSON)
        
        return array.matchType()
    }

    static func arrayFor<T: StorableProperty>(_ JSON: String) -> [T?] {
        let array: [T.StorableValueType?] = arrayFor(JSON)
        
        return array.map { $0 != nil ? T.from(storableValue: $0!) : nil }
    }
    
    static func arrayFor<T: StorableProperty>(_ JSON: String) -> [T] {
        let array: [T.StorableValueType] = arrayFor(JSON)
        
        return array.map(T.from)
    }
    
    static func arrayFor<T: StorableProperty>(_ JSON: String?) -> [T?]? {
        guard let JSON = JSON else {
            return nil
        }
        
        let array: [T.StorableValueType?] = arrayFor(JSON)
        
        return array.map { $0 != nil ? T.from(storableValue: $0!) : nil }
    }
    
    static func arrayFor<T: StorableProperty>(_ JSON: String?) -> [T]? {
        guard let JSON = JSON else {
            return nil
        }
        
        let array: [T.StorableValueType] = arrayFor(JSON)
        
        return array.map(T.from)
    }
    
    
    static func dictionaryFor<T: StorableProperty, U: StorableProperty>(_ JSON: String?) -> [T: U?]? where T.StorableValueType: Hashable {
        guard JSON != nil else {
            return nil
        }
        
        return dictionaryFor(JSON!) as [T: U?]
    }
    
    static func dictionaryFor<T: StorableProperty, U: StorableProperty>(_ JSON: String) -> [T: U?] where T.StorableValueType: Hashable {
        guard !JSON.isEmpty else {
            return [:]
        }
        
        let components: [String] = JSON.components(separatedBy: separator)
        
        var dictionary: [T: U?] = [:]
        
        for i in stride(from: 0, to: components.count, by: 2) {
            let key: T.StorableValueType
            let value: U.StorableValueType?
            
            if T.StorableValueType.self is Double.Type {
                key = Double(components[i]) as! T.StorableValueType
            } else if T.StorableValueType.self is Int64.Type {
                key = Int64(components[i]) as! T.StorableValueType
            } else {
                key = components[i] as! T.StorableValueType
            }
            
            if U.StorableValueType.self is Double.Type {
                value = Double(components[i+1]) as? U.StorableValueType
            } else if T.StorableValueType.self is Int64.Type {
                value = Int64(components[i+1]) as? U.StorableValueType
            } else {
                value = components[i+1] as? U.StorableValueType
            }
            
            dictionary[T.from(storableValue: key)] = value != nil ? U.from(storableValue: value!) : nil
        }

        return dictionary
    }
    
    static func dictionaryFor<T: StorableProperty, U: StorableProperty>(_ JSON: String) -> [T: U] where T.StorableValueType: Hashable {
        let optionalDictionary: [T: U?] = dictionaryFor(JSON)
        
        return optionalDictionary as! [T: U]
    }
    
    static func dictionaryFor<T: StorableProperty, U: StorableProperty>(_ JSON: String?) -> [T: U]? where T.StorableValueType: Hashable {
        guard JSON != nil else {
            return nil
        }

        return dictionaryFor(JSON!) as [T: U]
    }
    
    fileprivate static func objectFor<T: StorableValue>(value: T?) -> AnyObject {
        guard value != nil else {
            return NSNull()
        }
        
        if let longLongValue = value as? Int64 {
            return NSNumber(value: longLongValue as Int64)
        }
        
        return value as! AnyObject
    }
    
}
