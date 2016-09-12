//
//  Migration.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 31/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

enum MigrationOperation {
    case Add(String, StoreableValue?)
    case Remove(String)
    case Rename(String, String)
    case Transform(String, StoreableValue? -> StoreableValue?)
}

internal class Migration: MigrationType, _MigrationType {
    
    let currentVersion: UInt
    
    var operations: [MigrationOperation] = []
    
    init(currentVersion: UInt) {
        self.currentVersion = currentVersion
    }
    
    func migrate(propertyName: String) -> PropertyMigrationType {
        return PropertyMigration(propertyName: propertyName, migration: self)
    }
    
    private func add(property: String, defaultValue: StoreableValue?) {
        operations.append(
            MigrationOperation.Add(property, defaultValue)
        )
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
            .Remove(property)
        )
    }
}