//
//  TestClass.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 30/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import SwiftyDB

class TestClass: Storable {
    
    // MARK: Non-optionals
    
    var string                  = "string"
    var character               = Character("c")
    
    var bool                    = true
    
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
    
    var double                  = DBL_MAX
    var float: Float            = FLT_MAX
    
    var date                    = NSDate()
    
    var data                    = NSData(base64Encoded: "data", options: [])!
    
    var number                  = NSNumber(value: 123.213231)
    
    var storableArray          = [Wolf(name: "Doggy", age: 1), Wolf(name: "Lady", age: 5)]
    var storableSet: Set<Wolf> = [Wolf(name: "Doggy", age: 1), Wolf(name: "Lady", age: 5)]
    var storable               = Wolf(name: "Ghost", age: 9)
    
    var stringArray             = ["string", "otherString"]
    var intArray                = [1,23,32]
    var doubleArray             = [42,123,41]
    
    // MARK: - Optionals
    
    var optionalString: String?         = "string"
    var optionalCharacter: Character?   = Character("d")
    
    var optionalBool: Bool?             = true
    
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
    
    var optionalDate: NSDate?           = NSDate()
    
    var optionalData: NSData?           = NSData(base64Encoded: "optionalData", options: [])
    
    var optionalNumber: NSNumber?       = 1.312
    
    var optionalStorableArray: [Wolf]?         = [Wolf(name: "Doggy", age: 1), Wolf(name: "Lady", age: 5)]
    var optionalStorableSet: Set<Wolf>?        = [Wolf(name: "Doggy", age: 1), Wolf(name: "Lady", age: 5)]
    var optionalStorable: Wolf?                = Wolf(name: "Ghost", age: 9)
    
    var optionalStringArray: [String]?          = ["string", "otherString"]
    var optionalIntArray: [Int]?                = [1,23,32]
    var optionalDoubleArray: [Double]?          = [42,123,41]
    
}

extension TestClass: Mappable {
    static func mappableObject() -> Any {
        return TestClass()
    }
    
    func mapping(map: Map) {
        string          <- map["string"]
        character       <- map["character"]
        
        bool            <- map["bool"]
        
        int             <- map["int"]
        int8            <- map["int8"]
        int16           <- map["int16"]
        int32           <- map["int32"]
        int64           <- map["int64"]
        uint            <- map["uint"]
        uint8           <- map["uint8"]
        uint16          <- map["uint16"]
        uint32          <- map["uint32"]
        uint64          <- map["uint64"]
        
        double          <- map["double"]
        float           <- map["float"]
        
        date            <- map["date"]
        data            <- map["data"]
        number          <- map["number"]
        
        storableArray  <- map["storableArray"]
        storableSet    <- map["storableSet"]
        storable       <- map["storable"]
        
        stringArray     <- map["stringArray"]
        intArray        <- map["intArray"]
        doubleArray     <- map["doubleArray"]
        
        
        optionalString      <- map["optionalString"]
        optionalCharacter   <- map["optionalCharacter"]
        
        optionalBool        <- map["optionalBool"]
        
        optionalInt         <- map["optionalInt"]
        optionalInt8        <- map["optionalInt8"]
        optionalInt16       <- map["optionalInt16"]
        optionalInt32       <- map["optionalInt32"]
        optionalInt64       <- map["optionalInt64"]
        
        optionalUint        <- map["optionalUint"]
        optionalUint8       <- map["optionalUint8"]
        optionalUint16      <- map["optionalUint16"]
        optionalUint32      <- map["optionalUint32"]
        optionalUint64      <- map["optionalUint64"]
        
        optionalDouble      <- map["optionalDouble"]
        optionalFloat       <- map["optionalFloat"]
        
        optionalDate        <- map["optionalDate"]
        optionalData        <- map["optionalData"]
        optionalNumber      <- map["optionalNumber"]
        
        optionalStorableArray  <- map["optionalStorableArray"]
        optionalStorableSet    <- map["optionalStorableSet"]
        optionalStorable       <- map["optionalStorable"]
        
        optionalStringArray     <- map["optionalStringArray"]
        optionalIntArray        <- map["optionalIntArray"]
        optionalDoubleArray     <- map["optionalDoubleArray"]
    }
}

extension TestClass: Identifiable {
    static func identifier() -> String {
        return "string"
    }
}
