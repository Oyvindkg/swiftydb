//
//  Sorting.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 02/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

public enum Sorting {
    case none
    case ascending(on: String)
    case descending(on: String)
}
