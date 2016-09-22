//
//  Operators.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 19/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

infix operator <- {}

// MARK: - Storable properties

public func <- <T: StorableValueConvertible>(inout left: T, right: MapType) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: StorableValueConvertible>(inout left: T, right: Reader) {
    right.setCurrentValue(left.storableValue)
}

func <- <T: StorableValueConvertible>(inout left: T, right: Writer) {
    if let storableValue: T.StorableValueType = right.getCurrentValue() {
        left = T.fromStorableValue(storableValue)
    }
}


public func <- <T: StorableValueConvertible>(inout left: T?, right: MapType) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: StorableValueConvertible>(inout left: T?, right: Reader) {
    right.setCurrentValue(left?.storableValue)
}

func <- <T: StorableValueConvertible>(inout left: T?, right: Writer) {
    if let storableValue: T.StorableValueType = right.getCurrentValue() {
        left = T.fromStorableValue(storableValue)
    } else {
        left = nil
    }
}


public func <- <T: StorableValueConvertible>(inout left: T!, right: MapType) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: StorableValueConvertible>(inout left: T!, right: Reader) {
    right.setCurrentValue(left?.storableValue)
}

func <- <T: StorableValueConvertible>(inout left: T!, right: Writer) {
    if let storableValue: T.StorableValueType = right.getCurrentValue() {
        left = T.fromStorableValue(storableValue)
    } else {
        left = nil
    }
}

// MARK: Array of storable properties

public func <- <T: StorableValueConvertible>(inout left: [T], right: MapType) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: StorableValueConvertible>(inout left: [T], right: Reader) {
    right.setCurrentValue( JSONSerialisation.JSONFor(left)!, forType: [T].self  )
}

func <- <T: StorableValueConvertible>(inout left: [T], right: Writer) {
    left = JSONSerialisation.arrayFor( right.getCurrentValue()! )
}


public func <- <T: StorableValueConvertible>(inout left: [T]?, right: MapType) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: StorableValueConvertible>(inout left: [T]?, right: Reader) {
    right.setCurrentValue( JSONSerialisation.JSONFor(left), forType: [T].self  )
}

func <- <T: StorableValueConvertible>(inout left: [T]?, right: Writer) {
    left = JSONSerialisation.arrayFor( right.getCurrentValue() )
}


public func <- <T: StorableValueConvertible>(inout left: [T]!, right: MapType) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: StorableValueConvertible>(inout left: [T]!, right: Reader) {
    right.setCurrentValue( JSONSerialisation.JSONFor(left), forType: [T].self )
}

func <- <T: StorableValueConvertible>(inout left: [T]!, right: Writer) {
    left = JSONSerialisation.arrayFor( right.getCurrentValue() )
}


// MARK: Set of storable properties

public func <- <T: StorableValueConvertible>(inout left: Set<T>, right: MapType) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: StorableValueConvertible>(inout left: Set<T>, right: Reader) {
    right.setCurrentValue(JSONSerialisation.JSONFor(collection: left)!, forType: Set<T>.self)
}

func <- <T: StorableValueConvertible>(inout left: Set<T>, right: Writer) {
    let storableValues: [T.StorableValueType] = right.getCurrentValue()!
        
    left = Set( storableValues.map(T.fromStorableValue) )
}


public func <- <T: StorableValueConvertible>(inout left: Set<T>?, right: MapType) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: StorableValueConvertible>(inout left: Set<T>?, right: Reader) {
    right.setCurrentValue(JSONSerialisation.JSONFor(collection: left), forType: Set<T>.self)
}

func <- <T: StorableValueConvertible>(inout left: Set<T>?, right: Writer) {
    if let storableValues: [T.StorableValueType] = right.getCurrentValue() {
        left = Set( storableValues.map(T.fromStorableValue) )
    } else {
        left = nil
    }
}


public func <- <T: StorableValueConvertible>(inout left: Set<T>!, right: MapType) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: StorableValueConvertible>(inout left: Set<T>!, right: Reader) {
    right.setCurrentValue(JSONSerialisation.JSONFor(collection: left), forType: Set<T>.self)
}

func <- <T: StorableValueConvertible>(inout left: Set<T>!, right: Writer) {
    if let storableValues: [T.StorableValueType] = right.getCurrentValue() {
        left = Set( storableValues.map(T.fromStorableValue) )
    } else {
        left = nil
    }
}


// MARK: Storable value dicitonaries

public func <- <T: StorableValueConvertible, U: StorableValueConvertible where T.StorableValueType: Hashable>(inout left: [T: U], right: MapType) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: StorableValueConvertible, U: StorableValueConvertible where T.StorableValueType: Hashable>(inout left: [T: U], right: Reader) {
    
    right.setCurrentValue( JSONSerialisation.JSONFor(Optional(left)), forType: [T: U].self  )
}

func <- <T: StorableValueConvertible, U: StorableValueConvertible where T.StorableValueType: Hashable>(inout left: [T: U], right: Writer) {
    left = JSONSerialisation.dictionaryFor( right.getCurrentValue()! )
}


public func <- <T: StorableValueConvertible, U: StorableValueConvertible where T.StorableValueType: Hashable>(inout left: [T: U]?, right: MapType) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: StorableValueConvertible, U: StorableValueConvertible where T.StorableValueType: Hashable>(inout left: [T: U]?, right: Reader) {
    right.setCurrentValue( JSONSerialisation.JSONFor(left), forType: [T: U].self  )
}

func <- <T: StorableValueConvertible, U: StorableValueConvertible where T.StorableValueType: Hashable>(inout left: [T: U]?, right: Writer) {
    left = JSONSerialisation.dictionaryFor( right.getCurrentValue() )
}


public func <- <T: StorableValueConvertible, U: StorableValueConvertible where T.StorableValueType: Hashable>(inout left: [T: U]!, right: MapType) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: StorableValueConvertible, U: StorableValueConvertible where T.StorableValueType: Hashable>(inout left: [T: U]!, right: Reader) {
    right.setCurrentValue( JSONSerialisation.JSONFor(left), forType: [T: U].self )
}

func <- <T: StorableValueConvertible, U: StorableValueConvertible where T.StorableValueType: Hashable>(inout left: [T: U]!, right: Writer) {
    left = JSONSerialisation.dictionaryFor( right.getCurrentValue() )
}

