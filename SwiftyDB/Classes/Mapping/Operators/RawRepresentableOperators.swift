//
//  RawRepresentableOperators.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 29/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

// MARK: - Raw representables

public func <- <T: RawRepresentable where T.RawValue: StoreableValueConvertible>(inout left: T, right: MapType) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: RawRepresentable where T.RawValue: StoreableValueConvertible>(inout left: T, right: Reader) {
    right.setCurrentValue(left.rawValue.storeableValue)
}

func <- <T: RawRepresentable where T.RawValue: StoreableValueConvertible>(inout left: T, right: Writer) {
    let storeableValue: T.RawValue.StoreableValueType = right.getCurrentValue()!
    
    left = rawRepresentableFromStoreableValue(storeableValue)!
}


public func <- <T: RawRepresentable where T.RawValue: StoreableValueConvertible>(inout left: T?, right: MapType) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: RawRepresentable where T.RawValue: StoreableValueConvertible>(inout left: T?, right: Reader) {
    right.setCurrentValue(left?.rawValue.storeableValue)
}

func <- <T: RawRepresentable where T.RawValue: StoreableValueConvertible>(inout left: T?, right: Writer) {
    if let storeableValue: T.RawValue.StoreableValueType = right.getCurrentValue() {
        left = rawRepresentableFromStoreableValue(storeableValue)
    } else {
        left = nil
    }
}


public func <- <T: RawRepresentable where T.RawValue: StoreableValueConvertible>(inout left: T!, right: MapType) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: RawRepresentable where T.RawValue: StoreableValueConvertible>(inout left: T!, right: Reader) {
    right.setCurrentValue(left?.rawValue.storeableValue)
}

func <- <T: RawRepresentable where T.RawValue: StoreableValueConvertible>(inout left: T!, right: Writer) {
    if let storeableValue: T.RawValue.StoreableValueType = right.getCurrentValue() {
        left = rawRepresentableFromStoreableValue(storeableValue)
    } else {
        left = nil
    }
}

// MARK: Array of raw representables

public func <- <T: RawRepresentable where T.RawValue: StoreableValueConvertible>(inout left: [T], right: MapType) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: RawRepresentable where T.RawValue: StoreableValueConvertible>(inout left: [T], right: Reader) {
    let storeableValues = left.map { $0.rawValue.storeableValue }
    
    right.setCurrentValue(storeableValues)
}

func <- <T: RawRepresentable where T.RawValue: StoreableValueConvertible>(inout left: [T], right: Writer) {
    let storeableValues: [T.RawValue.StoreableValueType] = right.getCurrentValue()!
    
    left = storeableValues.map(rawRepresentableFromStoreableValue)
}


public func <- <T: RawRepresentable where T.RawValue: StoreableValueConvertible>(inout left: [T]?, right: MapType) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: RawRepresentable where T.RawValue: StoreableValueConvertible>(inout left: [T]?, right: Reader) {
    let storeableValues = left?.map { $0.rawValue.storeableValue }
    
    right.setCurrentValue(storeableValues)
}

func <- <T: RawRepresentable where T.RawValue: StoreableValueConvertible>(inout left: [T]?, right: Writer) {
    if let storeableValues: [T.RawValue.StoreableValueType] = right.getCurrentValue() {
        left = storeableValues.map(rawRepresentableFromStoreableValue)
    } else {
        left = nil
    }
}


public func <- <T: RawRepresentable where T.RawValue: StoreableValueConvertible>(inout left: [T]!, right: MapType) {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: RawRepresentable where T.RawValue: StoreableValueConvertible>(inout left: [T]!, right: Reader) {
    let storeableValues = left?.map { $0.rawValue.storeableValue }
    
    right.setCurrentValue(storeableValues)
}

func <- <T: RawRepresentable where T.RawValue: StoreableValueConvertible>(inout left: [T]!, right: Writer) {
    if let storeableValues: [T.RawValue.StoreableValueType] = right.getCurrentValue() {
        left = storeableValues.map(rawRepresentableFromStoreableValue)
    } else {
        left = nil
    }
}

// MARK: Set of raw representables


//func <- <T: RawRepresentable where T.RawValue: StoreableValueConvertible>(inout left: Set<T>, right: MapType) {
//    if right.mode == .Read {
//        right.currentValue = left.map { $0.rawValue.storeableValue }
//    } else {
//        let storeableValues = right.currentValue as! [T.RawValue.StoreableValueType]
//
//        left = Set(storeableValues.map(rawRepresentableFromStoreableValue))
//    }
//}
//
//func <- <T: RawRepresentable where T.RawValue: StoreableValueConvertible>(inout left: Set<T>?, right: MapType) {
//    if right.mode == .Read {
//        right.currentValue = left?.map { $0.rawValue.storeableValue }
//    } else {
//        if let storeableValues = right.currentValue as? [T.RawValue.StoreableValueType] {
//            left = Set(storeableValues.map(rawRepresentableFromStoreableValue))
//        } else {
//            left = nil
//        }
//    }
//}
//
//func <- <T: RawRepresentable where T.RawValue: StoreableValueConvertible>(inout left: Set<T>!, right: MapType) {
//    if right.mode == .Read {
//        right.currentValue = left?.map { $0.rawValue.storeableValue }
//    } else {
//        let storeableValues = right.currentValue as! [T.RawValue.StoreableValueType]
//
//        left = Set(storeableValues.map(rawRepresentableFromStoreableValue))
//    }
//}


// MARK: Helpers

private func rawRepresentableFromStoreableValue <T: RawRepresentable where T.RawValue: StoreableValueConvertible> (storeableValue: T.RawValue.StoreableValueType) -> T {
    let rawValue = T.RawValue.fromStoreableValue(storeableValue)
    
    return T.init(rawValue: rawValue)!
}

private func rawRepresentableFromStoreableValue <T: RawRepresentable where T.RawValue: StoreableValueConvertible> (storeableValue: T.RawValue.StoreableValueType?) -> T? {
    guard storeableValue != nil else {
        return nil
    }
    
    let rawValue = T.RawValue.fromStoreableValue(storeableValue!)
    
    return T.init(rawValue: rawValue)
}