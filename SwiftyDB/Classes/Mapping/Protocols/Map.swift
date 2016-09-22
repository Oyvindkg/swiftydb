//
//  Map.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 19/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

public protocol Map {
    subscript(key: String) -> Map { get }
}
