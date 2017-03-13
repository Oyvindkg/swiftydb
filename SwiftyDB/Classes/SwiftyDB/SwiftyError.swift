//
//  SwiftyError.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 26/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

public enum SwiftyError: Error {
    
    case query(String)
    case migration(String)
    case unknown(Error)
    
//    public var description: String {
//        switch self {
//        case .query(let message):
//            return message
//        case .migration(let message):
//            return message
//        case .unknown(let error):
//            return error.description
//        }
//    }
}
