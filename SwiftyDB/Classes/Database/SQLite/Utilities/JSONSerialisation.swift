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
    
    static func JSONFor<T: StoreableValueConvertible, U: StoreableValueConvertible where T.StoreableValueType: Hashable>(dictionary: [T:U]) -> String {
        
        var optionalDictionary: [T: U?] = [:]
        
        for (key, value) in dictionary {
            optionalDictionary[key] = value
        }
        
        return JSONFor(optionalDictionary)
        
    }
    
    static func JSONFor<T: StoreableValueConvertible, U: StoreableValueConvertible where T.StoreableValueType: Hashable>(dictionary: [T:U?]) -> String {
        
        let storeableDictionary: NSMutableDictionary = [:]
        
        for (key, value) in dictionary {
            storeableDictionary[ objectForValue(key.storeableValue) as! NSCopying ] = objectForValue(value?.storeableValue)
        }
        
        let data = try! NSJSONSerialization.dataWithJSONObject(storeableDictionary, options: [])
        
        return String(data: data, encoding: NSUTF8StringEncoding)!
    }
    
    static func JSONFor<T: StoreableValueConvertible, U: StoreableValueConvertible where T.StoreableValueType: Hashable>(dictionary: [T:U?]?) -> String? {
        guard dictionary != nil else {
            return nil
        }
        
        return JSONFor(dictionary!) as String
    }
    
    static func JSONFor<T: StoreableValueConvertible, U: StoreableValueConvertible where T.StoreableValueType: Hashable>(dictionary: [T:U]?) -> String? {
        guard dictionary != nil else {
            return nil
        }
        
        return JSONFor(dictionary!) as String
    }
    
    static func JSONFor<T: StoreableValueConvertible>(array: [T?]) -> String {
        let storeableValues = array.map { $0?.storeableValue }
        
        return JSONFor(collection: storeableValues)
    }
    
    static func JSONFor<T: StoreableValueConvertible>(array: [T]) -> String {
        let storeableValues: [T.StoreableValueType?] = array.map { $0.storeableValue }
        
        return JSONFor(collection: storeableValues)
    }
    
    static func JSONFor<T: StoreableValueConvertible>(array: [T]?) -> String? {

        let storeableValues = array?.map { $0.storeableValue }
        
        return JSONFor(collection: storeableValues)
    }
    
    // MARK: - From JSON
    
    static func arrayFor<T: StoreableValue>(JSON: String) -> [T?] {
        let array: [String] = JSON.componentsSeparatedByString(separator)
        
        if T.self is String.Type {
            return array.asType(T.self)
        }
        
        if T.self is Double.Type {
            return array.map { Double($0) as? T }
        }
        
        return array.map { Int64($0) as? T }
    }
    
    static func arrayFor<T: StoreableValue>(JSON: String) -> [T] {
        let array: [T?] = arrayFor(JSON)

        return array.matchType()
    }

    static func arrayFor<T: StoreableValueConvertible>(JSON: String) -> [T?] {
        let array: [T.StoreableValueType?] = arrayFor(JSON)
        
        return array.map { $0 != nil ? T.fromStoreableValue($0!) : nil }
    }
    
    static func arrayFor<T: StoreableValueConvertible>(JSON: String) -> [T] {
        let array: [T.StoreableValueType] = arrayFor(JSON)
        
        return array.map(T.fromStoreableValue)
    }
    
    static func arrayFor<T: StoreableValueConvertible>(JSON: String?) -> [T?]? {
        guard let JSON = JSON else {
            return nil
        }
        
        let array: [T.StoreableValueType?] = arrayFor(JSON)
        
        return array.map { $0 != nil ? T.fromStoreableValue($0!) : nil }
    }
    
    static func arrayFor<T: StoreableValueConvertible>(JSON: String?) -> [T]? {
        guard let JSON = JSON else {
            return nil
        }
        
        let array: [T.StoreableValueType] = arrayFor(JSON)
        
        return array.map(T.fromStoreableValue)
    }
    
    
    static func dictionaryFor<T: StoreableValueConvertible, U: StoreableValueConvertible where T.StoreableValueType: Hashable>(JSON: String?) -> [T: U?]? {
        guard JSON != nil else {
            return nil
        }
        
        return dictionaryFor(JSON!) as [T: U?]
    }
    
    static func dictionaryFor<T: StoreableValueConvertible, U: StoreableValueConvertible where T.StoreableValueType: Hashable>(JSON: String) -> [T: U?] {
        let storeableDictionary = try! NSJSONSerialization.JSONObjectWithData(JSON.dataUsingEncoding(NSUTF8StringEncoding)!, options: []) as! NSDictionary
        
        var dictionary: [T: U?] = [:]
        
        for (key, value) in storeableDictionary {
            dictionary[key as! T] = value as? U
        }
        
        return dictionary
    }
    
    static func dictionaryFor<T: StoreableValueConvertible, U: StoreableValueConvertible where T.StoreableValueType: Hashable>(JSON: String) -> [T: U] {
        let optionalDictionary: [T: U?] = dictionaryFor(JSON)
        
        return optionalDictionary as! [T: U]
    }
    
    static func dictionaryFor<T: StoreableValueConvertible, U: StoreableValueConvertible where T.StoreableValueType: Hashable>(JSON: String?) -> [T: U]? {
        guard JSON != nil else {
            return nil
        }

        return dictionaryFor(JSON!) as [T: U]
    }
    
    private static func objectForValue<T: StoreableValue>(value: T?) -> AnyObject? {
        guard value != nil else {
            return NSNull()
        }
        
        if let longLongValue = value as? Int64 {
            return NSNumber(longLong: longLongValue)
        }
        
        return value as? AnyObject
    }
    
}