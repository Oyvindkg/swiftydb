//
//  DatabaseRetriever.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 22/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

protocol DatabaseRetriever {
    func get(query: AnyQuery) throws -> [Writer]
}
