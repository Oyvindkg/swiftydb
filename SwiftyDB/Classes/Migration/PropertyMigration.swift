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
    
    var transformation: (StorableValue? -> StorableValue?)?
    
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
    
    func transform<U : StorableProperty, V : StorableProperty>(fromType: U.Type, _ transformer: U? -> V?) -> PropertyMigrationType {
        let transformation: StorableValue? -> V.StorableValueType? = { storableValue in
            let previousValue: U? = self.valueFromStorableValue(storableValue)
            
            return transformer(previousValue)?.storableValue
        }
        
        addTransformation(transformation)
        
        return self
    }
    
    
    // MARK: - Raw representables
    
    func transform<U : RawRepresentable, V : RawRepresentable where U.RawValue: StorableProperty, V.RawValue: StorableProperty>(fromType: U.Type, _ transformer: U? -> V?) -> PropertyMigrationType {
        
        let transformation: StorableValue? -> V.RawValue.StorableValueType? = { storableValue in
            let previousValue: U? = self.rawRepresentableFromStorableValue(storableValue)
            
            return transformer(previousValue)?.rawValue.storableValue
        }
        
        addTransformation(transformation)
        
        return self
    }
    
    func transform<U : RawRepresentable, V : StorableProperty where U.RawValue : StorableProperty>(fromType: U.Type, _ transformer: U? -> V?) -> PropertyMigrationType {
        let transformation: StorableValue? -> V.StorableValueType? = { storableValue in
            let previousValue: U? = self.rawRepresentableFromStorableValue(storableValue)
            
            return transformer(previousValue)?.storableValue
        }
        
        addTransformation(transformation)
        
        return self
    }
    
    func transform<U : StorableProperty, V : RawRepresentable where V.RawValue : StorableProperty>(fromType: U.Type, _ transformer: U? -> V?) -> PropertyMigrationType {
        let transformation: StorableValue? -> V.RawValue.StorableValueType? = { storableValue in
            let previousValue: U? = self.valueFromStorableValue(storableValue)
            
            return transformer(previousValue)?.rawValue.storableValue
        }
        
        addTransformation(transformation)
        
        return self
    }
    
    
    // MARK: - Helpers
    
    private func addTransformation(transformation: StorableValue? -> StorableValue?) {
        migration.operations.append(
            .transform(newPropertyName ?? propertyName, transformation)
        )
    }
    

    private func valueFromStorableValue<T: StorableProperty>(storableValue: StorableValue?) -> T? {
        guard let storableValue = storableValue as? T.StorableValueType else {
            return nil
        }
        
        return T.fromStorableValue(storableValue)
    }
    
    private func rawRepresentableFromStorableValue<T: RawRepresentable where T.RawValue: StorableProperty>(storableValue: StorableValue?) -> T? {
        guard let storableValue = storableValue as? T.RawValue.StorableValueType else {
            return nil
        }
        
        let rawValue = T.RawValue.fromStorableValue(storableValue)
        
        return T.init(rawValue: rawValue)
    }
}
