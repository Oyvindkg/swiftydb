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
    func transform<U: StorableValueConvertible, V: StorableValueConvertible>(fromType: U.Type, _ transformer: U? -> V?) -> PropertyMigrationType
    
    /**
     Transform a property
     
     - parameters:
        - fromType: the type of the value currently in the database
        - transformer: a closure mapping the value from the database to its new value
     */
    func transform<U: RawRepresentable, V: RawRepresentable where U.RawValue: StorableValueConvertible, V.RawValue: StorableValueConvertible>(fromType: U.Type, _ transformer: U? -> V?) -> PropertyMigrationType
    
    /**
     Transform a property
     
     - parameters:
        - fromType: the type of the value currently in the database
        - transformer: a closure mapping the value from the database to its new value
     */
    func transform<U: RawRepresentable, V: StorableValueConvertible where U.RawValue: StorableValueConvertible>(fromType: U.Type, _ transformer: U? -> V?) -> PropertyMigrationType
    
    /**
     Transform a property
     
     - parameters:
        - fromType: the type of the value currently in the database
        - transformer: a closure mapping the value from the database to its new value
     */
    func transform<U: StorableValueConvertible, V: RawRepresentable where V.RawValue: StorableValueConvertible>(fromType: U.Type, _ transformer: U? -> V?) -> PropertyMigrationType
    
    
    
    
    
//    func transformArrayOf<U: StorableValueConvertible, V: StorableValueConvertible>(fromElementType: U.Type, _ transformer: Array<U>? -> Array<V>?) -> PropertyMigrationType
//    func transformSetOf<U: StorableValueConvertible, V: StorableValueConvertible>(fromElementType: U.Type, _ transformer: Set<U>? -> Set<V>?) -> PropertyMigrationType
//
//    func transformArray<U: RawRepresentable, V: StorableValueConvertible>(fromElementType: U.Type, _ transformer: Array<U>? -> Array<V>?) -> PropertyMigrationType
//    func transformArray<U: StorableValueConvertible, V: RawRepresentable>(fromElementType: U.Type, _ transformer: Array<U>? -> Array<V>?) -> PropertyMigrationType
//    func transformArray<U: RawRepresentable, V: RawRepresentable>(fromElementType: U.Type, _ transformer: Array<U>? -> Array<V>?) -> PropertyMigrationType
//    
//    func transformSet<U: RawRepresentable, V: StorableValueConvertible>(fromElementType: U.Type, _ transformer: Set<U>? -> Set<V>?) -> PropertyMigrationType
//    func transformSet<U: StorableValueConvertible, V: RawRepresentable>(fromElementType: U.Type, _ transformer: Set<U>? -> Set<V>?) -> PropertyMigrationType
//    func transformSet<U: RawRepresentable, V: RawRepresentable>(fromElementType: U.Type, _ transformer: Set<U>? -> Set<V>?) -> PropertyMigrationType
//    
//    func transformDictionary<T: StorableValueConvertible, U: RawRepresentable, V: StorableValueConvertible, W: RawRepresentable>(fromKeyType: T.Type, andElementType: U.Type, _ transformer: Dictionary<T, U>? -> Dictionary<V, W>?) -> PropertyMigrationType
//    func transformDictionary<T: StorableValueConvertible, U: StorableValueConvertible, V: StorableValueConvertible, W: RawRepresentable>(fromKeyType: T.Type, andElementType: U.Type, _ transformer: Dictionary<T, U>? -> Dictionary<V, W>?) -> PropertyMigrationType
//    func transformDictionary<T: StorableValueConvertible, U: RawRepresentable, V: StorableValueConvertible, W: StorableValueConvertible>(fromKeyType: T.Type, andElementType: U.Type, _ transformer: Dictionary<T, U>? -> Dictionary<V, W>?) -> PropertyMigrationType

}
