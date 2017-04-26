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
    
//    func setCurrent<T: StorableValue>(values: [T]?, forType type: Any.Type = T.self) {
//        guard let key = currentKey else {
//            return
//        }
//        
//        storableValueArrays[key] = values?.map { $0 }
//        propertyTypes[key]       = [T].self
//    }
    
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
    right.setCurrent(value: left.storableValue)
}

func <- <T: StorableProperty>(left: inout T?, right: Reader) {
    right.setCurrent(value: left?.storableValue)
}

func <- <T: StorableProperty>(left: inout T!, right: Reader) {
    right.setCurrent(value: left?.storableValue)
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


// MARK: Storable value dicitonaries


func <- <T: StorableProperty, U: StorableProperty>(left: inout [T: U], right: Reader) where T.StorableValueType: Hashable {
    right.setCurrent(value: CollectionSerialization.stringFor(dictionary: Optional(left)), forType: [T: U].self  )
}

func <- <T: StorableProperty, U: StorableProperty>(left: inout [T: U]?, right: Reader) where T.StorableValueType: Hashable {
    right.setCurrent(value: CollectionSerialization.stringFor(dictionary: left), forType: [T: U].self  )
}

func <- <T: StorableProperty, U: StorableProperty>(left: inout [T: U]!, right: Reader) where T.StorableValueType: Hashable {
    right.setCurrent(value: CollectionSerialization.stringFor(dictionary: left), forType: [T: U].self )
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
    
    let identifiers = readers.map {$0.identifierValue}
    
    let JSON: String = CollectionSerialization.stringFor(collection: identifiers)
    
    right.setCurrent(value: JSON)
    right.setCurrent(readers: readers, forType: T.self)
}

func <- <T: Mappable>(left: inout [T]?, right: Reader) {
    let readers = left?.map { mappable -> Reader in
        return ObjectMapper.read(mappable)
    }
    
    let identifiers = readers?.map {$0.identifierValue}
    
    let JSON: String? = CollectionSerialization.stringFor(collection: identifiers)
    
    right.setCurrent(value: JSON)
    right.setCurrent(readers: readers, forType: T.self)
}

func <- <T: Mappable>(left: inout [T]!, right: Reader) {
    let readers = left.map { mappable -> Reader in
        return ObjectMapper.read(mappable)
    }
    
    let identifiers = readers.map {$0.identifierValue}
    
    let JSON: String = CollectionSerialization.stringFor(collection: identifiers)
    
    right.setCurrent(value: JSON)
    right.setCurrent(readers: readers, forType: T.self)
}


// MARK: Set of mappable objects

func <- <T: Mappable>(left: inout Set<T>, right: Reader) {
    let readers = left.map { mappable -> Reader in
        return ObjectMapper.read(mappable)
    }
    
    let identifiers = readers.map {$0.identifierValue}
    
    let JSON: String = CollectionSerialization.stringFor(collection: identifiers)
    
    right.setCurrent(value: JSON)
    right.setCurrent(readers: readers, forType: T.self)
}

func <- <T: Mappable>(left: inout Set<T>?, right: Reader) {
    let readers = left?.map { mappable -> Reader in
        return ObjectMapper.read(mappable)
    }
    
    let identifiers = readers?.map {$0.identifierValue}
    
    let JSON: String? = CollectionSerialization.stringFor(collection: identifiers)
    
    right.setCurrent(value: JSON)
    right.setCurrent(readers: readers, forType: T.self)
}

func <- <T: Mappable>(left: inout Set<T>!, right: Reader) {
    let readers = left.map { mappable -> Reader in
        return ObjectMapper.read(mappable)
    }
    
    let identifiers = readers.map {$0.identifierValue}
    
    let JSON: String = CollectionSerialization.stringFor(collection: identifiers)
    
    right.setCurrent(value: JSON)
    right.setCurrent(readers: readers, forType: T.self)
}


// MARK: - Raw representables


func <- <T: RawRepresentable>(left: inout T, right: Reader) where T.RawValue: StorableProperty {
    right.setCurrent(value: left.rawValue.storableValue)
}

func <- <T: RawRepresentable>(left: inout T?, right: Reader) where T.RawValue: StorableProperty {
    right.setCurrent(value: left?.rawValue.storableValue)
}

func <- <T: RawRepresentable>(left: inout T!, right: Reader) where T.RawValue: StorableProperty {
    right.setCurrent(value: left?.rawValue.storableValue)
}

// MARK: Array of raw representables


func <- <T: RawRepresentable>(left: inout [T], right: Reader) where T.RawValue: StorableProperty {
    let storableProperties = left.map { $0.rawValue }
    
    right.setCurrent(value: jsonForCollection(storableProperties), forType: Array<T>.self)
}

func <- <T: RawRepresentable>(left: inout [T]?, right: Reader) where T.RawValue: StorableProperty {
    let storableProperties = left?.map { $0.rawValue }
    
    right.setCurrent(value: jsonForCollection(storableProperties), forType: Array<T>.self)
}

func <- <T: RawRepresentable>(left: inout [T]!, right: Reader) where T.RawValue: StorableProperty {
    let storableProperties = left.map { $0.rawValue }
    
    right.setCurrent(value: jsonForCollection(storableProperties), forType: Array<T>.self)
}


// MARK: Set of raw representables


func <- <T: RawRepresentable>(left: inout Set<T>, right: Reader) where T.RawValue: StorableProperty {
    let storableProperties = left.map { $0.rawValue }
    
    right.setCurrent(value: jsonForCollection(storableProperties), forType: Set<T>.self)
}

func <- <T: RawRepresentable>(left: inout Set<T>?, right: Reader) where T.RawValue: StorableProperty {
    let storableProperties = left?.map { $0.rawValue }
    
    right.setCurrent(value: jsonForCollection(storableProperties), forType: Set<T>.self)
}

func <- <T: RawRepresentable>(left: inout Set<T>!, right: Reader) where T.RawValue: StorableProperty {
    let storableProperties = left?.map { $0.rawValue }
    
    right.setCurrent(value: jsonForCollection(storableProperties), forType: Set<T>.self)
}

// MARK: Helpers

private func jsonForCollection<C: Collection>(_ collection: C?) -> String? where C.Iterator.Element : StorableProperty {
    guard let collection = collection else {
        return nil
    }
    
    let storableValues = collection.map { $0.storableValue }
    
    let jsonData = try! JSONSerialization.data(withJSONObject: storableValues, options: [])
    
    return String(data: jsonData, encoding: .utf8)!
}






