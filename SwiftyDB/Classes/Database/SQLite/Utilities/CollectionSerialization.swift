//
//  JSONSerialisation.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 24/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

struct CollectionSerialization {
    fileprivate static let separator: String = "||…||"
    
    // MARK: - To JSON
    static func stringFor<T: Collection>(collection: T) -> String {
        return stringFor(collection: collection)!
    }
    
    static func stringFor<T: Collection>(collection: T?) -> String? {
        return collection?.map({ String(describing: $0) }).joined(separator: separator)
    }
    
    static func stringFor<T: StorableProperty, U: StorableProperty>(dictionary: [T:U]) -> String where T.StorableValueType: Hashable {
        
        var optionalDictionary: [T: U?] = [:]
        
        for (key, value) in dictionary {
            optionalDictionary[key] = value
        }
        
        return stringFor(dictionary: optionalDictionary)
        
    }
    
    static func stringFor<T: StorableProperty, U: StorableProperty>(dictionary: [T:U?]) -> String where T.StorableValueType: Hashable {
        let strings = dictionary.map { (key, value) -> String in
            let keyString = String(describing: key.storableValue)
            let valueString = value != nil ? String(describing: value!.storableValue) : "nil"
            
            return keyString + separator + valueString
        }
        
        return strings.joined(separator: separator)
    }
    
    static func stringFor<T: StorableProperty, U: StorableProperty>(dictionary: [T:U?]?) -> String? where T.StorableValueType: Hashable {
        guard dictionary != nil else {
            return nil
        }
        
        return stringFor(dictionary: dictionary!) as String
    }
    
    static func stringFor<T: StorableProperty, U: StorableProperty>(dictionary: [T:U]?) -> String? where T.StorableValueType: Hashable {
        guard dictionary != nil else {
            return nil
        }
        
        return stringFor(dictionary: dictionary!) as String
    }
    
    static func stringFor<T: StorableProperty>(array: [T?]) -> String {
        let storableValues = array.map { $0?.storableValue }
        
        return stringFor(collection: storableValues)
    }
    
    static func stringFor<T: StorableProperty>(array: [T]) -> String {
        let storableValues = array.map { $0.storableValue }
        
        return stringFor(collection: storableValues)
    }
    
    static func stringFor<T: StorableProperty>(array: [T]?) -> String? {

        let storableValues = array?.map { $0.storableValue }
        
        return stringFor(collection: storableValues)
    }
    
    // MARK: - From JSON
    
    static func arrayFor<T: StorableValue>(string: String) -> [T?] {
        guard !string.isEmpty else {
            return []
        }
        
        let array: [String] = string.components(separatedBy: separator)
        
        if T.self is String.Type {
            return array.asType(T.self)
        }
        
        if T.self is Double.Type {
            return array.map { Double($0) as? T }
        }
        
        return array.map { Int64($0) as? T }
    }
    
    static func arrayFor<T: StorableValue>(string: String) -> [T] {
        let array: [T?] = arrayFor(string: string)
        
        return array.matchType()
    }

    static func arrayFor<T: StorableProperty>(string: String) -> [T?] {
        let array: [T.StorableValueType?] = arrayFor(string: string)
        
        return array.map { $0 != nil ? T.from(storableValue: $0!) : nil }
    }
    
    static func arrayFor<T: StorableProperty>(string: String) -> [T] {
        let array: [T.StorableValueType] = arrayFor(string: string)
        
        return array.map(T.from)
    }
    
    static func arrayFor<T: StorableProperty>(string: String?) -> [T?]? {
        guard let string = string else {
            return nil
        }
        
        let array: [T.StorableValueType?] = arrayFor(string: string)
        
        return array.map { $0 != nil ? T.from(storableValue: $0!) : nil }
    }
    
    static func arrayFor<T: StorableProperty>(string: String?) -> [T]? {
        guard let string = string else {
            return nil
        }
        
        let array: [T.StorableValueType] = arrayFor(string: string)
        
        return array.map(T.from)
    }
    
    
    static func dictionaryFor<T: StorableProperty, U: StorableProperty>(string: String?) -> [T: U?]? where T.StorableValueType: Hashable {
        guard string != nil else {
            return nil
        }
        
        return dictionaryFor(string: string!) as [T: U?]
    }
    
    static func dictionaryFor<T: StorableProperty, U: StorableProperty>(string: String) -> [T: U?] where T.StorableValueType: Hashable {
        guard !string.isEmpty else {
            return [:]
        }
        
        let components: [String] = string.components(separatedBy: separator)
        
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
    
    static func dictionaryFor<T: StorableProperty, U: StorableProperty>(string: String) -> [T: U] where T.StorableValueType: Hashable {
        let optionalDictionary: [T: U?] = dictionaryFor(string: string)
        
        return optionalDictionary as! [T: U]
    }
    
    static func dictionaryFor<T: StorableProperty, U: StorableProperty>(string: String?) -> [T: U]? where T.StorableValueType: Hashable {
        guard string != nil else {
            return nil
        }

        return dictionaryFor(string: string!) as [T: U]
    }
}
