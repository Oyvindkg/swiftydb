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
    case transform(String, (StorableValue?) -> StorableValue?)
}

internal class DefaultMigration: Migration, _Migration {
    
    var schemaVersion: UInt
    
    var operations: [MigrationOperation] = []
    
    init(schemaVersion: UInt) {
        self.schemaVersion = schemaVersion
    }
    
    func migrate(_ propertyName: String) -> PropertyMigration {
        return DefaultPropertyMigration(propertyName: propertyName, migration: self)
    }
    
    fileprivate func add(_ property: String, defaultValue: StorableValue?) {
        operations.append(
            MigrationOperation.add(property, defaultValue)
        )
    }
    
    func add<T : RawRepresentable>(_ property: String, defaultValue: T) where T.RawValue : StorableProperty {
        add(property, defaultValue: defaultValue.rawValue)
    }
    
    func add<T : RawRepresentable>(_ property: String, defaultValue: [T]) where T.RawValue : StorableProperty {
        add(property, defaultValue: defaultValue.map { $0.rawValue })
    }
    
    func add<T : RawRepresentable>(_ property: String, defaultValue: Set<T>) where T.RawValue : StorableProperty {
        add(property, defaultValue: Array(defaultValue))
    }
    
    func add<T : StorableProperty, U : RawRepresentable>(_ property: String, defaultValue: [T : U]) where U.RawValue : StorableProperty, T.StorableValueType : Hashable {
        var storableConvertibleDictionary: [T: U.RawValue] = [:]
        
        for (key, value) in defaultValue {
            storableConvertibleDictionary[key] = value.rawValue
        }
        
        add(property, defaultValue: storableConvertibleDictionary)
    }
    
    func add<T : StorableProperty>(_ property: String, defaultValue: T) {
        add(property, defaultValue: defaultValue.storableValue)
    }
    
    func add(_ property: String) {
        add(property, defaultValue: nil)
    }
    
    func add<T : StorableProperty>(_ property: String, defaultValue: [T]) {
        let storableValue = CollectionSerialization.stringFor(array: defaultValue)
        
        add(property, defaultValue: storableValue)
    }
    
    func add<T : StorableProperty, U : StorableProperty>(_ property: String, defaultValue: Dictionary<T, U>) where T.StorableValueType : Hashable {
        let storableValue = CollectionSerialization.stringFor(dictionary: defaultValue)
        
        add(property, defaultValue: storableValue)
    }
    
    func add<T : StorableProperty>(_ property: String, defaultValue: Set<T>) {
        add(property, defaultValue: Array(defaultValue))
    }
    
    func remove(_ property: String) {
        operations.append(
            .remove(property)
        )
    }
}
