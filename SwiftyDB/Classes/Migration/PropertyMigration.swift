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
    
    var transformation: ((StorableValue?) -> StorableValue?)?
    
    init(propertyName: String, migration: _MigrationType) {
        self.propertyName = propertyName
        self.migration    = migration
    }
    
    func rename(_ newPropertyName: String) -> PropertyMigrationType {
        self.newPropertyName = newPropertyName
        
        migration.operations.append(
            .rename(propertyName, newPropertyName)
        )
        
        return self
    }
    
    func transform<U : StorableProperty, V : StorableProperty>(_ fromType: U.Type, _ transformer: @escaping (U?) -> V?) -> PropertyMigrationType {
        let transformation: (StorableValue?) -> V.StorableValueType? = { storableValue in
            let previousValue: U? = self.valueFromStorableValue(storableValue)
            
            return transformer(previousValue)?.storableValue
        }
        
        addTransformation(transformation)
        
        return self
    }
    
    
    // MARK: - Raw representables
    
    func transform<U : RawRepresentable, V : RawRepresentable>(_ fromType: U.Type, _ transformer: @escaping (U?) -> V?) -> PropertyMigrationType where U.RawValue: StorableProperty, V.RawValue: StorableProperty {
        
        let transformation: (StorableValue?) -> V.RawValue.StorableValueType? = { storableValue in
            let previousValue: U? = self.rawRepresentableFromStorableValue(storableValue)
            
            return transformer(previousValue)?.rawValue.storableValue
        }
        
        addTransformation(transformation)
        
        return self
    }
    
    func transform<U : RawRepresentable, V : StorableProperty>(_ fromType: U.Type, _ transformer: @escaping (U?) -> V?) -> PropertyMigrationType where U.RawValue : StorableProperty {
        let transformation: (StorableValue?) -> V.StorableValueType? = { storableValue in
            let previousValue: U? = self.rawRepresentableFromStorableValue(storableValue)
            
            return transformer(previousValue)?.storableValue
        }
        
        addTransformation(transformation)
        
        return self
    }
    
    func transform<U : StorableProperty, V : RawRepresentable>(_ fromType: U.Type, _ transformer: @escaping (U?) -> V?) -> PropertyMigrationType where V.RawValue : StorableProperty {
        let transformation: (StorableValue?) -> V.RawValue.StorableValueType? = { storableValue in
            let previousValue: U? = self.valueFromStorableValue(storableValue)
            
            return transformer(previousValue)?.rawValue.storableValue
        }
        
        addTransformation(transformation)
        
        return self
    }
    
    
    // MARK: - Helpers
    
    fileprivate func addTransformation(_ transformation: @escaping (StorableValue?) -> StorableValue?) {
        migration.operations.append(
            .transform(newPropertyName ?? propertyName, transformation)
        )
    }
    

    fileprivate func valueFromStorableValue<T: StorableProperty>(_ storableValue: StorableValue?) -> T? {
        guard let storableValue = storableValue as? T.StorableValueType else {
            return nil
        }
        
        return T.from(storableValue: storableValue)
    }
    
    fileprivate func rawRepresentableFromStorableValue<T: RawRepresentable>(_ storableValue: StorableValue?) -> T? where T.RawValue: StorableProperty {
        guard let storableValue = storableValue as? T.RawValue.StorableValueType else {
            return nil
        }
        
        let rawValue = T.RawValue.from(storableValue: storableValue)
        
        return T.init(rawValue: rawValue)
    }
}
