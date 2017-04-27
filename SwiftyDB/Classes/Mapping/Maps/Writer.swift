//
//  Writer.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 22/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation


final class Writer: Mapper {

    let type: Mappable.Type
    var currentKey: String?
    
    var storableValues: [String: StorableValue]         = [:]
    var storableValueArrays: [String: [StorableValue?]] = [:]
    
    var mappables: [String: Writer]        = [:]
    var mappableArrays: [String: [Writer]] = [:]
    
    init(type: Mappable.Type) {
        self.type = type
    }
    
    func getCurrentValue<T: StorableValue>() -> T? {
        guard let key = currentKey else {
            return nil
        }
        
        return storableValues[key] as? T
    }
    
    func getCurrentValue<T: StorableValue>() -> [T]? {
        guard let key = currentKey else {
            return nil
        }
        
        return storableValueArrays[key]?.map { $0 as! T }
    }
    
    func getCurrentValue<T: Writer>() -> T? {
        guard let key = currentKey else {
            return nil
        }

        return mappables[key] as? T
    }
    
    
    func getCurrentValue() -> [Writer]? {
        guard let key = currentKey else {
            return nil
        }
        
        return mappableArrays[key]
    }

    subscript(key: String) -> Writer {
        currentKey = key
        
        return self
    }
}



// MARK: - Storable properties

func <- <T: StorableProperty>(left: inout T, right: Writer) {
    if let storableValue: T.RawValue = right.getCurrentValue() {
        left = T(rawValue: storableValue)!
    }
}

func <- <T: StorableProperty>(left: inout T?, right: Writer) {
    if let storableValue: T.RawValue = right.getCurrentValue() {
        left = T(rawValue: storableValue)
    } else {
        left = nil
    }
}

func <- <T: StorableProperty>(left: inout T!, right: Writer) {
    if let storableValue: T.RawValue = right.getCurrentValue() {
        left = T(rawValue: storableValue)
    } else {
        left = nil
    }
}

// MARK: Array of storable properties

func <- <T: StorableProperty>(left: inout [T], right: Writer) {
    left = arrayFromJson(right.getCurrentValue()!)!
}

func <- <T: StorableProperty>(left: inout [T]?, right: Writer) {
    left = arrayFromJson(right.getCurrentValue())
}

func <- <T: StorableProperty>(left: inout [T]!, right: Writer) {
    left = arrayFromJson(right.getCurrentValue())
}


// MARK: Set of storable properties

func <- <T: StorableProperty>(left: inout Set<T>, right: Writer) {
    let storableProperties: [T] = arrayFromJson(right.getCurrentValue())!
    
    left = Set(storableProperties)
}

func <- <T: StorableProperty>(left: inout Set<T>?, right: Writer) {
    guard let storableProperties: [T] = arrayFromJson(right.getCurrentValue()) else {
        left = nil
        
        return
    }
    
    left = Set(storableProperties)
}

func <- <T: StorableProperty>(left: inout Set<T>!, right: Writer) {
    guard let storableProperties: [T] = arrayFromJson(right.getCurrentValue()) else {
        left = nil
        
        return
    }
    
    left = Set(storableProperties)
}


// MARK: Storable value dicitonaries


func <- <T: StorableProperty, U: StorableProperty>(left: inout [T: U], right: Writer) where T.RawValue: Hashable {
    left = dictionaryFromJson( right.getCurrentValue() )!
}

func <- <T: StorableProperty, U: StorableProperty>(left: inout [T: U]?, right: Writer) where T.RawValue: Hashable {
    left = dictionaryFromJson( right.getCurrentValue() )
}

func <- <T: StorableProperty, U: StorableProperty>(left: inout [T: U]!, right: Writer) where T.RawValue: Hashable {
    left = dictionaryFromJson( right.getCurrentValue() )
}




// MARK: - Mappable objects


func <- <T: Mappable>(left: inout T, right: Writer) {
    var writer: Writer = right.getCurrentValue()!
    
    left = ObjectMapper.object(mappedBy: &writer)
}

func <- <T: Mappable>(left: inout T?, right: Writer) {
    var object: T? = nil
    
    if var writer: Writer = right.getCurrentValue() {
        object = ObjectMapper.object(mappedBy: &writer) as T
    }
    
    left = object
}

func <- <T: Mappable>(left: inout T!, right: Writer) {
    var object: T? = nil
    
    if var writer: Writer = right.getCurrentValue() {
        object = ObjectMapper.object(mappedBy:  &writer) as T
    }
    
    left = object
}


// MARK: Array of mappable objects

func <- <T: Mappable>(left: inout [T], right: Writer) {
    let writers: [Writer] = right.getCurrentValue()!
    
    left = ObjectMapper.objects(mappedBy: writers)
}

func <- <T: Mappable>(left: inout [T]?, right: Writer) {
    if let writers: [Writer] = right.getCurrentValue() {
        left = ObjectMapper.objects(mappedBy: writers)
    } else {
        left = nil
    }
}

func <- <T: Mappable>(left: inout [T]!, right: Writer) {
    if let writers: [Writer] = right.getCurrentValue() {
        left = ObjectMapper.objects(mappedBy: writers)
    } else {
        left = nil
    }
}

// MARK: Set of mappable objects

func <- <T: Mappable>(left: inout Set<T>, right: Writer) {
    let writers: [Writer] = right.getCurrentValue()!
    
    left = Set(ObjectMapper.objects(mappedBy: writers))
}

func <- <T: Mappable>(left: inout Set<T>?, right: Writer) {
    if let writers: [Writer] = right.getCurrentValue() {
        left = Set(ObjectMapper.objects(mappedBy: writers))
    } else {
        left = nil
    }
}

func <- <T: Mappable>(left: inout Set<T>!, right: Writer) {
    if let writers: [Writer] = right.getCurrentValue() {
        left = Set(ObjectMapper.objects(mappedBy: writers))
    } else {
        left = nil
    }
}


private func arrayFromJson<T: StorableProperty>(_ json: String?) -> [T]? {
    if json == nil {
        return nil
    }
    
    let jsonData = json!.data(using: .utf8)!
    
    let storableValues = try! JSONSerialization.jsonObject(with: jsonData, options: []) as! [T.RawValue]
    
    return storableValues.map { T(rawValue: $0)! }
}


private func dictionaryFromJson<T: StorableProperty, U: StorableProperty>(_ json: String?) -> [T: U]? where T : Hashable, T.RawValue : Hashable {
    if json == nil {
        return nil
    }
    
    let jsonData = json!.data(using: .utf8)!
    
    let storableValueDictionary = try! JSONSerialization.jsonObject(with: jsonData, options: []) as! [T.RawValue: U.RawValue]
    
    return storableValueDictionary.map { (key, value) -> (T, U) in
        return (T(rawValue: key)!, U(rawValue: value)!)
    }
}








