//
//  Result.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 15/01/16.
//

import Foundation

/** Enum used to return the results of a query */
public enum Result<A: Any>: BooleanType {
    
    /** The result was successful. Contains any data returned */
    case Success(A)
    /** The result was unsuccessful. Contains an error message */
    case Error(ErrorType)
    
// MARK: - Properties
    
    /** Indicates whether the query was a success, or not */
    public var isSuccess: Bool {
        return value != nil
    }
    
    /** Identical to isSuccess. Used to conveniently detect errors in control statements such as 'if' */
    public var boolValue: Bool { return isSuccess }
    
    /** Value returned from query. Nil if an error was thrown */
    public var value: A? {
        if case .Success(let value) = self {
            return value
        }
        return nil
    }
    
    /** The thrown error. Nil if the query was a success */
    public var error: ErrorType? {
        if case .Error(let error) = self {
            return error
        }
        return nil
    }
}