//
//  NSDate.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 20/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    
    return dateFormatter
}()

//extension Date: StorableProperty {
//    
//    public typealias RawValue = String
//    
//    public var rawValue: String {
//        return dateFormatter.string(from: self as Date)
//    }
//    
//    public init?(rawValue: RawValue) {
//        guard let date = dateFormatter.date(from: rawValue) else {
//            return nil
//        }
//        
//        self = date
//    }
//    public typealias StorableValueType = String
//    
//    public var storableValue: StorableValueType {
//    }
//    
//    public static func from(storableValue: StorableValueType) -> Self {
//        return fromHelper(storableValue: storableValue)
//    }
//    
//    private static func fromHelper<T>(storableValue: StorableValueType) -> T {
//        return dateFormatter.date(from: storableValue) as! T
//    }
//}
