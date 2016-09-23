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
    
    func migrate(property: String) -> PropertyMigration {
        return DefaultPropertyMigration(propertyName: property, migration: self)
    }
    
    fileprivate func add(property: String, defaultValue: StorableValue?) {
        operations.append(
            MigrationOperation.add(property, defaultValue)
        )
    }
    
    func add<T : RawRepresentable>(property: String, defaultValue: T) where T.RawValue : StorableProperty {
        add(property: property, defaultValue: defaultValue.rawValue)
    }
    
    func add<T : RawRepresentable>(property: String, defaultValue: [T]) where T.RawValue : StorableProperty {
        add(property: property, defaultValue: defaultValue.map { $0.rawValue })
    }
    
    func add<T : RawRepresentable>(property: String, defaultValue: Set<T>) where T.RawValue : StorableProperty {
        add(property: property, defaultValue: Array(defaultValue))
    }
    
    func add<T : StorableProperty, U : RawRepresentable>(property: String, defaultValue: [T : U]) where U.RawValue : StorableProperty, T.StorableValueType : Hashable {
        var storableConvertibleDictionary: [T: U.RawValue] = [:]
        
        for (key, value) in defaultValue {
            storableConvertibleDictionary[key] = value.rawValue
        }
        
        add(property: property, defaultValue: storableConvertibleDictionary)
    }
    
    func add<T : StorableProperty>(property: String, defaultValue: T) {
        add(property: property, defaultValue: defaultValue.storableValue)
    }
    
    func add(property: String) {
        add(property: property, defaultValue: nil)
    }
    
    func add<T : StorableProperty>(property: String, defaultValue: [T]) {
        let storableValue = CollectionSerialization.stringFor(array: defaultValue)
        
        add(property: property, defaultValue: storableValue)
    }
    
    func add<T : StorableProperty, U : StorableProperty>(property: String, defaultValue: Dictionary<T, U>) where T.StorableValueType : Hashable {
        let storableValue = CollectionSerialization.stringFor(dictionary: defaultValue)
        
        add(property: property, defaultValue: storableValue)
    }
    
    func add<T : StorableProperty>(property: String, defaultValue: Set<T>) {
        add(property: property, defaultValue: Array(defaultValue))
    }
    
    func remove(property: String) {
        operations.append(
            .remove(property)
        )
    }
}
