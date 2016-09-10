//
//  Result.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 26/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

public enum Result<T> {
    case Success(T)
    case Error(String)
    
    var value: T? {
        if case .Success(let value) = self {
            return value
        }
        
        return nil
    }
    
    var errorMessage: String? {
        if case .Error(let error) = self {
            return error
        }
        
        return nil
    }
    
    /** Transform the result without having to handle errors. Any encountered errors will be automatically propagated */
    func transform<R>(transformer: T -> R) -> Result<R> {
        switch self {
        case .Success(let value):
            return .Success(transformer(value))
        case .Error(let message):
            return .Error(message)
        }
    }
}