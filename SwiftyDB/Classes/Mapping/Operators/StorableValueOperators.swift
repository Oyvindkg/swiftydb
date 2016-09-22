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

public func <- <T: StorableProperty>(left: inout T, right: MapType) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: StorableProperty>(left: inout T, right: Reader) {
    right.setCurrentValue(left.storableValue)
}

func <- <T: StorableProperty>(left: inout T, right: Writer) {
    if let storableValue: T.StorableValueType = right.getCurrentValue() {
        left = T.fromStorableValue(storableValue)
    }
}


public func <- <T: StorableProperty>(left: inout T?, right: MapType) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: StorableProperty>(left: inout T?, right: Reader) {
    right.setCurrentValue(left?.storableValue)
}

func <- <T: StorableProperty>(left: inout T?, right: Writer) {
    if let storableValue: T.StorableValueType = right.getCurrentValue() {
        left = T.fromStorableValue(storableValue)
    } else {
        left = nil
    }
}


public func <- <T: StorableProperty>(left: inout T!, right: MapType) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: StorableProperty>(left: inout T!, right: Reader) {
    right.setCurrentValue(left?.storableValue)
}

func <- <T: StorableProperty>(left: inout T!, right: Writer) {
    if let storableValue: T.StorableValueType = right.getCurrentValue() {
        left = T.fromStorableValue(storableValue)
    } else {
        left = nil
    }
}

// MARK: Array of storable properties

public func <- <T: StorableProperty>(left: inout [T], right: MapType) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: StorableProperty>(left: inout [T], right: Reader) {
    right.setCurrentValue( JSONSerialisation.JSONFor(left)!, forType: [T].self  )
}

func <- <T: StorableProperty>(left: inout [T], right: Writer) {
    left = JSONSerialisation.arrayFor( right.getCurrentValue()! )
}


public func <- <T: StorableProperty>(left: inout [T]?, right: MapType) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: StorableProperty>(left: inout [T]?, right: Reader) {
    right.setCurrentValue( JSONSerialisation.JSONFor(left), forType: [T].self  )
}

func <- <T: StorableProperty>(left: inout [T]?, right: Writer) {
    left = JSONSerialisation.arrayFor( right.getCurrentValue() )
}


public func <- <T: StorableProperty>(left: inout [T]!, right: MapType) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: StorableProperty>(left: inout [T]!, right: Reader) {
    right.setCurrentValue( JSONSerialisation.JSONFor(left), forType: [T].self )
}

func <- <T: StorableProperty>(left: inout [T]!, right: Writer) {
    left = JSONSerialisation.arrayFor( right.getCurrentValue() )
}


// MARK: Set of storable properties

public func <- <T: StorableProperty>(left: inout Set<T>, right: MapType) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: StorableProperty>(left: inout Set<T>, right: Reader) {
    right.setCurrentValue(JSONSerialisation.JSONFor(collection: left)!, forType: Set<T>.self)
}

func <- <T: StorableProperty>(left: inout Set<T>, right: Writer) {
    let storableValues: [T.StorableValueType] = right.getCurrentValue()!
        
    left = Set( storableValues.map(T.fromStorableValue) )
}


public func <- <T: StorableProperty>(left: inout Set<T>?, right: MapType) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: StorableProperty>(left: inout Set<T>?, right: Reader) {
    right.setCurrentValue(JSONSerialisation.JSONFor(collection: left), forType: Set<T>.self)
}

func <- <T: StorableProperty>(left: inout Set<T>?, right: Writer) {
    if let storableValues: [T.StorableValueType] = right.getCurrentValue() {
        left = Set( storableValues.map(T.fromStorableValue) )
    } else {
        left = nil
    }
}


public func <- <T: StorableProperty>(left: inout Set<T>!, right: MapType) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: StorableProperty>(left: inout Set<T>!, right: Reader) {
    right.setCurrentValue(JSONSerialisation.JSONFor(collection: left), forType: Set<T>.self)
}

func <- <T: StorableProperty>(left: inout Set<T>!, right: Writer) {
    if let storableValues: [T.StorableValueType] = right.getCurrentValue() {
        left = Set( storableValues.map(T.fromStorableValue) )
    } else {
        left = nil
    }
}


// MARK: Storable value dicitonaries

public func <- <T: StorableProperty, U: StorableProperty>(left: inout [T: U], right: MapType) where T.StorableValueType: Hashable {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: StorableProperty, U: StorableProperty>(left: inout [T: U], right: Reader) where T.StorableValueType: Hashable {
    
    right.setCurrentValue( JSONSerialisation.JSONFor(Optional(left)), forType: [T: U].self  )
}

func <- <T: StorableProperty, U: StorableProperty>(left: inout [T: U], right: Writer) where T.StorableValueType: Hashable {
    left = JSONSerialisation.dictionaryFor( right.getCurrentValue()! )
}


public func <- <T: StorableProperty, U: StorableProperty>(left: inout [T: U]?, right: MapType) where T.StorableValueType: Hashable {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: StorableProperty, U: StorableProperty>(left: inout [T: U]?, right: Reader) where T.StorableValueType: Hashable {
    right.setCurrentValue( JSONSerialisation.JSONFor(left), forType: [T: U].self  )
}

func <- <T: StorableProperty, U: StorableProperty>(left: inout [T: U]?, right: Writer) where T.StorableValueType: Hashable {
    left = JSONSerialisation.dictionaryFor( right.getCurrentValue() )
}


public func <- <T: StorableProperty, U: StorableProperty>(left: inout [T: U]!, right: MapType) where T.StorableValueType: Hashable {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: StorableProperty, U: StorableProperty>(left: inout [T: U]!, right: Reader) where T.StorableValueType: Hashable {
    right.setCurrentValue( JSONSerialisation.JSONFor(left), forType: [T: U].self )
}

func <- <T: StorableProperty, U: StorableProperty>(left: inout [T: U]!, right: Writer) where T.StorableValueType: Hashable {
    left = JSONSerialisation.dictionaryFor( right.getCurrentValue() )
}

