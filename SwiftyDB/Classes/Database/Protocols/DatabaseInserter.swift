//
//  DatabaseInserter.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 22/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

protocol DatabaseInserter {
    func add(readers: [Reader]) throws
}
