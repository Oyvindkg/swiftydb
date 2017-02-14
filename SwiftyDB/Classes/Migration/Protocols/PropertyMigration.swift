//
//  PropertyMigrationType.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 10/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

/** Type representing the migration of an existing property */
public protocol PropertyMigration {
    
    /**
     Rename the property
     
     - parameters:
        - newName: the new property name
     */
    func rename(to name: String) -> PropertyMigration
    
    /**
     Transform a property
     
     - parameters:
        - type: the type of the value currently in the database
        - transformer: a closure mapping the value from the database to its new value
     */
    func transformFrom<U: StorableProperty, V: StorableProperty>(_ type: U.Type, using transformer: @escaping (U?) -> V?) -> PropertyMigration
    
    /**
     Transform a property
     
     - parameters:
        - type: the type of the value currently in the database
        - transformer: a closure mapping the value from the database to its new value
     */
    func transformFrom<U: RawRepresentable, V: RawRepresentable>(_ type: U.Type, using transformer: @escaping (U?) -> V?) -> PropertyMigration where U.RawValue: StorableProperty, V.RawValue: StorableProperty
    
    /**
     Transform a property
     
     - parameters:
        - type: the type of the value currently in the database
        - transformer: a closure mapping the value from the database to its new value
     */
    func transformFrom<U: RawRepresentable, V: StorableProperty>(_ type: U.Type, using transformer: @escaping (U?) -> V?) -> PropertyMigration where U.RawValue: StorableProperty
    
    /**
     Transform a property
     
     - parameters:
        - type: the type of the value currently in the database
        - transformer: a closure mapping the value from the database to its new value
     */
    func transformFrom<U: StorableProperty, V: RawRepresentable>(_ type: U.Type, using transformer: @escaping (U?) -> V?) -> PropertyMigration where V.RawValue: StorableProperty
    
    
    
    
    
//    func transformArrayOf<U: StorableProperty, V: StorableProperty>(fromElementType: U.Type, _ transformer: Array<U>? -> Array<V>?) -> PropertyMigrationType
//    func transformSetOf<U: StorableProperty, V: StorableProperty>(fromElementType: U.Type, _ transformer: Set<U>? -> Set<V>?) -> PropertyMigrationType
//
//    func transformArray<U: RawRepresentable, V: StorableProperty>(fromElementType: U.Type, _ transformer: Array<U>? -> Array<V>?) -> PropertyMigrationType
//    func transformArray<U: StorableProperty, V: RawRepresentable>(fromElementType: U.Type, _ transformer: Array<U>? -> Array<V>?) -> PropertyMigrationType
//    func transformArray<U: RawRepresentable, V: RawRepresentable>(fromElementType: U.Type, _ transformer: Array<U>? -> Array<V>?) -> PropertyMigrationType
//    
//    func transformSet<U: RawRepresentable, V: StorableProperty>(fromElementType: U.Type, _ transformer: Set<U>? -> Set<V>?) -> PropertyMigrationType
//    func transformSet<U: StorableProperty, V: RawRepresentable>(fromElementType: U.Type, _ transformer: Set<U>? -> Set<V>?) -> PropertyMigrationType
//    func transformSet<U: RawRepresentable, V: RawRepresentable>(fromElementType: U.Type, _ transformer: Set<U>? -> Set<V>?) -> PropertyMigrationType
//    
//    func transformDictionary<T: StorableProperty, U: RawRepresentable, V: StorableProperty, W: RawRepresentable>(fromKeyType: T.Type, andElementType: U.Type, _ transformer: Dictionary<T, U>? -> Dictionary<V, W>?) -> PropertyMigrationType
//    func transformDictionary<T: StorableProperty, U: StorableProperty, V: StorableProperty, W: RawRepresentable>(fromKeyType: T.Type, andElementType: U.Type, _ transformer: Dictionary<T, U>? -> Dictionary<V, W>?) -> PropertyMigrationType
//    func transformDictionary<T: StorableProperty, U: RawRepresentable, V: StorableProperty, W: StorableProperty>(fromKeyType: T.Type, andElementType: U.Type, _ transformer: Dictionary<T, U>? -> Dictionary<V, W>?) -> PropertyMigrationType

}
