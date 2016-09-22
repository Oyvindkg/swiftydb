//
//  PropertyMigrationType.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 10/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

/** Type representing the migration of an existing property */
public protocol PropertyMigrationType {
    
    /**
     Rename the property
     
     - parameters:
        - newName: the new property name
     */
    func rename(newName: String) -> PropertyMigrationType
    
    /**
     Transform a property
     
     - parameters:
        - fromType: the type of the value currently in the database
        - transformer: a closure mapping the value from the database to its new value
     */
    func transform<U: StorableProperty, V: StorableProperty>(fromType: U.Type, _ transformer: U? -> V?) -> PropertyMigrationType
    
    /**
     Transform a property
     
     - parameters:
        - fromType: the type of the value currently in the database
        - transformer: a closure mapping the value from the database to its new value
     */
    func transform<U: RawRepresentable, V: RawRepresentable where U.RawValue: StorableProperty, V.RawValue: StorableProperty>(fromType: U.Type, _ transformer: U? -> V?) -> PropertyMigrationType
    
    /**
     Transform a property
     
     - parameters:
        - fromType: the type of the value currently in the database
        - transformer: a closure mapping the value from the database to its new value
     */
    func transform<U: RawRepresentable, V: StorableProperty where U.RawValue: StorableProperty>(fromType: U.Type, _ transformer: U? -> V?) -> PropertyMigrationType
    
    /**
     Transform a property
     
     - parameters:
        - fromType: the type of the value currently in the database
        - transformer: a closure mapping the value from the database to its new value
     */
    func transform<U: StorableProperty, V: RawRepresentable where V.RawValue: StorableProperty>(fromType: U.Type, _ transformer: U? -> V?) -> PropertyMigrationType
    
    
    
    
    
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
