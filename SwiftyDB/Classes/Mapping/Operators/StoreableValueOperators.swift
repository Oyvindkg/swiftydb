//
//  Operators.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 19/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

infix operator <- {}

// MARK: - Storeable properties

public func <- <T: StoreableValueConvertible>(inout left: T, right: MapType) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: StoreableValueConvertible>(inout left: T, right: Reader) {
    right.setCurrentValue(left.storeableValue)
}

func <- <T: StoreableValueConvertible>(inout left: T, right: Writer) {
    if let storeableValue: T.StoreableValueType = right.getCurrentValue() {
        left = T.fromStoreableValue(storeableValue)
    }
}


public func <- <T: StoreableValueConvertible>(inout left: T?, right: MapType) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: StoreableValueConvertible>(inout left: T?, right: Reader) {
    right.setCurrentValue(left?.storeableValue)
}

func <- <T: StoreableValueConvertible>(inout left: T?, right: Writer) {
    if let storeableValue: T.StoreableValueType = right.getCurrentValue() {
        left = T.fromStoreableValue(storeableValue)
    } else {
        left = nil
    }
}


public func <- <T: StoreableValueConvertible>(inout left: T!, right: MapType) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: StoreableValueConvertible>(inout left: T!, right: Reader) {
    right.setCurrentValue(left?.storeableValue)
}

func <- <T: StoreableValueConvertible>(inout left: T!, right: Writer) {
    if let storeableValue: T.StoreableValueType = right.getCurrentValue() {
        left = T.fromStoreableValue(storeableValue)
    } else {
        left = nil
    }
}

// MARK: Array of storeable properties

public func <- <T: StoreableValueConvertible>(inout left: [T], right: MapType) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: StoreableValueConvertible>(inout left: [T], right: Reader) {
    right.setCurrentValue( JSONSerialisation.JSONFor(left)! )
}

func <- <T: StoreableValueConvertible>(inout left: [T], right: Writer) {
    left = JSONSerialisation.arrayFor( right.getCurrentValue()! )
}


public func <- <T: StoreableValueConvertible>(inout left: [T]?, right: MapType) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: StoreableValueConvertible>(inout left: [T]?, right: Reader) {
    right.setCurrentValue( JSONSerialisation.JSONFor(left) )
}

func <- <T: StoreableValueConvertible>(inout left: [T]?, right: Writer) {
    left = JSONSerialisation.arrayFor( right.getCurrentValue() )
}


public func <- <T: StoreableValueConvertible>(inout left: [T]!, right: MapType) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: StoreableValueConvertible>(inout left: [T]!, right: Reader) {
    right.setCurrentValue( JSONSerialisation.JSONFor(left) )
}

func <- <T: StoreableValueConvertible>(inout left: [T]!, right: Writer) {
    left = JSONSerialisation.arrayFor( right.getCurrentValue() )
}


// MARK: Set of storeable properties

public func <- <T: StoreableValueConvertible>(inout left: Set<T>, right: MapType) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: StoreableValueConvertible>(inout left: Set<T>, right: Reader) {
    right.setCurrentValue(left.map { $0.storeableValue })
}

func <- <T: StoreableValueConvertible>(inout left: Set<T>, right: Writer) {
    let storeableValues: [T.StoreableValueType] = right.getCurrentValue()!
        
    left = Set( storeableValues.map(T.fromStoreableValue) )
}


public func <- <T: StoreableValueConvertible>(inout left: Set<T>?, right: MapType) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: StoreableValueConvertible>(inout left: Set<T>?, right: Reader) {
    right.setCurrentValue(left?.map { $0.storeableValue })
}

func <- <T: StoreableValueConvertible>(inout left: Set<T>?, right: Writer) {
    if let storeableValues: [T.StoreableValueType] = right.getCurrentValue() {
        left = Set( storeableValues.map(T.fromStoreableValue) )
    } else {
        left = nil
    }
}


public func <- <T: StoreableValueConvertible>(inout left: Set<T>!, right: MapType) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: StoreableValueConvertible>(inout left: Set<T>!, right: Reader) {
    right.setCurrentValue(left?.map { $0.storeableValue })
}

func <- <T: StoreableValueConvertible>(inout left: Set<T>!, right: Writer) {
    if let storeableValues: [T.StoreableValueType] = right.getCurrentValue() {
        left = Set( storeableValues.map(T.fromStoreableValue) )
    } else {
        left = nil
    }
}


// MARK: Storeable value dicitonaries

public func <- <T: StoreableValueConvertible, U: StoreableValueConvertible where T.StoreableValueType: Hashable>(inout left: [T: U], right: MapType) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: StoreableValueConvertible, U: StoreableValueConvertible where T.StoreableValueType: Hashable>(inout left: [T: U], right: Reader) {
    
    right.setCurrentValue( JSONSerialisation.JSONFor(Optional(left)) )
}

func <- <T: StoreableValueConvertible, U: StoreableValueConvertible where T.StoreableValueType: Hashable>(inout left: [T: U], right: Writer) {
    left = JSONSerialisation.dictionaryFor( right.getCurrentValue()! )
}


public func <- <T: StoreableValueConvertible, U: StoreableValueConvertible where T.StoreableValueType: Hashable>(inout left: [T: U]?, right: MapType) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: StoreableValueConvertible, U: StoreableValueConvertible where T.StoreableValueType: Hashable>(inout left: [T: U]?, right: Reader) {
    right.setCurrentValue( JSONSerialisation.JSONFor(left) )
}

func <- <T: StoreableValueConvertible, U: StoreableValueConvertible where T.StoreableValueType: Hashable>(inout left: [T: U]?, right: Writer) {
    left = JSONSerialisation.dictionaryFor( right.getCurrentValue() )
}


public func <- <T: StoreableValueConvertible, U: StoreableValueConvertible where T.StoreableValueType: Hashable>(inout left: [T: U]!, right: MapType) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: StoreableValueConvertible, U: StoreableValueConvertible where T.StoreableValueType: Hashable>(inout left: [T: U]!, right: Reader) {
    right.setCurrentValue( JSONSerialisation.JSONFor(left) )
}

func <- <T: StoreableValueConvertible, U: StoreableValueConvertible where T.StoreableValueType: Hashable>(inout left: [T: U]!, right: Writer) {
    left = JSONSerialisation.dictionaryFor( right.getCurrentValue() )
}

