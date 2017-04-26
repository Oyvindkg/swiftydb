//
//  TestClass.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 30/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import SwiftyDB

enum TestEnum: Int {
    case first  = 0
    case second
    case third
}

class TestClass: Storable {
    
    // MARK: Non-optionals
    
    var string                  = "string"
    var character               = Character("c")
    
    var bool                    = true
    
    var rawRepresentable: TestEnum         = TestEnum.first
    var rawRepresentableArray: [TestEnum]  = [TestEnum.first, TestEnum.second]
    var rawRepresentableSet: Set<TestEnum> = [TestEnum.first]
    
    var int                     = Int.max
    var int8: Int8              = Int8.max
    var int16: Int16            = Int16.max
    var int32: Int32            = Int32.max
    var int64: Int64            = Int64.max
    
    var uint: UInt              = UInt.max
    var uint8: UInt8            = UInt8.max
    var uint16: UInt16          = UInt16.max
    var uint32: UInt32          = UInt32.max
    var uint64: UInt64          = UInt64.max
    
    var double: Double          = .greatestFiniteMagnitude
    var float: Float            = .greatestFiniteMagnitude
    
    var date                    = Date()
    
    var data                    = "data".data(using: .utf8)!
    
    var number                  = NSNumber(value: 123.213231)
    
    var storableArray          = [Wolf(name: "Doggy", age: 1), Wolf(name: "Lady", age: 5)]
    var storableSet: Set<Wolf> = [Wolf(name: "Doggy", age: 1), Wolf(name: "Lady", age: 5)]
    var storable               = Wolf(name: "Ghost", age: 9)
    
    var stringArray: [String]   = ["string", "otherString"]
    var intArray: [Int]         = [1,23,32]
    var doubleArray: [Double]   = [42.0,123.0,41.0]
    
    // MARK: - Optionals
    
    var optionalString: String?         = "string"
    var optionalCharacter: Character?   = Character("d")
    
    var optionalBool: Bool?             = true
    
    var optionalRawRepresentable: TestEnum?         = TestEnum.first
    var optionalRawRepresentableArray: [TestEnum]?  = [TestEnum.first, TestEnum.second]
    var optionalRawRepresentableSet: Set<TestEnum>? = [TestEnum.first, TestEnum.second]
    
    var optionalInt: Int?               = Int.max
    var optionalInt8: Int8?             = Int8.max
    var optionalInt16: Int16?           = Int16.max
    var optionalInt32: Int32?           = Int32.max
    var optionalInt64: Int64?           = Int64.max
    
    var optionalUint: UInt?             = UInt.max
    var optionalUint8: UInt8?           = UInt8.max
    var optionalUint16: UInt16?         = UInt16.max
    var optionalUint32: UInt32?         = UInt32.max
    var optionalUint64: UInt64?         = UInt64.max
    
    var optionalDouble: Double?         = .greatestFiniteMagnitude
    var optionalFloat: Float?           = .greatestFiniteMagnitude
    
    var optionalDate: Date?           = Date()
    
    var optionalData: Data?           = "data".data(using: .utf8)
    
    var optionalNumber: NSNumber?       = 1.312
    
    var optionalStorableArray: [Wolf]?         = [Wolf(name: "Doggy", age: 1), Wolf(name: "Lady", age: 5)]
    var optionalStorableSet: Set<Wolf>?        = [Wolf(name: "Doggy", age: 1), Wolf(name: "Lady", age: 5)]
    var optionalStorable: Wolf?                = Wolf(name: "Ghost", age: 9)
    
    var optionalStringArray: [String]?          = ["string", "otherString"]
    var optionalIntArray: [Int]?                = [1,23,32]
    var optionalDoubleArray: [Double]?          = [42,123,41]
    
}

extension TestClass: Mappable {
    static func mappableObject() -> Mappable {
        return TestClass()
    }
    
    func map<M>(using mapper: inout M) where M : Mapper {
        string          <- mapper["string"]
        character       <- mapper["character"]
        
        bool            <- mapper["bool"]
        
        int             <- mapper["int"]
        int8            <- mapper["int8"]
        int16           <- mapper["int16"]
        int32           <- mapper["int32"]
        int64           <- mapper["int64"]
        uint            <- mapper["uint"]
        uint8           <- mapper["uint8"]
        uint16          <- mapper["uint16"]
        uint32          <- mapper["uint32"]
        uint64          <- mapper["uint64"]
        
        double          <- mapper["double"]
        float           <- mapper["float"]
        
        date            <- mapper["date"]
        data            <- mapper["data"]
        number          <- mapper["number"]
        
        storableArray  <- mapper["storableArray"]
        storableSet    <- mapper["storableSet"]
        storable       <- mapper["storable"]
        
        stringArray     <- mapper["stringArray"]
        intArray        <- mapper["intArray"]
        doubleArray     <- mapper["doubleArray"]
        
        
        optionalString      <- mapper["optionalString"]
        optionalCharacter   <- mapper["optionalCharacter"]
        
        optionalBool        <- mapper["optionalBool"]
        
        optionalInt         <- mapper["optionalInt"]
        optionalInt8        <- mapper["optionalInt8"]
        optionalInt16       <- mapper["optionalInt16"]
        optionalInt32       <- mapper["optionalInt32"]
        optionalInt64       <- mapper["optionalInt64"]
        
        optionalUint        <- mapper["optionalUint"]
        optionalUint8       <- mapper["optionalUint8"]
        optionalUint16      <- mapper["optionalUint16"]
        optionalUint32      <- mapper["optionalUint32"]
        optionalUint64      <- mapper["optionalUint64"]
        
        optionalDouble      <- mapper["optionalDouble"]
        optionalFloat       <- mapper["optionalFloat"]
        
        optionalDate        <- mapper["optionalDate"]
        optionalData        <- mapper["optionalData"]
        optionalNumber      <- mapper["optionalNumber"]
        
        optionalStorableArray  <- mapper["optionalStorableArray"]
        optionalStorableSet    <- mapper["optionalStorableSet"]
        optionalStorable       <- mapper["optionalStorable"]
        
        optionalStringArray     <- mapper["optionalStringArray"]
        optionalIntArray        <- mapper["optionalIntArray"]
        optionalDoubleArray     <- mapper["optionalDoubleArray"]
    }
}

extension TestClass: Identifiable {
    static func identifier() -> String {
        return "string"
    }
}
