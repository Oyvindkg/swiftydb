//
//  FunctionCallManager.swift
//  FlowMotionApp
//
//  Created by Øyvind Grimnes on 20/03/17.
//  Copyright © 2017 FlowMotion. All rights reserved.
//

import Foundation
import XCTest

/** Represents a function call */
struct FunctionCall {
    let function: String
    let parameters: [Any?]
    
    let fromFile: String
    let fromLine: Int
}


fileprivate struct Expectation {
    var name: String
    var count: Int
    var arguments: [Any?]
}

/** Used to register function calls and parameters when testing immutable protocols */
class FunctionCallManager {
    
    /** All calls registered in the manager's lifetime */
    fileprivate var calls: [FunctionCall] = []
    
    fileprivate var testCase: XCTestCase
    fileprivate var expectations: [Expectation] = []
    
    init(testCase: XCTestCase) {
        self.testCase = testCase
    }
    
    
    /** Expect a function to be called */
    func expect(function name: String, arguments: [Any?] = [], count: Int = 1) {
        let expectation = Expectation(name: name, count: count, arguments: arguments)
        
        expectations.append(expectation)
    }
    
    func verifyExpectations(file: String = #file, line: UInt = #line) {
        for expectation in expectations {
            let count = numberOfCalls(toFunction: expectation.name)
            
            if count != expectation.count {
                self.testCase.recordFailure(withDescription: "Expected \(expectation.count) call(s) to '\(expectation.name)', but received \(count)", inFile: file, atLine: line, expected: false)
            }
        }
    }
    
    /** Verify that the functions called are the expected values */
    func verify(file: String = #file, line: UInt = #line) {
        
        verifyExpectations(file: file, line: line)
        
        for functionCall in calls {
            let isExpected = expectations.contains { expectation -> Bool in
                return functionCall.function == expectation.name
            }
            
            if !isExpected {
                self.testCase.recordFailure(withDescription: "Received unexpected call to \(functionCall.function) with parameters \(functionCall.parameters)", inFile: file, atLine: line, expected: false)
            }
        }
        
        expectations = []  //TODO: Should this be cleared?
    }
    
    /** Register a new function call with the provided parameters */
    func calledFunction(withParameters parameters: Any?..., file: String = #file, line: Int = #line, function: String = #function) {
        let call = FunctionCall(function: function, parameters: parameters, fromFile: file, fromLine: line)
        
        calls.append(call)
    }
    
    /** All calls for a function in the manager's lifetime */
    internal func calls(toFunction function: String) -> [FunctionCall] {
        return calls.filter { call in
            return call.function == function
        }
    }
    
    /** The call count for a function in the manager's lifetime */
    fileprivate func numberOfCalls(toFunction function: String) -> Int {
        return calls(toFunction: function).count
    }
    
    /** The last registered call to a function in the manager's lifetime */
    internal func lastCall(toFunction function: String) -> FunctionCall? {
        return calls(toFunction: function).last
    }
}

