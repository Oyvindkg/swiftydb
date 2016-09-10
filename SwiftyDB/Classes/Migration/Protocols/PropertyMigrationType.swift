//
//  PropertyMigrationType.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 10/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

public protocol PropertyMigrationType {
    func rename(newName: String) -> PropertyMigrationType
    func transform<U: StoreableValueConvertible, V: StoreableValueConvertible>(oldType: U.Type, to newType: V.Type, _ transform: U? -> V?) -> PropertyMigrationType
    
    func transform<U: StoreableValueConvertible, V: StoreableValueConvertible>(previousType: [U].Type, to currentType: [V].Type, _ transform: [U]? -> [V]?) -> PropertyMigrationType
    func transform<U: StoreableValueConvertible, V: StoreableValueConvertible>(previousType: Set<U>.Type, to currentType: Set<V>.Type, _ transform: Set<U>? -> Set<V>?) -> PropertyMigrationType
    
    //    func transform<U: RawRepresentable, V: StoreableValueConvertible>(oldType: U.Type, to newType: V.Type, _ transform: U? -> V?) -> PropertyMigrationType
    //    func transform<U: StoreableValueConvertible, V: RawRepresentable>(oldType: U.Type, to newType: V.Type, _ transform: U? -> V?) -> PropertyMigrationType
    //
    //    func transform<U: RawRepresentable, V: StoreableValueConvertible>(oldType: [U].Type, to newType: [V].Type, _ transform: [U]? -> [V]?) -> PropertyMigrationType
    //    func transform<U: StoreableValueConvertible, V: RawRepresentable>(oldType: [U].Type, to newType: [V].Type, _ transform: [U]? -> [V]?) -> PropertyMigrationType
}