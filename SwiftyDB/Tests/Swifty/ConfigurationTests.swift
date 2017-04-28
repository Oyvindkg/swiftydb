//
//  ConfigurationTests.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 28/04/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import Nimble

@testable import SwiftyDB

public class ConfigurationTests: XCTestCase {
    
    func testDefaultDirectoryIsUserDocumentsDirectory() {
        let configuration = Database.Configuration(name: "Hamlet")
        
        let userDocuments = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        expect(configuration.directory) == userDocuments
    }
    
    func testLocationWhenInNormalModeIsInASubdirectory() {
        var configuration = Database.Configuration(name: "Hamlet")
        
        configuration.mode = .normal
        
        expect(configuration.location) == configuration.directory.appendingPathComponent("Hamlet").appendingPathComponent("normal")
    }
    
    func testLocationForModeIsInTheConfigurationsDirectory() {
        let directory = URL(fileURLWithPath: "")
        
        var configuration = Database.Configuration(name: "Hamlet")
        
        configuration.directory = directory
        
        expect(configuration.location(for: .normal)) == directory.appendingPathComponent("Hamlet").appendingPathComponent("normal")
    }
    
    func testLocationWhenInSandboxModeIsInASubdirectory() {
        var configuration = Database.Configuration(name: "Hamlet")
        
        configuration.mode = .sandbox
        
        expect(configuration.location) == configuration.directory.appendingPathComponent("Hamlet").appendingPathComponent("sandbox")
    }
    
    func testLocationForSandboxModeIsInASubdirectory() {
        var configuration = Database.Configuration(name: "Hamlet")
        
        expect(configuration.location(for: .sandbox)) == configuration.directory.appendingPathComponent("Hamlet").appendingPathComponent("sandbox")
    }
    
    func testLocationForNormalModeIsInASubdirectory() {
        var configuration = Database.Configuration(name: "Hamlet")
        
        expect(configuration.location(for: .normal)) == configuration.directory.appendingPathComponent("Hamlet").appendingPathComponent("normal")
    }
}
