//
//  JSONSerialisation.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 24/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

struct JSONSerialisation {
    private static let separator: String = "||…||"
    
    // MARK: - To JSON
    static func JSONFor<T: CollectionType>(collection collection: T) -> String {
        return JSONFor(collection: collection)!
    }
    
    static func JSONFor<T: CollectionType>(collection collection: T?) -> String? {
        return collection?.map({ String($0) }).joinWithSeparator(separator)
    }
    
    static func JSONFor<T: StorableProperty, U: StorableProperty where T.StorableValueType: Hashable>(dictionary: [T:U]) -> String {
        
        var optionalDictionary: [T: U?] = [:]
        
        for (key, value) in dictionary {
            optionalDictionary[key] = value
        }
        
        return JSONFor(optionalDictionary)
        
    }
    
    static func JSONFor<T: StorableProperty, U: StorableProperty where T.StorableValueType: Hashable>(dictionary: [T:U?]) -> String {
        
        let storableDictionary: NSMutableDictionary = [:]
        
        for (key, value) in dictionary {
            storableDictionary[ objectForValue(key.storableValue) as! NSCopying ] = objectForValue(value?.storableValue)
        }
        
        let data = try! NSJSONSerialization.dataWithJSONObject(storableDictionary, options: [])
        
        return String(data: data, encoding: NSUTF8StringEncoding)!
    }
    
    static func JSONFor<T: StorableProperty, U: StorableProperty where T.StorableValueType: Hashable>(dictionary: [T:U?]?) -> String? {
        guard dictionary != nil else {
            return nil
        }
        
        return JSONFor(dictionary!) as String
    }
    
    static func JSONFor<T: StorableProperty, U: StorableProperty where T.StorableValueType: Hashable>(dictionary: [T:U]?) -> String? {
        guard dictionary != nil else {
            return nil
        }
        
        return JSONFor(dictionary!) as String
    }
    
    static func JSONFor<T: StorableProperty>(array: [T?]) -> String {
        let storableValues = array.map { $0?.storableValue }
        
        return JSONFor(collection: storableValues)
    }
    
    static func JSONFor<T: StorableProperty>(array: [T]) -> String {
        let storableValues: [T.StorableValueType?] = array.map { $0.storableValue }
        
        return JSONFor(collection: storableValues)
    }
    
    static func JSONFor<T: StorableProperty>(array: [T]?) -> String? {

        let storableValues = array?.map { $0.storableValue }
        
        return JSONFor(collection: storableValues)
    }
    
    // MARK: - From JSON
    
    static func arrayFor<T: StorableValue>(JSON: String) -> [T?] {
        let array: [String] = JSON.componentsSeparatedByString(separator)
        
        if T.self is String.Type {
            return array.asType(T.self)
        }
        
        if T.self is Double.Type {
            return array.map { Double($0) as? T }
        }
        
        return array.map { Int64($0) as? T }
    }
    
    static func arrayFor<T: StorableValue>(JSON: String) -> [T] {
        let array: [T?] = arrayFor(JSON)

        return array.matchType()
    }

    static func arrayFor<T: StorableProperty>(JSON: String) -> [T?] {
        let array: [T.StorableValueType?] = arrayFor(JSON)
        
        return array.map { $0 != nil ? T.fromStorableValue($0!) : nil }
    }
    
    static func arrayFor<T: StorableProperty>(JSON: String) -> [T] {
        let array: [T.StorableValueType] = arrayFor(JSON)
        
        return array.map(T.fromStorableValue)
    }
    
    static func arrayFor<T: StorableProperty>(JSON: String?) -> [T?]? {
        guard let JSON = JSON else {
            return nil
        }
        
        let array: [T.StorableValueType?] = arrayFor(JSON)
        
        return array.map { $0 != nil ? T.fromStorableValue($0!) : nil }
    }
    
    static func arrayFor<T: StorableProperty>(JSON: String?) -> [T]? {
        guard let JSON = JSON else {
            return nil
        }
        
        let array: [T.StorableValueType] = arrayFor(JSON)
        
        return array.map(T.fromStorableValue)
    }
    
    
    static func dictionaryFor<T: StorableProperty, U: StorableProperty where T.StorableValueType: Hashable>(JSON: String?) -> [T: U?]? {
        guard JSON != nil else {
            return nil
        }
        
        return dictionaryFor(JSON!) as [T: U?]
    }
    
    static func dictionaryFor<T: StorableProperty, U: StorableProperty where T.StorableValueType: Hashable>(JSON: String) -> [T: U?] {
        let storableDictionary = try! NSJSONSerialization.JSONObjectWithData(JSON.dataUsingEncoding(NSUTF8StringEncoding)!, options: []) as! NSDictionary
        
        var dictionary: [T: U?] = [:]
        
        for (key, value) in storableDictionary {
            dictionary[key as! T] = value as? U
        }
        
        return dictionary
    }
    
    static func dictionaryFor<T: StorableProperty, U: StorableProperty where T.StorableValueType: Hashable>(JSON: String) -> [T: U] {
        let optionalDictionary: [T: U?] = dictionaryFor(JSON)
        
        return optionalDictionary as! [T: U]
    }
    
    static func dictionaryFor<T: StorableProperty, U: StorableProperty where T.StorableValueType: Hashable>(JSON: String?) -> [T: U]? {
        guard JSON != nil else {
            return nil
        }

        return dictionaryFor(JSON!) as [T: U]
    }
    
    private static func objectForValue<T: StorableValue>(value: T?) -> AnyObject? {
        guard value != nil else {
            return NSNull()
        }
        
        if let longLongValue = value as? Int64 {
            return NSNumber(longLong: longLongValue)
        }
        
        return value as? AnyObject
    }
    
}
