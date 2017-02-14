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
    let reader = Mapper.reader(for: left)
    
    right.storableValues[right.currentKey!] = reader.identifierValue
    
    right.setCurrent(reader: reader, forType: T.self)
}

func <- <T: Mappable>(left: inout T, right: Writer) {
    let writer: Writer = right.getCurrentValue()!
    
    left = Mapper.object(for: writer)
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
        reader = Mapper.reader(for: object)
    }
    
    right.storableValues[right.currentKey!] = reader?.identifierValue
    
    right.setCurrent(reader: reader, forType: T.self)
}

func <- <T: Mappable>(left: inout T?, right: Writer) {
    var object: T? = nil
    
    if let writer: Writer = right.getCurrentValue() {
        object = Mapper.object(for:  writer) as T
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
        reader = Mapper.reader(for: object)
    }
    
    right.storableValues[right.currentKey!] = reader?.identifierValue

    right.setCurrent(reader: reader, forType: T.self)
}

func <- <T: Mappable>(left: inout T!, right: Writer) {
    var object: T? = nil
    
    if let writer: Writer = right.getCurrentValue() {
        object = Mapper.object(for:  writer) as T
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
    let readers = left.map { mappable -> Reader in
        return Mapper.reader(for: mappable)
    }
    
    let identifiers = readers.map {$0.identifierValue}
    
    let JSON: String = CollectionSerialization.stringFor(collection: identifiers)
    
    right.setCurrent(value: JSON)
    right.setCurrent(readers: readers, forType: T.self)
}

func <- <T: Mappable>(left: inout [T], right: Writer) {
    let writers: [Writer] = right.getCurrentValue()!
    
    left = Mapper.objects(forWriters: writers)
}


public func <- <T: Mappable>(left: inout [T]?, right: Map) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: Mappable>(left: inout [T]?, right: Reader) {
    let readers = left?.map { mappable -> Reader in
        return Mapper.reader(for: mappable)
    }
    
    let identifiers = readers?.map {$0.identifierValue}
    
    let JSON: String? = CollectionSerialization.stringFor(collection: identifiers)
    
    right.setCurrent(value: JSON)
    right.setCurrent(readers: readers, forType: T.self)
}

func <- <T: Mappable>(left: inout [T]?, right: Writer) {
    if let writers: [Writer] = right.getCurrentValue() {
        left = Mapper.objects(forWriters: writers)
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
    let readers = left.map { mappable -> Reader in
        return Mapper.reader(for: mappable)
    }
    
    let identifiers = readers.map {$0.identifierValue}
    
    let JSON: String = CollectionSerialization.stringFor(collection: identifiers)
    
    right.setCurrent(value: JSON)
    right.setCurrent(readers: readers, forType: T.self)
}

func <- <T: Mappable>(left: inout [T]!, right: Writer) {
    if let writers: [Writer] = right.getCurrentValue() {
        left = Mapper.objects(forWriters: writers)
    } else {
        left = nil
    }
}

// MARK: Set of mappable objects

public func <- <T: Mappable>(left: inout Set<T>, right: Map) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: Mappable>(left: inout Set<T>, right: Reader) {
    let readers = left.map { mappable -> Reader in
        return Mapper.reader(for: mappable)
    }
    
    let identifiers = readers.map {$0.identifierValue}
    
    let JSON: String = CollectionSerialization.stringFor(collection: identifiers)
    
    right.setCurrent(value: JSON)
    right.setCurrent(readers: readers, forType: T.self)
}

func <- <T: Mappable>(left: inout Set<T>, right: Writer) {
    let writers: [Writer] = right.getCurrentValue()!
    
    left = Set(Mapper.objects(forWriters: writers))
}


public func <- <T: Mappable>(left: inout Set<T>?, right: Map) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: Mappable>(left: inout Set<T>?, right: Reader) {
    let readers = left?.map { mappable -> Reader in
        return Mapper.reader(for: mappable)
    }
    
    let identifiers = readers?.map {$0.identifierValue}
    
    let JSON: String? = CollectionSerialization.stringFor(collection: identifiers)
    
    right.setCurrent(value: JSON)
    right.setCurrent(readers: readers, forType: T.self)
}

func <- <T: Mappable>(left: inout Set<T>?, right: Writer) {
    if let writers: [Writer] = right.getCurrentValue() {
        left = Set(Mapper.objects(forWriters: writers))
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
    let readers = left.map { mappable -> Reader in
        return Mapper.reader(for: mappable)
    }
    
    let identifiers = readers.map {$0.identifierValue}
    
    let JSON: String = CollectionSerialization.stringFor(collection: identifiers)
    
    right.setCurrent(value: JSON)
    right.setCurrent(readers: readers, forType: T.self)
}

func <- <T: Mappable>(left: inout Set<T>!, right: Writer) {
    if let writers: [Writer] = right.getCurrentValue() {
        left = Set(Mapper.objects(forWriters: writers))
    } else {
        left = nil
    }
    
}
