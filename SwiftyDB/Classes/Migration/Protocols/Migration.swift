//
//  MigrationType.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 10/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

/**
 An interface used to define migrations
 */
public protocol Migration {
    
    /** The current schema version for the type */
    var schemaVersion: UInt { get set }
    
    /** Create a property migration used to rename or transform existing properties */
    func migrate(property: String) -> PropertyMigration
    
    /** Add a new property without a default value */
    func add(property: String)
    
    /** Add a new property with a default value */
    func add<T: StorableProperty>(property: String, defaultValue: T)
    
    /** Add a new array property with a default value */
    func add<T: StorableProperty>(property: String, defaultValue: [T])
    
    /** Add a new set property with a default value */
    func add<T: StorableProperty>(property: String, defaultValue: Set<T>)
    
    /** Add a new dictionary property with a default value */
    func add<T: StorableProperty, U: StorableProperty>(property: String, defaultValue: Dictionary<T, U>) where T.StorableValueType: Hashable
    
    /** Add a new raw representable property with a default value */
    func add<T: RawRepresentable>(property: String, defaultValue: T) where T.RawValue: StorableProperty
    
    /** Add a new raw representable array property with a default value */
    func add<T: RawRepresentable>(property: String, defaultValue: [T]) where T.RawValue: StorableProperty
    
    /** Add a new raw representable set property with a default value */
    func add<T: RawRepresentable>(property: String, defaultValue: Set<T>) where T.RawValue: StorableProperty
    
    /** Add a new raw representable dictionary property with a default value */
    func add<T: StorableProperty, U: RawRepresentable>(property: String, defaultValue: [T : U]) where U.RawValue : StorableProperty, T.StorableValueType : Hashable
    
    /** Remove an exsisting property */
    func remove(property: String)
}

/** And internal migration representation */
protocol _Migration {
    var operations: [MigrationOperation] { get set }
}
