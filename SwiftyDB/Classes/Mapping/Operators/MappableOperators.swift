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
    let reader = Mapper.readerForObject(left)
    
    right.storableValues[right.currentKey!] = reader.identifierValue
    
    right.setCurrentValue(reader, forType: T.self)
}

func <- <T: Mappable>(left: inout T, right: Writer) {
    let writer: Writer = right.getCurrentValue()!
    
    left = Mapper.objectForWriter(writer)
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
        reader = Mapper.readerForObject(object)
    }
    
    right.storableValues[right.currentKey!] = reader?.identifierValue
    
    right.setCurrentValue(reader, forType: T.self)
}

func <- <T: Mappable>(left: inout T?, right: Writer) {
    var object: T? = nil
    
    if let writer: Writer = right.getCurrentValue() {
        object = Mapper.objectForWriter(writer) as T
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
        reader = Mapper.readerForObject(object)
    }
    
    right.storableValues[right.currentKey!] = reader?.identifierValue
    
    right.setCurrentValue(reader, forType: T.self)
}

func <- <T: Mappable>(left: inout T!, right: Writer) {
    var object: T? = nil
    
    if let writer: Writer = right.getCurrentValue() {
        object = Mapper.objectForWriter(writer) as T
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
        return Mapper.readerForObject(mappable)
    }
    
    let identifiers = maps.map {$0.identifierValue}
    
    let JSON: String = JSONSerialisation.JSONFor(collection: identifiers)
    
    right.setCurrentValue(JSON)
        
    right.setCurrentValue(maps, forType: T.self)
}

func <- <T: Mappable>(left: inout [T], right: Writer) {
    let maps: [Writer] = right.getCurrentValue()!
    
    left = maps.map(Mapper.objectForWriter)
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
        return Mapper.readerForObject(mappable)
    }
    
    let identifiers = maps?.map {$0.identifierValue}
    
    let JSON: String? = JSONSerialisation.JSONFor(collection: identifiers)
    
    right.setCurrentValue(JSON)
    
    right.setCurrentValue(maps, forType: T.self)
}

func <- <T: Mappable>(left: inout [T]?, right: Writer) {
    if let maps: [Writer] = right.getCurrentValue() {
        left = Mapper.objectsForWriters(maps)
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
        return Mapper.readerForObject(mappable)
    }
    
    let identifiers = maps.map {$0.identifierValue}
    
    let JSON: String = JSONSerialisation.JSONFor(collection: identifiers)
    
    right.setCurrentValue(JSON)
    
    right.setCurrentValue(maps, forType: T.self)
}

func <- <T: Mappable>(left: inout [T]!, right: Writer) {
    let maps: [Writer]? = right.getCurrentValue()
    
    left = maps?.map(Mapper.objectForWriter)
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
        return Mapper.readerForObject(mappable)
    }
    
    let identifiers = maps.map {$0.identifierValue}
    
    let JSON: String = JSONSerialisation.JSONFor(collection: identifiers)
    
    right.setCurrentValue(JSON)
    
    right.setCurrentValue(maps, forType: T.self)
}

func <- <T: Mappable>(left: inout Set<T>, right: Writer) {
    let maps: [Writer] = right.getCurrentValue()!
    
    left = Set(maps.map(Mapper.objectForWriter))
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
        return Mapper.readerForObject(mappable)
    }
    
    let identifiers = maps?.map {$0.identifierValue}
    
    let JSON: String? = JSONSerialisation.JSONFor(collection: identifiers)
    
    right.setCurrentValue(JSON)
    
    right.setCurrentValue(maps, forType: T.self)
}

func <- <T: Mappable>(left: inout Set<T>?, right: Writer) {
    if let maps: [Writer] = right.getCurrentValue() {
        left = Set(Mapper.objectsForWriters(maps))
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
        return Mapper.readerForObject(mappable)
    }
    
    let identifiers = maps.map {$0.identifierValue}
    
    let JSON: String = JSONSerialisation.JSONFor(collection: identifiers)
    
    right.setCurrentValue(JSON)
    
    right.setCurrentValue(maps, forType: T.self)
}

func <- <T: Mappable>(left: inout Set<T>!, right: Writer) {
    if let maps: [Writer] = right.getCurrentValue() {
        left = Set(maps.map(Mapper.objectForWriter))
    } else {
        left = nil
    }
    
}
