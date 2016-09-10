//
//  DatabaseIndexerType.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 08/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

protocol DatabaseIndexerType {
    func create(index: _IndexInstanceType) throws
}