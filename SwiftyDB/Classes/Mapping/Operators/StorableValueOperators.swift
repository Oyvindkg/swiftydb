//
//  Operators.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 19/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

infix operator <-

// MARK: - Storable properties


func <- <T: StorableProperty>(left: inout T, right: Reader) {
    right.setCurrent(value: left.storableValue)
}

func <- <T: StorableProperty>(left: inout T, right: Writer) {
    if let storableValue: T.StorableValueType = right.getCurrentValue() {
        left = T.from(storableValue: storableValue)
    }
}

func <- <T: StorableProperty>(left: inout T?, right: Reader) {
    right.setCurrent(value: left?.storableValue)
}

func <- <T: StorableProperty>(left: inout T?, right: Writer) {
    if let storableValue: T.StorableValueType = right.getCurrentValue() {
        left = T.from(storableValue: storableValue)
    } else {
        left = nil
    }
}



func <- <T: StorableProperty>(left: inout T!, right: Reader) {
    right.setCurrent(value: left?.storableValue)
}

func <- <T: StorableProperty>(left: inout T!, right: Writer) {
    if let storableValue: T.StorableValueType = right.getCurrentValue() {
        left = T.from(storableValue: storableValue)
    } else {
        left = nil
    }
}

// MARK: Array of storable properties


func <- <T: StorableProperty>(left: inout [T], right: Reader) {
    right.setCurrent(value: jsonFromArray(left), forType: [T].self)
}

func <- <T: StorableProperty>(left: inout [T], right: Writer) {
    left = arrayFromJson(right.getCurrentValue()!)!
}

func arrayFromJson<T: StorableProperty>(_ json: String?) -> [T]? {
    if json == nil {
        return nil
    }
    
    let jsonData = json!.data(using: .utf8)!
    
    let storableValues = try! JSONSerialization.jsonObject(with: jsonData, options: []) as! [T.StorableValueType]
    
    return storableValues.map { T.from(storableValue: $0) }
}

func jsonFromArray<T: StorableProperty>(_ array: [T]?) -> String? {
    if array == nil {
        return nil
    }
    
    let storableValues = array!.map {$0.storableValue}
    
    let jsonData = try! JSONSerialization.data(withJSONObject: storableValues, options: [])
    
    return String(data: jsonData, encoding: .utf8)!
    
}



func <- <T: StorableProperty>(left: inout [T]?, right: Reader) {
    right.setCurrent(value: jsonFromArray(left), forType: [T].self)
}

func <- <T: StorableProperty>(left: inout [T]?, right: Writer) {
    left = arrayFromJson(right.getCurrentValue()!)
}


func <- <T: StorableProperty>(left: inout [T]!, right: Reader) {
    right.setCurrent(value: jsonFromArray(left), forType: [T].self)
}

func <- <T: StorableProperty>(left: inout [T]!, right: Writer) {
    left = arrayFromJson(right.getCurrentValue()!)
}


// MARK: Set of storable properties


func <- <T: StorableProperty>(left: inout Set<T>, right: Reader) {
    right.setCurrent(value: CollectionSerialization.stringFor(collection: left)!, forType: Set<T>.self)
}

func <- <T: StorableProperty>(left: inout Set<T>, right: Writer) {
    let storableValues: [T.StorableValueType] = right.getCurrentValue()!
        
    left = Set( storableValues.map(T.from) )
}


func <- <T: StorableProperty>(left: inout Set<T>?, right: Reader) {
    right.setCurrent(value: CollectionSerialization.stringFor(collection: left), forType: Set<T>.self)
}

func <- <T: StorableProperty>(left: inout Set<T>?, right: Writer) {
    if let storableValues: [T.StorableValueType] = right.getCurrentValue() {
        left = Set( storableValues.map(T.from) )
    } else {
        left = nil
    }
}


func <- <T: StorableProperty>(left: inout Set<T>!, right: Reader) {
    right.setCurrent(value: CollectionSerialization.stringFor(collection: left), forType: Set<T>.self)
}

func <- <T: StorableProperty>(left: inout Set<T>!, right: Writer) {
    if let storableValues: [T.StorableValueType] = right.getCurrentValue() {
        left = Set( storableValues.map(T.from) )
    } else {
        left = nil
    }
}


// MARK: Storable value dicitonaries


func <- <T: StorableProperty, U: StorableProperty>(left: inout [T: U], right: Reader) where T.StorableValueType: Hashable {
    
    right.setCurrent(value: CollectionSerialization.stringFor(dictionary: Optional(left)), forType: [T: U].self  )
}

func <- <T: StorableProperty, U: StorableProperty>(left: inout [T: U], right: Writer) where T.StorableValueType: Hashable {
    left = CollectionSerialization.dictionaryFor(string: right.getCurrentValue()! )
}


func <- <T: StorableProperty, U: StorableProperty>(left: inout [T: U]?, right: Reader) where T.StorableValueType: Hashable {
    right.setCurrent(value: CollectionSerialization.stringFor(dictionary: left), forType: [T: U].self  )
}

func <- <T: StorableProperty, U: StorableProperty>(left: inout [T: U]?, right: Writer) where T.StorableValueType: Hashable {
    left = CollectionSerialization.dictionaryFor(string: right.getCurrentValue() )
}



func <- <T: StorableProperty, U: StorableProperty>(left: inout [T: U]!, right: Reader) where T.StorableValueType: Hashable {
    right.setCurrent(value: CollectionSerialization.stringFor(dictionary: left), forType: [T: U].self )
}

func <- <T: StorableProperty, U: StorableProperty>(left: inout [T: U]!, right: Writer) where T.StorableValueType: Hashable {
    left = CollectionSerialization.dictionaryFor(string: right.getCurrentValue() )
}

