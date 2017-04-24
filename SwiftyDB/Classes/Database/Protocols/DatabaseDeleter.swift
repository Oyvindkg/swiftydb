//
//  DatabaseDeleter.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 22/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

protocol DatabaseDeleter {
    func delete(query: AnyQuery) throws
}
