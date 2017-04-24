//
//  IndexerType.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 10/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

protocol TypeIndexer {
    func indexTypeIfNecessary(_ type: Storable.Type, in database: Database) throws
}
