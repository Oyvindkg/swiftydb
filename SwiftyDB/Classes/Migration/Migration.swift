//
//  Migration.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 31/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

enum MigrationOperation {
    case add(String, StoreableValue?)
    case remove(String)
    case rename(String, String)
    case transform(String, StoreableValue? -> StoreableValue?)
}

internal class Migration: MigrationType, _MigrationType {
    
    var currentVersion: UInt
    
    var operations: [MigrationOperation] = []
    
    init(currentVersion: UInt) {
        self.currentVersion = currentVersion
    }
    
    func migrate(propertyName: String) -> PropertyMigrationType {
        return PropertyMigration(propertyName: propertyName, migration: self)
    }
    
    private func add(property: String, defaultValue: StoreableValue?) {
        operations.append(
            MigrationOperation.add(property, defaultValue)
        )
    }
    
    func add<T : RawRepresentable where T.RawValue : StoreableValueConvertible>(property: String, defaultValue: T) {
        add(property, defaultValue: defaultValue.rawValue)
    }
    
    func add<T : RawRepresentable where T.RawValue : StoreableValueConvertible>(property: String, defaultValue: [T]) {
        add(property, defaultValue: defaultValue.map { $0.rawValue })
    }
    
    func add<T : RawRepresentable where T.RawValue : StoreableValueConvertible>(property: String, defaultValue: Set<T>) {
        add(property, defaultValue: Array(defaultValue))
    }
    
    func add<T : StoreableValueConvertible, U : RawRepresentable where U.RawValue : StoreableValueConvertible, T.StoreableValueType : Hashable>(property: String, defaultValue: [T : U]) {
        var storeableConvertibleDictionary: [T: U.RawValue] = [:]
        
        for (key, value) in defaultValue {
            storeableConvertibleDictionary[key] = value.rawValue
        }
        
        add(property, defaultValue: storeableConvertibleDictionary)
    }
    
    func add<T : StoreableValueConvertible>(property: String, defaultValue: T) {
        add(property, defaultValue: defaultValue.storeableValue)
    }
    
    func add(property: String) {
        add(property, defaultValue: nil)
    }
    
    func add<T : StoreableValueConvertible>(property: String, defaultValue: [T]) {
        let storeableValue = JSONSerialisation.JSONFor(defaultValue)
        
        add(property, defaultValue: storeableValue)
    }
    
    func add<T : StoreableValueConvertible, U : StoreableValueConvertible where T.StoreableValueType : Hashable>(property: String, defaultValue: Dictionary<T, U>) {
        let storeableValue = JSONSerialisation.JSONFor(defaultValue)
        
        add(property, defaultValue: storeableValue)
    }
    
    func add<T : StoreableValueConvertible>(property: String, defaultValue: Set<T>) {
        add(property, defaultValue: Array(defaultValue))
    }
    
    func remove(property: String) {
        operations.append(
            .remove(property)
        )
    }
}
