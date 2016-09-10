//
//  SwiftyError.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 26/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

enum SwiftyError: ErrorType, CustomStringConvertible {
    
    case Query(String)
    case Migration(String)
    case Unknown(String)
    
    var description: String {
        switch self {
        case .Query(let message):
            return message
        case .Migration(let message):
            return message
        case .Unknown(let message):
            return message
        }
    }
    
}