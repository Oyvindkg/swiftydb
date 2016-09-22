//
//  RawRepresentableOperators.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 29/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

// MARK: - Raw representables

public func <- <T: RawRepresentable where T.RawValue: StorableValueConvertible>(inout left: T, right: MapType) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: RawRepresentable where T.RawValue: StorableValueConvertible>(inout left: T, right: Reader) {
    right.setCurrentValue(left.rawValue.storableValue)
}

func <- <T: RawRepresentable where T.RawValue: StorableValueConvertible>(inout left: T, right: Writer) {
    let storableValue: T.RawValue.StorableValueType = right.getCurrentValue()!
    
    left = rawRepresentableFromStorableValue(storableValue)!
}


public func <- <T: RawRepresentable where T.RawValue: StorableValueConvertible>(inout left: T?, right: MapType) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: RawRepresentable where T.RawValue: StorableValueConvertible>(inout left: T?, right: Reader) {
    right.setCurrentValue(left?.rawValue.storableValue)
}

func <- <T: RawRepresentable where T.RawValue: StorableValueConvertible>(inout left: T?, right: Writer) {
    if let storableValue: T.RawValue.StorableValueType = right.getCurrentValue() {
        left = rawRepresentableFromStorableValue(storableValue)
    } else {
        left = nil
    }
}


public func <- <T: RawRepresentable where T.RawValue: StorableValueConvertible>(inout left: T!, right: MapType) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: RawRepresentable where T.RawValue: StorableValueConvertible>(inout left: T!, right: Reader) {
    right.setCurrentValue(left?.rawValue.storableValue)
}

func <- <T: RawRepresentable where T.RawValue: StorableValueConvertible>(inout left: T!, right: Writer) {
    if let storableValue: T.RawValue.StorableValueType = right.getCurrentValue() {
        left = rawRepresentableFromStorableValue(storableValue)
    } else {
        left = nil
    }
}

// MARK: Array of raw representables

public func <- <T: RawRepresentable where T.RawValue: StorableValueConvertible>(inout left: [T], right: MapType) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: RawRepresentable where T.RawValue: StorableValueConvertible>(inout left: [T], right: Reader) {
    let storableValues = left.map { $0.rawValue.storableValue }
    
    right.setCurrentValue(storableValues)
}

func <- <T: RawRepresentable where T.RawValue: StorableValueConvertible>(inout left: [T], right: Writer) {
    let storableValues: [T.RawValue.StorableValueType] = right.getCurrentValue()!
    
    left = storableValues.map(rawRepresentableFromStorableValue)
}


public func <- <T: RawRepresentable where T.RawValue: StorableValueConvertible>(inout left: [T]?, right: MapType) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: RawRepresentable where T.RawValue: StorableValueConvertible>(inout left: [T]?, right: Reader) {
    let storableValues = left?.map { $0.rawValue.storableValue }
    
    right.setCurrentValue(storableValues)
}

func <- <T: RawRepresentable where T.RawValue: StorableValueConvertible>(inout left: [T]?, right: Writer) {
    if let storableValues: [T.RawValue.StorableValueType] = right.getCurrentValue() {
        left = storableValues.map(rawRepresentableFromStorableValue)
    } else {
        left = nil
    }
}


public func <- <T: RawRepresentable where T.RawValue: StorableValueConvertible>(inout left: [T]!, right: MapType) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: RawRepresentable where T.RawValue: StorableValueConvertible>(inout left: [T]!, right: Reader) {
    let storableValues = left?.map { $0.rawValue.storableValue }
    
    right.setCurrentValue(storableValues)
}

func <- <T: RawRepresentable where T.RawValue: StorableValueConvertible>(inout left: [T]!, right: Writer) {
    if let storableValues: [T.RawValue.StorableValueType] = right.getCurrentValue() {
        left = storableValues.map(rawRepresentableFromStorableValue)
    } else {
        left = nil
    }
}

// MARK: Set of raw representables


//func <- <T: RawRepresentable where T.RawValue: StorableValueConvertible>(inout left: Set<T>, right: MapType) {
//    if right.mode == .Read {
//        right.currentValue = left.map { $0.rawValue.storableValue }
//    } else {
//        let storableValues = right.currentValue as! [T.RawValue.StorableValueType]
//
//        left = Set(storableValues.map(rawRepresentableFromStorableValue))
//    }
//}
//
//func <- <T: RawRepresentable where T.RawValue: StorableValueConvertible>(inout left: Set<T>?, right: MapType) {
//    if right.mode == .Read {
//        right.currentValue = left?.map { $0.rawValue.storableValue }
//    } else {
//        if let storableValues = right.currentValue as? [T.RawValue.StorableValueType] {
//            left = Set(storableValues.map(rawRepresentableFromStorableValue))
//        } else {
//            left = nil
//        }
//    }
//}
//
//func <- <T: RawRepresentable where T.RawValue: StorableValueConvertible>(inout left: Set<T>!, right: MapType) {
//    if right.mode == .Read {
//        right.currentValue = left?.map { $0.rawValue.storableValue }
//    } else {
//        let storableValues = right.currentValue as! [T.RawValue.StorableValueType]
//
//        left = Set(storableValues.map(rawRepresentableFromStorableValue))
//    }
//}


// MARK: Helpers

private func rawRepresentableFromStorableValue <T: RawRepresentable where T.RawValue: StorableValueConvertible> (storableValue: T.RawValue.StorableValueType) -> T {
    let rawValue = T.RawValue.fromStorableValue(storableValue)
    
    return T.init(rawValue: rawValue)!
}

private func rawRepresentableFromStorableValue <T: RawRepresentable where T.RawValue: StorableValueConvertible> (storableValue: T.RawValue.StorableValueType?) -> T? {
    guard storableValue != nil else {
        return nil
    }
    
    let rawValue = T.RawValue.fromStorableValue(storableValue!)
    
    return T.init(rawValue: rawValue)
}
