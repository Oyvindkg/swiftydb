//
//  StorableDate.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 22/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    
    return dateFormatter
}()

extension Date: StorableProperty {
    
    public typealias RawValue = String
    
    public var rawValue: String {
        return dateFormatter.string(from: self)
    }
    
    public init?(rawValue: RawValue) {
        guard let date = dateFormatter.date(from: rawValue) else {
            return nil
        }
        
        self = date
    }
}
