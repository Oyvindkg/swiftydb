//
//  Migration.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 31/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

enum MigrationOperation {
    case add(String, StorableValue?)
    case remove(String)
    case rename(String, String)
    case transform(String, StorableValue? -> StorableValue?)
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
    
    private func add(property: String, defaultValue: StorableValue?) {
        operations.append(
            MigrationOperation.add(property, defaultValue)
        )
    }
    
    func add<T : RawRepresentable where T.RawValue : StorableProperty>(property: String, defaultValue: T) {
        add(property, defaultValue: defaultValue.rawValue)
    }
    
    func add<T : RawRepresentable where T.RawValue : StorableProperty>(property: String, defaultValue: [T]) {
        add(property, defaultValue: defaultValue.map { $0.rawValue })
    }
    
    func add<T : RawRepresentable where T.RawValue : StorableProperty>(property: String, defaultValue: Set<T>) {
        add(property, defaultValue: Array(defaultValue))
    }
    
    func add<T : StorableProperty, U : RawRepresentable where U.RawValue : StorableProperty, T.StorableValueType : Hashable>(property: String, defaultValue: [T : U]) {
        var storableConvertibleDictionary: [T: U.RawValue] = [:]
        
        for (key, value) in defaultValue {
            storableConvertibleDictionary[key] = value.rawValue
        }
        
        add(property, defaultValue: storableConvertibleDictionary)
    }
    
    func add<T : StorableProperty>(property: String, defaultValue: T) {
        add(property, defaultValue: defaultValue.storableValue)
    }
    
    func add(property: String) {
        add(property, defaultValue: nil)
    }
    
    func add<T : StorableProperty>(property: String, defaultValue: [T]) {
        let storableValue = JSONSerialisation.JSONFor(defaultValue)
        
        add(property, defaultValue: storableValue)
    }
    
    func add<T : StorableProperty, U : StorableProperty where T.StorableValueType : Hashable>(property: String, defaultValue: Dictionary<T, U>) {
        let storableValue = JSONSerialisation.JSONFor(defaultValue)
        
        add(property, defaultValue: storableValue)
    }
    
    func add<T : StorableProperty>(property: String, defaultValue: Set<T>) {
        add(property, defaultValue: Array(defaultValue))
    }
    
    func remove(property: String) {
        operations.append(
            .remove(property)
        )
    }
}
