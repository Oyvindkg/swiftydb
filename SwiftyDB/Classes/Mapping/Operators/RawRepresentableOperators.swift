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
    right.setCurrent(value: left.rawValue.storableValue)
}

func <- <T: RawRepresentable>(left: inout T, right: Writer) where T.RawValue: StorableProperty {
    let storableValue: T.RawValue.StorableValueType = right.getCurrentValue()!
    
    left = rawRepresentableFromValue(storableValue)!
}


public func <- <T: RawRepresentable>(left: inout T?, right: Map) where T.RawValue: StorableProperty {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: RawRepresentable>(left: inout T?, right: Reader) where T.RawValue: StorableProperty {
    right.setCurrent(value: left?.rawValue.storableValue)
}

func <- <T: RawRepresentable>(left: inout T?, right: Writer) where T.RawValue: StorableProperty {
    if let storableValue: T.RawValue.StorableValueType = right.getCurrentValue() {
        left = rawRepresentableFromValue(storableValue)
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
    right.setCurrent(value: left?.rawValue.storableValue)
}

func <- <T: RawRepresentable>(left: inout T!, right: Writer) where T.RawValue: StorableProperty {
    if let storableValue: T.RawValue.StorableValueType = right.getCurrentValue() {
        left = rawRepresentableFromValue(storableValue)
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

    right.setCurrent(values: storableValues)
}

func <- <T: RawRepresentable>(left: inout [T], right: Writer) where T.RawValue: StorableProperty {
    let storableValues: [T.RawValue.StorableValueType] = right.getCurrentValue()!
    
    left = storableValues.map(rawRepresentableFromValue)
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
    
    right.setCurrent(values: storableValues)
}

func <- <T: RawRepresentable>(left: inout [T]?, right: Writer) where T.RawValue: StorableProperty {
    if let storableValues: [T.RawValue.StorableValueType] = right.getCurrentValue() {
        left = storableValues.map(rawRepresentableFromValue)
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
    
    right.setCurrent(values: storableValues)
}

func <- <T: RawRepresentable>(left: inout [T]!, right: Writer) where T.RawValue: StorableProperty {
    if let storableValues: [T.RawValue.StorableValueType] = right.getCurrentValue() {
        left = storableValues.map(rawRepresentableFromValue)
    } else {
        left = nil
    }
}

// MARK: Set of raw representables


public func <- <T: RawRepresentable>(left: inout Set<T>, right: Map) where T.RawValue: StorableProperty {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: RawRepresentable>(left: inout Set<T>, right: Reader) where T.RawValue: StorableProperty {
    let storableValues = left.map { $0.rawValue.storableValue }
    
    right.setCurrent(values: storableValues)
}

func <- <T: RawRepresentable>(left: inout Set<T>, right: Writer) where T.RawValue: StorableProperty {
    let storableValues: [T.RawValue.StorableValueType] = right.getCurrentValue()!
    
    left = Set(storableValues.map(rawRepresentableFromValue))
}


public func <- <T: RawRepresentable>(left: inout Set<T>?, right: Map) where T.RawValue: StorableProperty {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: RawRepresentable>(left: inout Set<T>?, right: Reader) where T.RawValue: StorableProperty {
    let storableValues = left?.map { $0.rawValue.storableValue }
    
    right.setCurrent(values: storableValues)
}

func <- <T: RawRepresentable>(left: inout Set<T>?, right: Writer) where T.RawValue: StorableProperty {
    if let storableValues: [T.RawValue.StorableValueType] = right.getCurrentValue() {
        left = Set(storableValues.map(rawRepresentableFromValue))
    } else {
        left = nil
    }
}


public func <- <T: RawRepresentable>(left: inout Set<T>!, right: Map) where T.RawValue: StorableProperty {
    if let reader = right as? Reader {
        left <- reader
    } else if let writer = right as? Writer {
        left <- writer
    }
}

func <- <T: RawRepresentable>(left: inout Set<T>!, right: Reader) where T.RawValue: StorableProperty {
    let storableValues = left?.map { $0.rawValue.storableValue }
    
    right.setCurrent(values: storableValues)
}

func <- <T: RawRepresentable>(left: inout Set<T>!, right: Writer) where T.RawValue: StorableProperty {
    if let storableValues: [T.RawValue.StorableValueType] = right.getCurrentValue() {
        left = Set(storableValues.map(rawRepresentableFromValue))
    } else {
        left = nil
    }
}

// MARK: Helpers

private func rawRepresentableFromValue <T: RawRepresentable> (_ storableValue: T.RawValue.StorableValueType) -> T where T.RawValue: StorableProperty {
    let rawValue = T.RawValue.from(storableValue: storableValue)
    
    return T.init(rawValue: rawValue)!
}

private func rawRepresentableFromValue <T: RawRepresentable> (_ storableValue: T.RawValue.StorableValueType?) -> T? where T.RawValue: StorableProperty {
    guard storableValue != nil else {
        return nil
    }
    
    let rawValue = T.RawValue.from(storableValue: storableValue!)
    
    return T.init(rawValue: rawValue)
}
