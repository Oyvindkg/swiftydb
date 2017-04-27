//
//  SwiftyError.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 26/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

/** Errors thrown by SwiftyDB */
public enum SwiftyError: Error {
    
    /** Any migration related errors. A message describing the error will be provided */
    case migration(String)
}
