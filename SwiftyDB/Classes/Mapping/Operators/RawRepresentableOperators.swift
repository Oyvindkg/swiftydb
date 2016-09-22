//
//  RawRepresentableOperators.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 29/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

// MARK: - Raw representables

public func <- <T: RawRepresentable>(left: inout T, right: Map) where T.RawValue: StorableProperty {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: RawRepresentable>(left: inout T, right: Reader) where T.RawValue: StorableProperty {
    right.setCurrentValue(left.rawValue.storableValue)
}

func <- <T: RawRepresentable>(left: inout T, right: Writer) where T.RawValue: StorableProperty {
    let storableValue: T.RawValue.StorableValueType = right.getCurrentValue()!
    
    left = rawRepresentableFromStorableValue(storableValue)!
}


public func <- <T: RawRepresentable>(left: inout T?, right: Map) where T.RawValue: StorableProperty {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: RawRepresentable>(left: inout T?, right: Reader) where T.RawValue: StorableProperty {
    right.setCurrentValue(left?.rawValue.storableValue)
}

func <- <T: RawRepresentable>(left: inout T?, right: Writer) where T.RawValue: StorableProperty {
    if let storableValue: T.RawValue.StorableValueType = right.getCurrentValue() {
        left = rawRepresentableFromStorableValue(storableValue)
    } else {
        left = nil
    }
}


public func <- <T: RawRepresentable>(left: inout T!, right: Map) where T.RawValue: StorableProperty {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: RawRepresentable>(left: inout T!, right: Reader) where T.RawValue: StorableProperty {
    right.setCurrentValue(left?.rawValue.storableValue)
}

func <- <T: RawRepresentable>(left: inout T!, right: Writer) where T.RawValue: StorableProperty {
    if let storableValue: T.RawValue.StorableValueType = right.getCurrentValue() {
        left = rawRepresentableFromStorableValue(storableValue)
    } else {
        left = nil
    }
}

// MARK: Array of raw representables

public func <- <T: RawRepresentable>(left: inout [T], right: Map) where T.RawValue: StorableProperty {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: RawRepresentable>(left: inout [T], right: Reader) where T.RawValue: StorableProperty {
    let storableValues = left.map { $0.rawValue.storableValue }
    
    right.setCurrentValue(storableValues)
}

func <- <T: RawRepresentable>(left: inout [T], right: Writer) where T.RawValue: StorableProperty {
    let storableValues: [T.RawValue.StorableValueType] = right.getCurrentValue()!
    
    left = storableValues.map(rawRepresentableFromStorableValue)
}


public func <- <T: RawRepresentable>(left: inout [T]?, right: Map) where T.RawValue: StorableProperty {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: RawRepresentable>(left: inout [T]?, right: Reader) where T.RawValue: StorableProperty {
    let storableValues = left?.map { $0.rawValue.storableValue }
    
    right.setCurrentValue(storableValues)
}

func <- <T: RawRepresentable>(left: inout [T]?, right: Writer) where T.RawValue: StorableProperty {
    if let storableValues: [T.RawValue.StorableValueType] = right.getCurrentValue() {
        left = storableValues.map(rawRepresentableFromStorableValue)
    } else {
        left = nil
    }
}


public func <- <T: RawRepresentable>(left: inout [T]!, right: Map) where T.RawValue: StorableProperty {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: RawRepresentable>(left: inout [T]!, right: Reader) where T.RawValue: StorableProperty {
    let storableValues = left?.map { $0.rawValue.storableValue }
    
    right.setCurrentValue(storableValues)
}

func <- <T: RawRepresentable>(left: inout [T]!, right: Writer) where T.RawValue: StorableProperty {
    if let storableValues: [T.RawValue.StorableValueType] = right.getCurrentValue() {
        left = storableValues.map(rawRepresentableFromStorableValue)
    } else {
        left = nil
    }
}

// MARK: Set of raw representables


//func <- <T: RawRepresentable where T.RawValue: StorableProperty>(inout left: Set<T>, right: Map) {
//    if right.mode == .Read {
//        right.currentValue = left.map { $0.rawValue.storableValue }
//    } else {
//        let storableValues = right.currentValue as! [T.RawValue.StorableValueType]
//
//        left = Set(storableValues.map(rawRepresentableFromStorableValue))
//    }
//}
//
//func <- <T: RawRepresentable where T.RawValue: StorableProperty>(inout left: Set<T>?, right: Map) {
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
//func <- <T: RawRepresentable where T.RawValue: StorableProperty>(inout left: Set<T>!, right: Map) {
//    if right.mode == .Read {
//        right.currentValue = left?.map { $0.rawValue.storableValue }
//    } else {
//        let storableValues = right.currentValue as! [T.RawValue.StorableValueType]
//
//        left = Set(storableValues.map(rawRepresentableFromStorableValue))
//    }
//}


// MARK: Helpers

private func rawRepresentableFromStorableValue <T: RawRepresentable> (_ storableValue: T.RawValue.StorableValueType) -> T where T.RawValue: StorableProperty {
    let rawValue = T.RawValue.from(storableValue: storableValue)
    
    return T.init(rawValue: rawValue)!
}

private func rawRepresentableFromStorableValue <T: RawRepresentable> (_ storableValue: T.RawValue.StorableValueType?) -> T? where T.RawValue: StorableProperty {
    guard storableValue != nil else {
        return nil
    }
    
    let rawValue = T.RawValue.from(storableValue: storableValue!)
    
    return T.init(rawValue: rawValue)
}
