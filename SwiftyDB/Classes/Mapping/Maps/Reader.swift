//
//  Reader.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 22/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

final class Reader: Mapper {
    
    let type: Mappable.Type
    var currentKey: String?
    
    var storableValues: [String: StorableValue]         = [:]
    
    var mappables: [String: Reader]        = [:]
    var mappableArrays: [String: [Reader]] = [:]
    
    /** The original property type for all values stored in the reader */
    var propertyTypes: [String: Any.Type] = [:]
    

    init(type: Mappable.Type) {
        self.type = type
    }
    
    
    // MARK: StorablePropery
    
    func setCurrent<T: StorableProperty>(value: T?) {
        guard let key = currentKey else {
            return
        }

        storableValues[key] = value?.rawValue
        propertyTypes[key]  = T.RawValue.self
    }
    
    func setCurrent<T: StorableProperty>(values: [T]?) {
        guard let key = currentKey else {
            return
        }
        
        storableValues[key] = jsonForArray(values)
        propertyTypes[key]  = Array<T.RawValue>.self
    }
    
    func setCurrent<T: StorableProperty>(values: Set<T>?) {
        setCurrent(values: values?.map { $0 })
    }
    
    func setCurrent<T: StorableProperty, U: StorableProperty>(dictionary: [T: U]?) where T.RawValue : Hashable {
        guard let key = currentKey else {
            return
        }
        
        storableValues[key] = jsonForDictionary(dictionary)
        propertyTypes[key]  = Dictionary<T.RawValue, U.RawValue>.self
    }
    
    // MARK: Mappables
    
    func setCurrent<T: Mappable>(mappable: T?) {
        guard let key = currentKey else {
            return
        }
        
        var reader: Reader?
        
        if mappable != nil {
            reader = ObjectMapper.read(mappable!)
        }
        
        mappables[key]      = reader
        storableValues[key] = reader?.identifierValue
        propertyTypes[key]  = T.self
    }

    func setCurrent<T: Mappable>(mappables: [T]?) {
        guard let key = currentKey else {
            return
        }		
        
        let readers = mappables?.map { mappable -> Reader in
            return ObjectMapper.read(mappable)
        }
        
        let identifiers = readers?.map { $0.identifierValue as! String }    //FIXME: Forced downcasting
        
        let JSON = jsonForArray(identifiers)
        
        storableValues[key] = JSON
        mappableArrays[key] = readers
        propertyTypes[key]  = Array<T>.self
    }
    
    func setCurrent<T: Mappable>(mappables: Set<T>?) {
        setCurrent(mappables: mappables?.map {$0})
    }

    subscript(key: String) -> Reader {
        currentKey = key
        
        return self
    }
    
    
    private func jsonForArray<T: StorableProperty>(_ array: [T]?) -> String? {
        guard let array = array else {
            return nil
        }
        
        let storableValues = array.map { $0.rawValue }
        
        let jsonData = try! JSONSerialization.data(withJSONObject: storableValues, options: [])
        
        return String(data: jsonData, encoding: .utf8)!
    }
    
    
    private func jsonForDictionary<T: StorableProperty, U: StorableProperty>(_ dictionary: [T: U]?) -> String? where T.RawValue : Hashable {
        guard let dictionary = dictionary else {
            return nil
        }
        
        let storableValueDictionary = dictionary.map(mapping: { (key, value) in
            return (key.rawValue, value.rawValue)
        })
        
        let jsonData = try! JSONSerialization.data(withJSONObject: storableValueDictionary, options: [])
        
        return String(data: jsonData, encoding: .utf8)!
    }
}


// MARK: - Storable properties


func <- <T: StorableProperty>(left: inout T, right: Reader) {
    right.setCurrent(value: left)
}

func <- <T: StorableProperty>(left: inout T?, right: Reader) {
    right.setCurrent(value: left)
}

func <- <T: StorableProperty>(left: inout T!, right: Reader) {
    right.setCurrent(value: left)
}

// MARK: Array of storable properties


func <- <T: StorableProperty>(left: inout [T], right: Reader) {
    right.setCurrent(values: left)
}

func <- <T: StorableProperty>(left: inout [T]?, right: Reader) {
    right.setCurrent(values: left)
}

func <- <T: StorableProperty>(left: inout [T]!, right: Reader) {
    right.setCurrent(values: left)
}


// MARK: Set of storable properties


func <- <T: StorableProperty>(left: inout Set<T>, right: Reader) {
    right.setCurrent(values: left)
}

func <- <T: StorableProperty>(left: inout Set<T>?, right: Reader) {
    right.setCurrent(values: left)
}

func <- <T: StorableProperty>(left: inout Set<T>!, right: Reader) {
    right.setCurrent(values: left)
}

// MARK: Storable property dicitonaries


func <- <T: StorableProperty, U: StorableProperty>(left: inout [T: U], right: Reader) where T.RawValue: Hashable {
    right.setCurrent(dictionary: left)
}

func <- <T: StorableProperty, U: StorableProperty>(left: inout [T: U]?, right: Reader) where T.RawValue: Hashable {
    right.setCurrent(dictionary: left)
}

func <- <T: StorableProperty, U: StorableProperty>(left: inout [T: U]!, right: Reader) where T.RawValue: Hashable {
    right.setCurrent(dictionary: left)
}



// MARK: - Mappable objects


func <- <T: Mappable>(left: inout T, right: Reader) {
    right.setCurrent(mappable: left)
}

func <- <T: Mappable>(left: inout T?, right: Reader) {
    right.setCurrent(mappable: left)
}

func <- <T: Mappable>(left: inout T!, right: Reader) {
    right.setCurrent(mappable: left)
}


// MARK: Array of mappable objects

func <- <T: Mappable>(left: inout [T], right: Reader) {
    right.setCurrent(mappables: left)
}

func <- <T: Mappable>(left: inout [T]?, right: Reader) {
    right.setCurrent(mappables: left)
}

func <- <T: Mappable>(left: inout [T]!, right: Reader) {
    right.setCurrent(mappables: left)
}


// MARK: Set of mappable objects

func <- <T: Mappable>(left: inout Set<T>, right: Reader) {
    right.setCurrent(mappables: left)
}

func <- <T: Mappable>(left: inout Set<T>?, right: Reader) {
    right.setCurrent(mappables: left)
}

func <- <T: Mappable>(left: inout Set<T>!, right: Reader) {
    right.setCurrent(mappables: left)
}






