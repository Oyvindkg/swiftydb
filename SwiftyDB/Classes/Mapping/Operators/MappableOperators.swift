//
//  MappableOperators.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 29/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

// MARK: - Mappable objects

public func <- <T: Mappable>(left: inout T, right: Map) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: Mappable>(left: inout T, right: Reader) {
    let reader = Mapper.readerFor(object: left)
    
    right.storableValues[right.currentKey!] = reader.identifierValue
    
    right.setCurrentValue(reader, forType: T.self)
}

func <- <T: Mappable>(left: inout T, right: Writer) {
    let writer: Writer = right.getCurrentValue()!
    
    left = Mapper.objectFor(writer: writer)
}


public func <- <T: Mappable>(left: inout T?, right: Map) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: Mappable>(left: inout T?, right: Reader) {
    var reader: Reader? = nil
    
    if let object = left {
        reader = Mapper.readerFor(object: object)
    }
    
    right.storableValues[right.currentKey!] = reader?.identifierValue
    
    right.setCurrentValue(reader, forType: T.self)
}

func <- <T: Mappable>(left: inout T?, right: Writer) {
    var object: T? = nil
    
    if let writer: Writer = right.getCurrentValue() {
        object = Mapper.objectFor(writer: writer) as T
    }
    
    left = object
}


public func <- <T: Mappable>(left: inout T!, right: Map) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: Mappable>(left: inout T!, right: Reader) {
    var reader: Reader? = nil
    
    if let object = left {
        reader = Mapper.readerFor(object: object)
    }
    
    right.storableValues[right.currentKey!] = reader?.identifierValue
    
    right.setCurrentValue(reader, forType: T.self)
}

func <- <T: Mappable>(left: inout T!, right: Writer) {
    var object: T? = nil
    
    if let writer: Writer = right.getCurrentValue() {
        object = Mapper.objectFor(writer: writer) as T
    }
    
    left = object
}


// MARK: Array of mappable objects

public func <- <T: Mappable>(left: inout [T], right: Map) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: Mappable>(left: inout [T], right: Reader) {
    let maps = left.map { mappable -> Reader in
        return Mapper.readerFor(object: mappable)
    }
    
    let identifiers = maps.map {$0.identifierValue}
    
    let JSON: String = CollectionSerialization.stringFor(collection: identifiers)
    
    right.setCurrentValue(JSON)
        
    right.setCurrentValue(maps, forType: T.self)
}

func <- <T: Mappable>(left: inout [T], right: Writer) {
    let maps: [Writer] = right.getCurrentValue()!
    
    left = maps.map(Mapper.objectFor)
}


public func <- <T: Mappable>(left: inout [T]?, right: Map) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: Mappable>(left: inout [T]?, right: Reader) {
    let maps = left?.map { mappable -> Reader in
        return Mapper.readerFor(object: mappable)
    }
    
    let identifiers = maps?.map {$0.identifierValue}
    
    let JSON: String? = CollectionSerialization.stringFor(collection: identifiers)
    
    right.setCurrentValue(JSON)
    
    right.setCurrentValue(maps, forType: T.self)
}

func <- <T: Mappable>(left: inout [T]?, right: Writer) {
    if let maps: [Writer] = right.getCurrentValue() {
        left = Mapper.objectsFor(writers: maps)
    } else {
        left = nil
    }
}


public func <- <T: Mappable>(left: inout [T]!, right: Map) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: Mappable>(left: inout [T]!, right: Reader) {
    let maps = left.map { mappable -> Reader in
        return Mapper.readerFor(object: mappable)
    }
    
    let identifiers = maps.map {$0.identifierValue}
    
    let JSON: String = CollectionSerialization.stringFor(collection: identifiers)
    
    right.setCurrentValue(JSON)
    
    right.setCurrentValue(maps, forType: T.self)
}

func <- <T: Mappable>(left: inout [T]!, right: Writer) {
    let maps: [Writer]? = right.getCurrentValue()
    
    left = maps?.map(Mapper.objectFor)
}

// MARK: Array of mappable objects

public func <- <T: Mappable>(left: inout Set<T>, right: Map) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: Mappable>(left: inout Set<T>, right: Reader) {
    let maps = left.map { mappable -> Reader in
        return Mapper.readerFor(object: mappable)
    }
    
    let identifiers = maps.map {$0.identifierValue}
    
    let JSON: String = CollectionSerialization.stringFor(collection: identifiers)
    
    right.setCurrentValue(JSON)
    
    right.setCurrentValue(maps, forType: T.self)
}

func <- <T: Mappable>(left: inout Set<T>, right: Writer) {
    let maps: [Writer] = right.getCurrentValue()!
    
    left = Set(maps.map(Mapper.objectFor))
}


public func <- <T: Mappable>(left: inout Set<T>?, right: Map) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: Mappable>(left: inout Set<T>?, right: Reader) {
    let maps = left?.map { mappable -> Reader in
        return Mapper.readerFor(object: mappable)
    }
    
    let identifiers = maps?.map {$0.identifierValue}
    
    let JSON: String? = CollectionSerialization.stringFor(collection: identifiers)
    
    right.setCurrentValue(JSON)
    
    right.setCurrentValue(maps, forType: T.self)
}

func <- <T: Mappable>(left: inout Set<T>?, right: Writer) {
    if let maps: [Writer] = right.getCurrentValue() {
        left = Set(Mapper.objectsFor(writers: maps))
    } else {
        left = nil
    }
}


public func <- <T: Mappable>(left: inout Set<T>!, right: Map) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: Mappable>(left: inout Set<T>!, right: Reader) {
    let maps = left.map { mappable -> Reader in
        return Mapper.readerFor(object: mappable)
    }
    
    let identifiers = maps.map {$0.identifierValue}
    
    let JSON: String = CollectionSerialization.stringFor(collection: identifiers)
    
    right.setCurrentValue(JSON)
    
    right.setCurrentValue(maps, forType: T.self)
}

func <- <T: Mappable>(left: inout Set<T>!, right: Writer) {
    if let maps: [Writer] = right.getCurrentValue() {
        left = Set(maps.map(Mapper.objectFor))
    } else {
        left = nil
    }
    
}
