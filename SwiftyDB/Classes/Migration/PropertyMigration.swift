//
//  PropertyMigration.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 10/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

/* Represents the migration of a single property */

internal class PropertyMigration: PropertyMigrationType {
    
    let propertyName: String
    var newPropertyName: String?
    
    var migration: _MigrationType
    
    var transformation: (StoreableValue? -> StoreableValue?)?
    
    init(propertyName: String, migration: _MigrationType) {
        self.propertyName = propertyName
        self.migration    = migration
    }
    
    func rename(newPropertyName: String) -> PropertyMigrationType {
        migration.operations.append(
            .Rename(propertyName, newPropertyName)
        )
        
        return self
    }

    func transform<U : StoreableValueConvertible, V : StoreableValueConvertible>(fromType: U.Type, _ transformer: U? -> V?) -> PropertyMigrationType {
        let transformation: StoreableValue? -> V.StoreableValueType? = { storeableValue in
            let previousValue: U? = self.valueFromStoreableValue(storeableValue as? U.StoreableValueType)
            
            return transformer(previousValue)?.storeableValue
        }
        
        migration.operations.append(
            MigrationOperation.Transform(newPropertyName ?? propertyName, transformation)
        )
        
        return self
    }
//
//    func transform<U: StoreableValueConvertible, V: StoreableValueConvertible>(previousType: [U].Type, to currentType: [V].Type, _ transform: [U]? -> [V]?) -> PropertyMigrationType {
//        
//        self.transformation = { storeableValue in
//            let previousValue: [U]? = self.arrayFromStoreableValue(storeableValue)
//            
//            return self.storeableValueFromStoreableValueArray( transform(previousValue) )
//        }
//        
//        return self
//    }
//    
//    func transform<U : StoreableValueConvertible, V : StoreableValueConvertible>(previousType: Set<U>.Type, to currentType: Set<V>.Type, _ transform: Set<U>? -> Set<V>?) -> PropertyMigrationType {
//        self.transformation = { storeableValue in
//            let previousValue: Set<U>? = self.setFromStoreableValue(storeableValue)
//            
//            return self.storeableValueFromStoreableValueSet( transform(previousValue) )
//        }
//        
//        return self
//    }
//    
//    
//    // MARK: - Helpers
//    
    private func valueFromStoreableValue<T: StoreableValueConvertible>(storeableValue: T.StoreableValueType?) -> T? {
        guard storeableValue != nil else {
            return nil
        }
        
        return T.fromStoreableValue(storeableValue!)
    }
//
//    private func setFromStoreableValue<T: StoreableValueConvertible>(storeableValue: StoreableValue?) -> Set<T>? {
//        if let array: [T] = self.arrayFromStoreableValue(storeableValue) {
//            return Set(array)
//        }
//        
//        return nil
//    }
//    
//    private func storeableValueFromStoreableValueSet<T: StoreableValueConvertible>(set: Set<T>?) -> String? {
//        guard set != nil else {
//            return nil
//        }
//        
//        return JSONSerialisation.JSONFor( set!.map { $0.storeableValue } )
//    }
//    
//    private func arrayFromStoreableValue<T: StoreableValueConvertible>(storeableValue: StoreableValue?) -> [T]? {
//        if let stringValue = storeableValue as? String {
//            let storeableValueArray: [T.StoreableValueType] = JSONSerialisation.arrayFor(stringValue)
//            
//            return storeableValueArray.map { T.fromStoreableValue($0) }
//        }
//        
//        return nil
//    }
//    
//    private func storeableValueFromStoreableValueArray<T: StoreableValueConvertible>(array: [T]?) -> String? {
//        guard array != nil else {
//            return nil
//        }
//        
//        return JSONSerialisation.JSONFor( array!.map { $0.storeableValue } )
//    }
}
