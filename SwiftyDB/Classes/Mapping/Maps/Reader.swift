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
    var storableValueArrays: [String: [StorableValue?]] = [:]
    
    var mappables: [String: Reader]        = [:]
    var mappableArrays: [String: [Reader]] = [:]
    
    init(type: Mappable.Type) {
        self.type = type
    }
    
    /** The original property type for all values stored in the reader */
    var propertyTypes: [String: Any.Type] = [:]
    
    func setCurrent<T: StorableValue>(value: T?, forType type: Any.Type = T.self) {
        guard let key = currentKey else {
            return
        }

        storableValues[key] = value
        propertyTypes[key]  = type
    }
    
    func setCurrent<T: Mappable>(reader: Reader?, forType type: T.Type) {
        guard let key = currentKey else {
            return
        }
        
        mappables[key]     = reader
        propertyTypes[key] = T.self
    }
    
    func setCurrent<T: Mappable>(readers: [Reader]?, forType type: T.Type) {
        guard let key = currentKey else {
            return
        }
        
        mappableArrays[key] = readers
        propertyTypes[key]  = [T].self
    }

    subscript(key: String) -> Reader {
        currentKey = key
        
        return self
    }
}


// MARK: - Storable properties


func <- <T: StorableProperty>(left: inout T, right: Reader) {
    right.setCurrent(value: left.rawValue)
}

func <- <T: StorableProperty>(left: inout T?, right: Reader) {
    right.setCurrent(value: left?.rawValue)
}

func <- <T: StorableProperty>(left: inout T!, right: Reader) {
    right.setCurrent(value: left?.rawValue)
}

// MARK: Array of storable properties


func <- <T: StorableProperty>(left: inout [T], right: Reader) {
    right.setCurrent(value: jsonForCollection(left), forType: [T].self)
}

func <- <T: StorableProperty>(left: inout [T]?, right: Reader) {
    right.setCurrent(value: jsonForCollection(left), forType: [T].self)
}

func <- <T: StorableProperty>(left: inout [T]!, right: Reader) {
    right.setCurrent(value: jsonForCollection(left), forType: [T].self)
}


// MARK: Set of storable properties


func <- <T: StorableProperty>(left: inout Set<T>, right: Reader) {
    right.setCurrent(value: jsonForCollection(left)!, forType: Set<T>.self)
}

func <- <T: StorableProperty>(left: inout Set<T>?, right: Reader) {
    right.setCurrent(value: jsonForCollection(left), forType: Set<T>.self)
}

func <- <T: StorableProperty>(left: inout Set<T>!, right: Reader) {
    right.setCurrent(value: jsonForCollection(left), forType: Set<T>.self)
}

// MARK: Storable property dicitonaries


func <- <T: StorableProperty, U: StorableProperty>(left: inout [T: U], right: Reader) where T.RawValue: Hashable {
    right.setCurrent(value: jsonForDictionary(left) )
}

func <- <T: StorableProperty, U: StorableProperty>(left: inout [T: U]?, right: Reader) where T.RawValue: Hashable {
    right.setCurrent(value: jsonForDictionary(left) )
}

func <- <T: StorableProperty, U: StorableProperty>(left: inout [T: U]!, right: Reader) where T.RawValue: Hashable {
    right.setCurrent(value: jsonForDictionary(left) )
}



// MARK: - Mappable objects


func <- <T: Mappable>(left: inout T, right: Reader) {
    let reader = ObjectMapper.read(left)
    
    right.storableValues[right.currentKey!] = reader.identifierValue

    right.setCurrent(reader: reader, forType: T.self)
}

func <- <T: Mappable>(left: inout T?, right: Reader) {
    var reader: Reader? = nil
    
    if let object = left {
        reader = ObjectMapper.read(object)
    }
    
    right.storableValues[right.currentKey!] = reader?.identifierValue
    
    right.setCurrent(reader: reader, forType: T.self)
}

func <- <T: Mappable>(left: inout T!, right: Reader) {
    var reader: Reader? = nil
    
    if let object = left {
        reader = ObjectMapper.read(object)
    }
    
    right.storableValues[right.currentKey!] = reader?.identifierValue
    
    right.setCurrent(reader: reader, forType: T.self)
}


// MARK: Array of mappable objects

func <- <T: Mappable>(left: inout [T], right: Reader) {
    let readers = left.map { mappable -> Reader in
        return ObjectMapper.read(mappable)
    }
    
    let identifiers = readers.map { $0.identifierValue as! String }  //FIXME: Forced casting
    
    let JSON: String = jsonForCollection(identifiers)!
    
    right.setCurrent(value: JSON)
    right.setCurrent(readers: readers, forType: T.self)
}

func <- <T: Mappable>(left: inout [T]?, right: Reader) {
    let readers = left?.map { mappable -> Reader in
        return ObjectMapper.read(mappable)
    }
    
    let identifiers = readers?.map { $0.identifierValue as! String }  //FIXME: Forced casting
    
    let JSON: String? = jsonForCollection(identifiers)
    
    right.setCurrent(value: JSON)
    right.setCurrent(readers: readers, forType: T.self)
}

func <- <T: Mappable>(left: inout [T]!, right: Reader) {
    let readers = left.map { mappable -> Reader in
        return ObjectMapper.read(mappable)
    }
    
    let identifiers = readers.map { $0.identifierValue as! String }  //FIXME: Forced casting
    
    let JSON: String = jsonForCollection(identifiers)!
    
    right.setCurrent(value: JSON)
    right.setCurrent(readers: readers, forType: T.self)
}


// MARK: Set of mappable objects

func <- <T: Mappable>(left: inout Set<T>, right: Reader) {
    let readers = left.map { mappable -> Reader in
        return ObjectMapper.read(mappable)
    }
    
    let identifiers = readers.map { $0.identifierValue as! String }  //FIXME: Forced casting
    
    let JSON: String = jsonForCollection(identifiers)!
    
    right.setCurrent(value: JSON)
    right.setCurrent(readers: readers, forType: T.self)
}

func <- <T: Mappable>(left: inout Set<T>?, right: Reader) {
    let readers = left?.map { mappable -> Reader in
        return ObjectMapper.read(mappable)
    }
    
    let identifiers = readers?.map { $0.identifierValue as! String }  //FIXME: Forced casting
    
    let JSON = jsonForCollection(identifiers)
    
    right.setCurrent(value: JSON)
    right.setCurrent(readers: readers, forType: T.self)
}

func <- <T: Mappable>(left: inout Set<T>!, right: Reader) {
    let readers = left.map { mappable -> Reader in
        return ObjectMapper.read(mappable)
    }
    
    let identifiers = readers.map { $0.identifierValue as! String }  //FIXME: Forced casting
    
    let JSON = jsonForCollection(identifiers)
    
    right.setCurrent(value: JSON)
    right.setCurrent(readers: readers, forType: T.self)
}


// MARK: Helpers

private func jsonForCollection<C: Collection>(_ collection: C?) -> String? where C.Iterator.Element : StorableProperty {
    guard let collection = collection else {
        return nil
    }
    
    let storableValues = collection.map { $0.rawValue }
    
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






