//
//  SwiftyDB+Asynchronous.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 13/01/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import TinySQLite

public enum Result<A: Any> {
    case Success(A)
    case Error(ErrorType)
    
    public var isSuccess: Bool {
        return data != nil
    }
    
    public var data: A? {
        if case .Success(let data) = self {
            return data
        }
        return nil
    }
    
    public var error: ErrorType? {
        if case .Error(let error) = self {
            return error
        }
        return nil
    }
}

extension SwiftyDB {
    
    /** A global queue with default priority */
    private var queue: dispatch_queue_t {
        return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    }
    
    
    /**
     Asynchronous add object to the database
     
     - parameter object:    object to be added to the database
     - parameter update:    indicates whether the record should be updated if already present
     */
    
    public func asyncAddObject <S: Storable> (object: S, update: Bool = true, withCompletionHandler completionHandler: ((Result<Bool>)->Void)) {
        dispatch_async(queue) { () -> Void in
            do {
                try self.addObject(object)
                completionHandler(Result.Success(true))
            } catch let error {
                completionHandler(Result.Error(error))
            }
        }
    }
    
    /**
     Asynchronous add objects to the database
     
     - parameter objects:    objects to be added to the database
     - parameter update:     indicates whether the record should be updated if already present
     */
    
    public func asyncAddObjects <S: Storable> (objects: [S], update: Bool = true, withCompletionHandler completionHandler: ((Result<Bool>)->Void)) {
        dispatch_async(queue) { () -> Void in
            do {
                try self.addObjects(objects)
                completionHandler(Result.Success(true))
            } catch let error {
                completionHandler(Result.Error(error))
            }
        }
    }
    
    /**
     Asynchronous retrieval of data for a specified type, matching a set of filters, from the database
     
     - parameter filters:   dictionary containing the filters identifying objects to be retrieved
     - parameter type:      type of the objects to be retrieved
    */
    
    public func asyncDataForType <S: Storable> (type: S.Type, matchingFilters filters: [String: SQLiteValue?] = [:], withCompletionHandler completionHandler: ((Result<[[String: SQLiteValue?]]>)->Void)) {
        
        dispatch_async(queue) { () -> Void in
            do {
                let data = try self.dataForType(type, matchingFilters: filters)
                completionHandler(Result.Success(data))
            } catch let error {
                completionHandler(Result.Error(error))
            }
        }
    }
    
    /**
     Remove objects of a specified type, matching a set of filters, from the database
     
     - parameter filters:   dictionary containing the filters identifying objects to be deleted
     - parameter type:      type of the objects to be deleted
     */
    
    public func asyncDeleteObjectsForType (type: Storable.Type, matchingFilters filters: [String: SQLiteValue?] = [:], withCompletionHandler completionHandler: ((Result<Bool>)->Void)) {
        dispatch_async(queue) { () -> Void in
            do {
                try self.deleteObjectsForType(type, matchingFilters: filters)
                completionHandler(Result.Success(true))
            } catch let error {
                completionHandler(Result.Error(error))
            }
        }
    }
}

extension SwiftyDB {
    
    /**
     Asynchronous retrieval of objects of a specified type, matching a set of filters, from the database
     
     - parameter filters:   dictionary containing the filters identifying objects to be retrieved
     - parameter type:      type of the objects to be retrieved
    */
    
    public func asyncObjectsForType <D where D: Storable, D: NSObject> (type: D.Type, matchingFilters filters: [String: SQLiteValue?] = [:], withCompletionHandler completionHandler: ((Result<[D]>)->Void)) {
        
        dispatch_async(queue) { () -> Void in
            do {
                let objects = try self.objectsForType(type, matchingFilters: filters)
                completionHandler(Result.Success(objects))
            } catch let error {
                completionHandler(Result.Error(error))
            }
        }
    }
}