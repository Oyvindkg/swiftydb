//
//  Result.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 26/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

/** 
 An enum containing the results from a query
 
 If the query is successful, a .success will be returned containing any data retrieved from the database.
 
 If the query is unsuccessful, a .error will be returnec containing an error message
 */
public enum Result<T> {
    case success(T)
    case error(String)
    
    /** Data retrieved from the database */
    var value: T? {
        if case .success(let value) = self {
            return value
        }
        
        return nil
    }
    
    /** Message describing any encountered errors */
    var errorMessage: String? {
        if case .error(let error) = self {
            return error
        }
        
        return nil
    }
    
    /** 
     Transform the result without having to handle errors. Any encountered errors will be automatically propagated 
     
     - parameters:
        - transformer: closure used to transform any wrapped value
     */
    func transform<R>(transformer: T -> R) -> Result<R> {
        switch self {
        case .success(let value):
            return .success(transformer(value))
        case .error(let message):
            return .error(message)
        }
    }
}
