//
//  IndexerType.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 10/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

protocol IndexerType {
    func indexTypeIfNecessary(type: Storable.Type, inSwifty swifty: Swifty) throws
}
