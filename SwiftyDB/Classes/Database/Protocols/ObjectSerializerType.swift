//
//  ObjectSerializerType.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 08/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

protocol ObjectSerializerType {
    static func readersForStorable<T: Storable>(storable: T?) -> [Reader]
}
