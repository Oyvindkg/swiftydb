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

extension NSDate: StoreableValueConvertible {
    
    public typealias StoreableValueType = String
    
    public var storeableValue: StoreableValueType {
        return dateFormatter.stringFromDate(self)
    }
    
    public static func fromStoreableValue(storeableValue: StoreableValueType) -> Self {
        return fromStoreableValueHelper(storeableValue)
    }
    
    private static func fromStoreableValueHelper<T>(storeableValue: StoreableValueType) -> T {
        return dateFormatter.dateFromString(storeableValue) as! T
    }
}