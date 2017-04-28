//
//  ObjectMapperTests.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 28/04/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import Nimble

@testable import SwiftyDB

class TestStorableClass: Storable {
    
    let manager: FunctionCallManager
    
    var id: UUID
    var size: Double
    
    init(testCase: XCTestCase) {
        self.manager = FunctionCallManager(testCase: testCase)
        
        self.id   = UUID()
        self.size = 10
    }
    
    func map<M>(using mapper: inout M) where M : Mapper {
        manager.calledFunction(withParameters: mapper)
        
        id   <- mapper["id"]
        size <- mapper["size"]
    }
    
    static func mappableObject() -> Mappable {
        return TestStorableClass(testCase: XCTestCase())
    }
    
    static func identifier() -> String {
        return "id"
    }
}

public class ObjectMapperTests: XCTestCase {
    
    func testMapperReadsObjectUsingMap() {
        
        let object = TestStorableClass(testCase: self)
        
        _ = ObjectMapper.read(object)
        
        object.manager.expect(function: "map(using:)")
        object.manager.verify()
    }
    
    func testMapperReadsObjectsUsingMap() {
        
        let object = TestStorableClass(testCase: self)
        let otherObject = TestStorableClass(testCase: self)
        
        _ = ObjectMapper.read(objects: [object, otherObject])
        
        object.manager.expect(function: "map(using:)")
        object.manager.verify()
        
        otherObject.manager.expect(function: "map(using:)")
        otherObject.manager.verify()
    }
    
    func testMapperReturnsOneReaderPerObject() {
        
        let sansa = Stark(name: "Sansa", weight: 60, age: 13)
        let arya  = Stark(name: "Arya", weight: 50, age: 11)
        
        expect(ObjectMapper.read(objects: [sansa])).to(haveCount(1))
        expect(ObjectMapper.read(objects: [sansa, arya])).to(haveCount(2))
    }
    
    
    func testMapperWritesObjectUsingMap() {
        
        let writer = Writer(type: TestStorableClass.self)
        
        writer.storableValues = ["id": UUID().rawValue, "size": Double(100).rawValue]
        
        let object: TestStorableClass = ObjectMapper.object(mappedBy: writer)
        
        expect(object.id) == UUID(uuidString: writer.storableValues["id"] as! String)
        expect(object.size) == writer.storableValues["size"] as? Double
    }
    
    func testMapperWritesObjectsUsingMap() {
        
        let writer = Writer(type: TestStorableClass.self)
        
        writer.storableValues = ["id": UUID().uuidString, "size": Double(100)]
        
        let objects: [TestStorableClass] = ObjectMapper.objects(mappedBy: [writer, writer])
        
        expect(objects[0].id) == UUID(uuidString: writer.storableValues["id"] as! String)
        expect(objects[0].size) == writer.storableValues["size"] as? Double
        
        expect(objects[1].id) == UUID(uuidString: writer.storableValues["id"] as! String)
        expect(objects[1].size) == writer.storableValues["size"] as? Double
    }
    
    func testMapperReturnsOneObjectPerWriter() {
        
        let writer = Writer(type: TestStorableClass.self)
        
        writer.storableValues = ["id": UUID().uuidString, "size": Double(100)]
        
        expect(ObjectMapper.objects(mappedBy: [writer]) as [TestStorableClass]).to(haveCount(1))
        expect(ObjectMapper.objects(mappedBy: [writer, writer]) as [TestStorableClass]).to(haveCount(2))
    }
}
