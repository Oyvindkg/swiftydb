//
//  Map.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 19/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

public protocol AnyMapper {
}

public protocol Mapper: AnyMapper {
    subscript(key: String) -> Self { get }
    
    static func <- <T: StorableProperty>(left: inout Array<T>, right: Self)
    static func <- <T: StorableProperty>(left: inout Array<T>?, right: Self)
    static func <- <T: StorableProperty>(left: inout Array<T>!, right: Self)
    
    static func <- <T: StorableProperty>(left: inout Set<T>, right: Self) where T.StorableValueType : Hashable
    static func <- <T: StorableProperty>(left: inout Set<T>?, right: Self) where T.StorableValueType : Hashable
    static func <- <T: StorableProperty>(left: inout Set<T>!, right: Self) where T.StorableValueType : Hashable
    
    static func <- <T: StorableProperty>(left: inout T, right: Self)
    static func <- <T: StorableProperty>(left: inout T?, right: Self)
    static func <- <T: StorableProperty>(left: inout T!, right: Self)
    
    static func <- <T: RawRepresentable>(left: inout T, right: Self) where T.RawValue : StorableProperty
    static func <- <T: RawRepresentable>(left: inout T?, right: Self) where T.RawValue : StorableProperty
    static func <- <T: RawRepresentable>(left: inout T!, right: Self) where T.RawValue : StorableProperty
    
    static func <- <T: RawRepresentable>(left: inout Array<T>, right: Self) where T.RawValue : StorableProperty
    static func <- <T: RawRepresentable>(left: inout Array<T>?, right: Self) where T.RawValue : StorableProperty
    static func <- <T: RawRepresentable>(left: inout Array<T>!, right: Self) where T.RawValue : StorableProperty
    
    static func <- <T: RawRepresentable>(left: inout Set<T>, right: Self) where T.RawValue : StorableProperty, T.RawValue : Hashable
    static func <- <T: RawRepresentable>(left: inout Set<T>?, right: Self) where T.RawValue : StorableProperty, T.RawValue : Hashable
    static func <- <T: RawRepresentable>(left: inout Set<T>!, right: Self) where T.RawValue : StorableProperty, T.RawValue : Hashable
    
    static func <- <T: Storable>(left: inout Array<T>, right: Self)
    static func <- <T: Storable>(left: inout Array<T>?, right: Self)
    static func <- <T: Storable>(left: inout Array<T>!, right: Self)
    
    static func <- <T: Storable>(left: inout Set<T>, right: Self)
    static func <- <T: Storable>(left: inout Set<T>?, right: Self)
    static func <- <T: Storable>(left: inout Set<T>!, right: Self)
    
    static func <- <T: Storable>(left: inout T, right: Self)
    static func <- <T: Storable>(left: inout T?, right: Self)
    static func <- <T: Storable>(left: inout T!, right: Self)
}
