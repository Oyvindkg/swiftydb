//
//  MappableOperators.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 29/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

// MARK: - Mappable objects


func <- <T: Mappable>(left: inout T, right: Reader) {
    let reader = ObjectMapper.read(left)
    
    right.storableValues[right.currentKey!] = reader.identifierValue
    
    right.setCurrent(reader: reader, forType: T.self)
}

func <- <T: Mappable>(left: inout T, right: Writer) {
    var writer: Writer = right.getCurrentValue()!
    
    left = ObjectMapper.object(for: &writer)
}



func <- <T: Mappable>(left: inout T?, right: Reader) {
    var reader: Reader? = nil
    
    if let object = left {
        reader = ObjectMapper.read(object)
    }
    
    right.storableValues[right.currentKey!] = reader?.identifierValue
    
    right.setCurrent(reader: reader, forType: T.self)
}

func <- <T: Mappable>(left: inout T?, right: Writer) {
    var object: T? = nil
    
    if var writer: Writer = right.getCurrentValue() {
        object = ObjectMapper.object(for: &writer) as T
    }
    
    left = object
}


func <- <T: Mappable>(left: inout T!, right: Reader) {
    var reader: Reader? = nil
    
    if let object = left {
        reader = ObjectMapper.read(object)
    }
    
    right.storableValues[right.currentKey!] = reader?.identifierValue

    right.setCurrent(reader: reader, forType: T.self)
}

func <- <T: Mappable>(left: inout T!, right: Writer) {
    var object: T? = nil
    
    if var writer: Writer = right.getCurrentValue() {
        object = ObjectMapper.object(for:  &writer) as T
    }
    
    left = object
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

func <- <T: Mappable>(left: inout [T], right: Writer) {
    let writers: [Writer] = right.getCurrentValue()!
    
    left = ObjectMapper.objects(forWriters: writers)
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

func <- <T: Mappable>(left: inout [T]?, right: Writer) {
    if let writers: [Writer] = right.getCurrentValue() {
        left = ObjectMapper.objects(forWriters: writers)
    } else {
        left = nil
    }
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

func <- <T: Mappable>(left: inout [T]!, right: Writer) {
    if let writers: [Writer] = right.getCurrentValue() {
        left = ObjectMapper.objects(forWriters: writers)
    } else {
        left = nil
    }
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

func <- <T: Mappable>(left: inout Set<T>, right: Writer) {
    let writers: [Writer] = right.getCurrentValue()!
    
    left = Set(ObjectMapper.objects(forWriters: writers))
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

func <- <T: Mappable>(left: inout Set<T>?, right: Writer) {
    if let writers: [Writer] = right.getCurrentValue() {
        left = Set(ObjectMapper.objects(forWriters: writers))
    } else {
        left = nil
    }
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

func <- <T: Mappable>(left: inout Set<T>!, right: Writer) {
    if let writers: [Writer] = right.getCurrentValue() {
        left = Set(ObjectMapper.objects(forWriters: writers))
    } else {
        left = nil
    }
    
}
