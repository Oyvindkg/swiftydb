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
        self.newPropertyName = newPropertyName
        
        migration.operations.append(
            .rename(propertyName, newPropertyName)
        )
        
        return self
    }
    
    func transform<U : StoreableValueConvertible, V : StoreableValueConvertible>(fromType: U.Type, _ transformer: U? -> V?) -> PropertyMigrationType {
        let transformation: StoreableValue? -> V.StoreableValueType? = { storeableValue in
            let previousValue: U? = self.valueFromStoreableValue(storeableValue)
            
            return transformer(previousValue)?.storeableValue
        }
        
        addTransformation(transformation)
        
        return self
    }
    
    
    // MARK: - Raw representables
    
    func transform<U : RawRepresentable, V : RawRepresentable where U.RawValue: StoreableValueConvertible, V.RawValue: StoreableValueConvertible>(fromType: U.Type, _ transformer: U? -> V?) -> PropertyMigrationType {
        
        let transformation: StoreableValue? -> V.RawValue.StoreableValueType? = { storeableValue in
            let previousValue: U? = self.rawRepresentableFromStoreableValue(storeableValue)
            
            return transformer(previousValue)?.rawValue.storeableValue
        }
        
        addTransformation(transformation)
        
        return self
    }
    
    func transform<U : RawRepresentable, V : StoreableValueConvertible where U.RawValue : StoreableValueConvertible>(fromType: U.Type, _ transformer: U? -> V?) -> PropertyMigrationType {
        let transformation: StoreableValue? -> V.StoreableValueType? = { storeableValue in
            let previousValue: U? = self.rawRepresentableFromStoreableValue(storeableValue)
            
            return transformer(previousValue)?.storeableValue
        }
        
        addTransformation(transformation)
        
        return self
    }
    
    func transform<U : StoreableValueConvertible, V : RawRepresentable where V.RawValue : StoreableValueConvertible>(fromType: U.Type, _ transformer: U? -> V?) -> PropertyMigrationType {
        let transformation: StoreableValue? -> V.RawValue.StoreableValueType? = { storeableValue in
            let previousValue: U? = self.valueFromStoreableValue(storeableValue)
            
            return transformer(previousValue)?.rawValue.storeableValue
        }
        
        addTransformation(transformation)
        
        return self
    }
    
    
    // MARK: - Helpers
    
    private func addTransformation(transformation: StoreableValue? -> StoreableValue?) {
        migration.operations.append(
            .transform(newPropertyName ?? propertyName, transformation)
        )
    }
    

    private func valueFromStoreableValue<T: StoreableValueConvertible>(storeableValue: StoreableValue?) -> T? {
        guard let storeableValue = storeableValue as? T.StoreableValueType else {
            return nil
        }
        
        return T.fromStoreableValue(storeableValue)
    }
    
    private func rawRepresentableFromStoreableValue<T: RawRepresentable where T.RawValue: StoreableValueConvertible>(storeableValue: StoreableValue?) -> T? {
        guard let storeableValue = storeableValue as? T.RawValue.StoreableValueType else {
            return nil
        }
        
        let rawValue = T.RawValue.fromStoreableValue(storeableValue)
        
        return T.init(rawValue: rawValue)
    }
}
