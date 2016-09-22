//
//  NSDate.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 20/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

private let dateFormatter: NSDateFormatter = {
    let dateFormatter = NSDateFormatter()
    
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
    
    return dateFormatter
}()

extension NSDate: StorableValueConvertible {
    
    public typealias StorableValueType = String
    
    public var storableValue: StorableValueType {
        return dateFormatter.stringFromDate(self)
    }
    
    public static func fromStorableValue(storableValue: StorableValueType) -> Self {
        return fromStorableValueHelper(storableValue)
    }
    
    private static func fromStorableValueHelper<T>(storableValue: StorableValueType) -> T {
        return dateFormatter.dateFromString(storableValue) as! T
    }
}
