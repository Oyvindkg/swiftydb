//
//  MigrationType.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 10/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

public protocol MigrationType {
    var currentVersion: UInt { get }
    
    func migrate(property: String) -> PropertyMigrationType
    
    func add(property: String)
    func add<T: StoreableValueConvertible>(property: String, defaultValue: T)
    func add<T: StoreableValueConvertible>(property: String, defaultValue: [T])
    func add<T: StoreableValueConvertible>(property: String, defaultValue: Set<T>)
    func add<T: StoreableValueConvertible, U: StoreableValueConvertible where T.StoreableValueType: Hashable>(property: String, defaultValue: Dictionary<T, U>)
    
    func add<T: RawRepresentable where T.RawValue: StoreableValueConvertible>(property: String, defaultValue: T)
    func add<T: RawRepresentable where T.RawValue: StoreableValueConvertible>(property: String, defaultValue: [T])
    func add<T: RawRepresentable where T.RawValue: StoreableValueConvertible>(property: String, defaultValue: Set<T>)
    func add<T: StoreableValueConvertible, U: RawRepresentable where U.RawValue : StoreableValueConvertible, T.StoreableValueType : Hashable>(property: String, defaultValue: [T : U])
    
    func remove(property: String)
}

protocol _MigrationType {
    var operations: [MigrationOperation] { get set }
}
