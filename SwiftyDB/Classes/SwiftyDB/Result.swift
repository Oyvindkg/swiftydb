//
//  Result.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 26/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

public enum Result<T> {
    case success(T)
    case error(String)
    
    var value: T? {
        if case .success(let value) = self {
            return value
        }
        
        return nil
    }
    
    var errorMessage: String? {
        if case .error(let error) = self {
            return error
        }
        
        return nil
    }
    
    /** Transform the result without having to handle errors. Any encountered errors will be automatically propagated */
    func transform<R>(transformer: T -> R) -> Result<R> {
        switch self {
        case .success(let value):
            return .success(transformer(value))
        case .error(let message):
            return .error(message)
        }
    }
}
