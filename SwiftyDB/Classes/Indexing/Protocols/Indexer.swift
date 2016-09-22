//
//  IndexerType.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 10/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

protocol Indexer {
    func indexIfNecessary(type: Storable.Type, inSwifty swifty: Swifty) throws
}
