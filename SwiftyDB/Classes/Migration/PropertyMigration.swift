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
    
    var transformation: (StoreableValue? -> StoreableValue?)?
    
    
    init(propertyName: String) {
        self.propertyName = propertyName
    }
    
    
    func rename(newPropertyName: String) -> PropertyMigrationType {
        self.newPropertyName = newPropertyName
        
        return self
    }
    
    func transform<U: StoreableValueConvertible, V: StoreableValueConvertible>(previousType: U.Type, to currentType: V.Type, _ transform: U? -> V?) -> PropertyMigrationType {
        
        self.transformation = { storeableValue in
            assert(storeableValue is U.StoreableValueType, "Data from the database doesnt match the previous type provided")
            
            let previousValue: U? = self.valueFromStoreableValue(storeableValue as? U.StoreableValueType)
            
            return transform(previousValue)?.storeableValue
        }
        
        return self
    }
    
    func transform<U: StoreableValueConvertible, V: StoreableValueConvertible>(previousType: [U].Type, to currentType: [V].Type, _ transform: [U]? -> [V]?) -> PropertyMigrationType {
        
        self.transformation = { storeableValue in
            let previousValue: [U]? = self.arrayFromStoreableValue(storeableValue)
            
            return self.storeableValueFromStoreableValueArray( transform(previousValue) )
        }
        
        return self
    }
    
    func transform<U : StoreableValueConvertible, V : StoreableValueConvertible>(previousType: Set<U>.Type, to currentType: Set<V>.Type, _ transform: Set<U>? -> Set<V>?) -> PropertyMigrationType {
        self.transformation = { storeableValue in
            let previousValue: Set<U>? = self.setFromStoreableValue(storeableValue)
            
            return self.storeableValueFromStoreableValueSet( transform(previousValue) )
        }
        
        return self
    }
    
    
    // MARK: - Helpers
    
    private func valueFromStoreableValue<T: StoreableValueConvertible>(storeableValue: T.StoreableValueType?) -> T? {
        guard storeableValue != nil else {
            return nil
        }
        
        return T.fromStoreableValue(storeableValue!)
    }
    
    private func setFromStoreableValue<T: StoreableValueConvertible>(storeableValue: StoreableValue?) -> Set<T>? {
        if let array: [T] = self.arrayFromStoreableValue(storeableValue) {
            return Set(array)
        }
        
        return nil
    }
    
    private func storeableValueFromStoreableValueSet<T: StoreableValueConvertible>(set: Set<T>?) -> String? {
        guard set != nil else {
            return nil
        }
        
        return JSONSerialisation.JSONFor( set!.map { $0.storeableValue } )
    }
    
    private func arrayFromStoreableValue<T: StoreableValueConvertible>(storeableValue: StoreableValue?) -> [T]? {
        if let stringValue = storeableValue as? String {
            let storeableValueArray: [T.StoreableValueType] = JSONSerialisation.arrayFor(stringValue)
            
            return storeableValueArray.map { T.fromStoreableValue($0) }
        }
        
        return nil
    }
    
    private func storeableValueFromStoreableValueArray<T: StoreableValueConvertible>(array: [T]?) -> String? {
        guard array != nil else {
            return nil
        }
        
        return JSONSerialisation.JSONFor( array!.map { $0.storeableValue } )
    }
}
