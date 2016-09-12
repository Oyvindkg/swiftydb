//
//  MigrationType.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 10/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

public protocol MigrationType {
    func migrate(property: String) -> PropertyMigrationType
    
    func add(property: String)
    func add<T: StoreableValueConvertible>(property: String, defaultValue: T)
    func add<T: StoreableValueConvertible>(property: String, defaultValue: [T])
    func add<T: StoreableValueConvertible>(property: String, defaultValue: Set<T>)
    func add<T: StoreableValueConvertible, U: StoreableValueConvertible where T.StoreableValueType: Hashable>(property: String, defaultValue: Dictionary<T, U>)
    
    func remove(property: String)
    
    var currentVersion: UInt { get }
}

protocol _MigrationType {
    var operations: [MigrationOperation] { get set }
}
